Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaKQRC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 12:02:28 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:58926 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaKQRCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 12:02:25 -0500
Date: Mon, 17 Nov 2014 09:02:15 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: Tree for Nov 14
Message-ID: <20141117170215.GC28915@roeck-us.net>
References: <20141114192738.08e744cc@canb.auug.org.au>
 <20141115211922.GA2347@roeck-us.net>
 <54680D0A.7070900@linux.intel.com>
 <5468185D.5020400@roeck-us.net>
 <546983B1.6060105@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546983B1.6060105@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.546A2A21.003C,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
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

On Mon, Nov 17, 2014 at 01:12:17PM +0800, Jiang Liu wrote:
> On 2014/11/16 11:22, Guenter Roeck wrote:
> > On 11/15/2014 06:33 PM, Jiang Liu wrote:
> >> Hi Guenter,
> >>     Could you please help to provide the config file and
> >> error messages?
> > 
> > Config file:
> >     https://github.com/groeck/linux-build-test/blob/master/rootfs/x86/qemu_x86_pc_nosmp_defconfig
> > 
> > 
> > Error log:
> >     http://server.roeck-us.net:8010/builders/qemu-x86-next/builds/44/steps/qemubuildcommand/logs/stdio
> > 
> > 
> > You can find the root file system used for the test as well as the test
> > script at
> >     https://github.com/groeck/linux-build-test/tree/master/rootfs/x86
> > 
> > There isn't really an error message, though - the boot stalls until the
> > controlling daemon
> > kills the qemu session.
> Hi Guenter,
> 	With the test suite at
> https://github.com/groeck/linux-build-test/tree/master/rootfs/x86
> and configuration file qemu_x86_pc_nosmp_defconfig, I have
> following findings:
> 1) disabling PCI_MSI, <OK>.
> 2) manually turning on X86_IO_APIC, <OK>.
> 3) with 3.16 kernel, disabling PCI_MSI, <OK>
> 4) with 3.16 kernel, disabling PCI_MSI, enabling X86_UP_APIC, <fail>
> 
> So the root cause is that KVM doesn't support the configuration with
> LOCAL_APIC enabled but IO_APIC disabled, though this configuration
> works with bare-metal machines.
> There are two possible solutions here:
> 1) ALways enalbe IO_APIC if KVM is enabled.
> 2) Enhance KVM to support LOCAL_APIC when IOAPIC is disabled.
> 
> But I'm not familiar with KVM and don't know how to achieve solution 2.
> Any suggestions?

I don't understand KVM well enough either. For my part I don't understand why
APIC configuration in the kernel differs between the SMP and the non-SMP case
(ie why X86_IO_APIC is enabled for smp but not for non-smp). After all, the
hardware does not change. On the other side I don't have to understand it ;-).

I "solved" the problem in my test scripts by disabling PCI_MSI for the
x86/non-smp test. That doesn't really solve anything, but there is only
so much I can do.

Thanks,
Guenter
