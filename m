Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3KUWTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 17:19:51 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42961 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab3KUWTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 17:19:49 -0500
Date: Thu, 21 Nov 2013 23:19:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jerry Hoemann <jerry.hoemann@hp.com>
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org,
        akpm@linux-foundation.org, bp@suse.de, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        penberg@kernel.org, mingo.kernel.org@gmail.com, vgoyal@redhat.com
Subject: Re: [RFC v2 2/2] x86, efi: Early use of boot service memory
Message-ID: <20131121221940.GA25681@pd.tnic>
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
 <1385067686-73500-3-git-send-email-jerry.hoemann@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1385067686-73500-3-git-send-email-jerry.hoemann@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 02:01:26PM -0700, Jerry Hoemann wrote:
> Some platform have firmware that violate the UEFI spec and access boot service
> code or data segments after the system has called ExitBootServices().
> The call to efi_reserve_boot_services is a workaround to avoid using
> boot service memory until after the kernel has done SetVirtualAddressMap().
> However, this reservation fragments memory which can cause
> large allocations early in boot (e.g. crash kernel) to fail.
> 
> When reserve_crashkernel fails, kdump is disabled.
> 
> This patch creates a quirk list that governs when the workaround,
> efi_reserve_boot_services, is called.
> 
> For all firmware released prior to 2014, the workaround will be
> called unless an entry for the platform is in the quirk list saying
> not to do the workaround.
> 
> For all firmware released 2014 and later,  the workaround will not
> be called unless an entry for the platform is in the quirk list
> saying to call the workaround.

This is yet another quirk list which can grow uncontrolled considering
the notoriety of firmware bugs. And since detecting such spec violation
is very simple - boot Linux on the machine - we should rather disable
this by default for FW >= 2014 and make this test part of the firmware
test suite so that vendors can get a chance to fix their BIOSen.

Provided vendors do boot fwts on their validation platforms, that is.

Yo Fleming, got a better idea? :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
