Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab3AWAsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:48:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab3AWAsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:48:06 -0500
From: Thomas Renninger <trenn@suse.de>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: yinghai@kernel.org, muneda.takahiro@jp.fujitsu.com,
        linux-pci@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, hpa@zytor.com,
        bhelgaas@google.com, tglx@linutronix.de, khalid@gonehiking.org
Subject: Re: [PATCH v7 0/5] Reset PCIe devices to address DMA problem on kdump with iommu
Date: Wed, 23 Jan 2013 01:47:56 +0100
Message-ID: <1508535.gXZDAVy6sT@hammer82.arch.suse.de>
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <50FC95A8.6060402@jp.fujitsu.com>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local> <1593084.QhbTkmoq3N@hammer82.arch.suse.de> <50FC95A8.6060402@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 21, 2013 10:11:04 AM Takao Indoh wrote:
> (2013/01/08 4:09), Thomas Renninger wrote:
...
> > I tried the provided patches first on 2.6.32, then I verfied with 3.8-rc2
> > and in both cases the disk is not detected anymore in
> > reset_devices (kexec'ed/kdump) case (but things work fine without these
> > patches).
> 
> So the problem that the disk is not detected was caused by exactmap
> problem you guys are discussing? Or still not detected even if exactmap
> problem is fixed?
This problem is related to the 5 PCI resetting patches.
Dumping worked with a 2.6.32 and a 3.8-rc2 kernel, adding the PCI resetting
patches broke both. I first tried 2.6.32 and verified with 3.8-rc2 to make sure
I didn't mess up the backport adjustings of the patches to 2.6.32.

Unfortunately this Dell platform takes really long to boot.
I can give it the one or other test, but please do not bomb me with patches.

For info:
About the interrupt remapping error interrupt storm in kdump case I tried to 
reproduce on this machine, but never could: The guys who saw that also cannot 
reproduce this anymore.

Two ideas I had about this:
  - As said already, (also) try to catch the error case and try to reset the
    the device in AER/Specific iterrupt remapping error interrupt caught.
  - Have a look at coreboot, these guys should know how to initialize the PCI
    subsystem from scratch and might have some well tested PCI resetting
    code in place already (no idea, just a thought).

    Thomas
