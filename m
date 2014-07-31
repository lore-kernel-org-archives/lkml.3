Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaGaQ4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:56:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59334 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbaGaQ4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:56:52 -0400
Date: Thu, 31 Jul 2014 18:56:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, irq: Keep IRQ assignment for PCI devices during
 suspend/hibernation
Message-ID: <20140731165648.GG4375@pd.tnic>
References: <20140730175836.GC10213@pd.tnic>
 <1406766807-5745-1-git-send-email-jiang.liu@linux.intel.com>
 <20140731103941.GA4375@pd.tnic>
 <53DA70AB.9010906@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53DA70AB.9010906@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 12:36:59AM +0800, Jiang Liu wrote:
> 1) There's a race window between device_shutdown() and
> syscore_shutdown(). USB device may be returned to BIOS
> during device_shutdown() and IOMMU units are disabled
> during syscore_shutdown().
> 2) Printing debug messages enlarges the race window,
> especially when using serial console.
> Then it triggers warning message "AMD-Vi: Event logged [IO_PAGE_FAULT
> device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]".
> 
> But I have no AMD platforms to verify this theory. Could you
> please help to try adding delays between device_shutdown()
> and syscore_shutdown() in function kernel_power_off()?

Ok, but this whole deal started appearing only after rc6. And this
ordering hasn't been touched recently, AFAICT. So it must be something
new...

I'm still trying to get that other system to trigger...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
