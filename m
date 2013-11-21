Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3KUXI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 18:08:27 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38199 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab3KUXIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 18:08:25 -0500
Date: Thu, 21 Nov 2013 23:07:44 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jerry Hoemann <jerry.hoemann@hp.com>
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org,
        akpm@linux-foundation.org, bp@suse.de, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        penberg@kernel.org, mingo.kernel.org@gmail.com, vgoyal@redhat.com
Subject: Re: [RFC v2 0/2] Early use of boot service memory
Message-ID: <20131121230744.GA31592@srcf.ucam.org>
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 02:01:24PM -0700, Jerry Hoemann wrote:
> 
> Some platform have firmware that violates the UEFI spec and access boot
> service code or data segments after the system has called ExitBootServices().
> The call to efi_reserve_boot_services in setup_arch is a workaround to
> avoid using boot service memory until after the kernel has done
> SetVirtualAddressMap.  However, this reservation fragments memory
> which can cause large allocations early in boot (e.g. crash kernel)
> to fail.

This is a problem we have to solve, but I don't think this is the right 
way to solve it. Why do we not just reattempt to perform the allocation 
immediately after we've freed the boot services regions?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
