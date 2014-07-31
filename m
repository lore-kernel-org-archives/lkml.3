Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaGaPVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:21:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55243 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaGaPVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:21:36 -0400
Date: Thu, 31 Jul 2014 17:21:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        iommu <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH] x86, irq: Keep IRQ assignment for PCI devices during
 suspend/hibernation
Message-ID: <20140731152132.GE4375@pd.tnic>
References: <20140730175836.GC10213@pd.tnic>
 <1406766807-5745-1-git-send-email-jiang.liu@linux.intel.com>
 <20140731103941.GA4375@pd.tnic>
 <53DA55A0.6070005@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53DA55A0.6070005@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 31, 2014 at 10:41:36PM +0800, Jiang Liu wrote:
> 	Really appreciate your help. There are two issues left
> according to the log messages.

first of all:

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

So please refrain from top-posting on lkml.

> 	The first issue is " WARNING: CPU: 2 PID: 3786 at
> fs/proc/generic.c:521 remove_proc_entry+0x19c/0x1b0()".
> It's caused by an issue in usb driver and a patch is ready to fix
> this issue, please refer to https://lkml.org/lkml/2014/7/20/277.
> This patch has been merged into Greg's usb repository, so it should
> be merge into v3.17 too.

I can apply this patch to test.

> 	The second issue is "AMD-Vi: Event logged [IO_PAGE_FAULT
> device=00:12.0 domain=0x0009 address=0x0000000000000000 flags=0x0000]".
> I feel it's not caused by IRQ related changes, but may be caused
> by IO page fault related work for AMD IOMMU. I need more time
> to investigate this and also CC Joerg for help too.

I don't think that's the issue - plain rc7 doesn't trigger the issue.
Only if I merge tip/master in it happens. And there are no AMD iommu
patches in tip/master since Joerg doesn't send stuff through tip
anymore.

> 	According to the log message, I feel my patch has fixed the
> original issue caused by IRQ related changes. What's your thoughts?

I still think the issue is in tip/master. I'm currently trying to
reproduce on another box so that I can bisect it. (Bisecting on my
workstation is always nasty :-\).

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
