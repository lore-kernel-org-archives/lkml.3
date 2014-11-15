Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaKOVTd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 16:19:33 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:43161 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbaKOVTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 16:19:31 -0500
Date: Sat, 15 Nov 2014 13:19:22 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: Tree for Nov 14
Message-ID: <20141115211922.GA2347@roeck-us.net>
References: <20141114192738.08e744cc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114192738.08e744cc@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.5467C363.00F3,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 07:27:38PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20141113:
> 
> New tree: overlayfs
> 
> The idle tree gained a conflict against Linus' tree.
> 
> The scsi tree gained a conflict against the usb tree.
> 
> Non-merge commits (relative to Linus' tree): 6264
>  6509 files changed, 209171 insertions(+), 167101 deletions(-)
> 

I bisected the x86-nosmp qemu runtime failure I have seen for
the last few days. Here is the result:

bb46613f7099f70bc68c1c684cfa22d6863cd8eb is the first bad commit
commit bb46613f7099f70bc68c1c684cfa22d6863cd8eb
Author: Jiang Liu <jiang.liu@linux.intel.com>
Date:   Mon Oct 27 16:12:06 2014 +0800

    x86, irq: Make MSI and HT_IRQ indepenent of X86_IO_APIC

Detailed log:

git bisect start 'HEAD' 'v3.18-rc4'
# good: [97bf3e2baed8f45432933bf15535061fb5acda44] Merge remote-tracking branch 'sound-asoc/for-next'
git bisect good 97bf3e2baed8f45432933bf15535061fb5acda44
# bad: [d23dcf93e7ad8004ef80726717f700316e53f44d] Merge remote-tracking branch 'usb-serial/usb-next'
git bisect bad d23dcf93e7ad8004ef80726717f700316e53f44d
# bad: [cff78d32f4c15b7b2cb173c8e6097c513f406da0] Merge remote-tracking branch 'kvm/linux-next'
git bisect bad cff78d32f4c15b7b2cb173c8e6097c513f406da0
# good: [09dc3f20206821e06b1b281b1ae4451777f707c4] Merge remote-tracking branch 'audit/next'
git bisect good 09dc3f20206821e06b1b281b1ae4451777f707c4
# bad: [caf0fea9e728916a92c508988fd2ae84a08c280b] Merge branch 'x86/vdso'
git bisect bad caf0fea9e728916a92c508988fd2ae84a08c280b
# good: [9aa5f98820067b00456c42347fc0ff48d2d2474f] Merge branch 'sched/urgent'
git bisect good 9aa5f98820067b00456c42347fc0ff48d2d2474f
# bad: [46fe562d914fde0a43ee339a0fcfd4af829cb8f7] Merge branch 'x86/boot'
git bisect bad 46fe562d914fde0a43ee339a0fcfd4af829cb8f7
# good: [b26ea43d0bb1539ce047206a57c7fd8d636e7f22] x86, irq: Protect __clear_irq_vector() with vector_lock
git bisect good b26ea43d0bb1539ce047206a57c7fd8d636e7f22
# bad: [e1d8f79a27a41493c8f1ad0bde440048e17f9494] iommu/amd: Use helpers to access irq_cfg data structure associated with IRQ
git bisect bad e1d8f79a27a41493c8f1ad0bde440048e17f9494
# good: [051825cab15c8180f2f0dbc3a9de5a3db7476065] x86, irq: Move HT IRQ related code from io_apic.c into htirq.c
git bisect good 051825cab15c8180f2f0dbc3a9de5a3db7476065
# bad: [bb46613f7099f70bc68c1c684cfa22d6863cd8eb] x86, irq: Make MSI and HT_IRQ indepenent of X86_IO_APIC
git bisect bad bb46613f7099f70bc68c1c684cfa22d6863cd8eb
# good: [b09198f7b59101e52bcf238ed3b7bfc64de055ef] x86, irq: Move IRQ initialization routines from io_apic.c into vector.c
git bisect good b09198f7b59101e52bcf238ed3b7bfc64de055ef
# first bad commit: [bb46613f7099f70bc68c1c684cfa22d6863cd8eb] x86, irq: Make MSI and HT_IRQ indepenent of X86_IO_APIC

I'll be happy to provide the configuration if needed.

Guenter
