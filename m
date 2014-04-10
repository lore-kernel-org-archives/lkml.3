Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934917AbaDJJDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:03:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42455 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934890AbaDJJCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:02:55 -0400
Date: Thu, 10 Apr 2014 11:02:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michal Simek <monstr@monstr.eu>
Cc: Punnaiah Choudary <kpc528@gmail.com>, Rob Herring <robherring2@gmail.com>,
        Punnaiah Choudary Kalluri 
	<punnaiah.choudary.kalluri@xilinx.com>,
        Doug Thompson <dougthompson@xmission.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        punnaiah choudary kalluri <kalluripunnaiahchoudary@gmail.com>,
        punnaiah choudary kalluri <punnaia@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC PATCH] edac: add support for ARM PL310 L2 cache parity
Message-ID: <20140410090246.GC29093@pd.tnic>
References: <1393770760-32550-1-git-send-email-punnaia@xilinx.com>
 <a1a9e47a-069c-4285-9899-d5a58cf532c2@CO9EHSMHS003.ehs.local>
 <20140409113246.GA8778@pd.tnic>
 <CAL_Jsq+gszc+R_BrLtHKEBGYd=3T+sE1d+-HoF9aYZt6C2k5-g@mail.gmail.com>
 <20140409151932.GK6529@pd.tnic>
 <CAHLkNHJTA5bGD1zAfzE2JrDFAWvmgYyYjir+4vR-d9Fe2-E48g@mail.gmail.com>
 <20140409174701.GO6529@pd.tnic>
 <53463641.1030800@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53463641.1030800@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 08:12:17AM +0200, Michal Simek wrote:
> I am just curious about this recommendation. Does it mean that we
> shouldn't use edac interface just for reporting problems?

Yes, we should. But, if you want to have two different drivers accessing
the hardware and have to build synchronization around it, I'm simply
putting the simplest solution on the table in case it is viable. If all
you want to do is report errors to dmesg, then you don't need the edac
stuff.

> I didn't play with it but I guess that there is a record about edac
> driver via sysfs, etc. You could read some useful information that you
> know what it is protected and I hope that edac interface bring any
> value to reporting errors comparing to just printk message from IRQ
> handler.

Yes, you can read error counts and DIMM layout. I'm adding a full dump
of sysfs on my machine at the end. Take a look at it and think whether
this could be something you could use/need/like.

But, if you have only one DIMM slot available on the hw (I'm not even
going to pretend to know your possible DIMM layouts) then maybe EDAC is
not needed at all - people would know which DIMM is at fault :-)

And so on and so on.

> My question is if using printk in IRQ handler and report problem is
> equal to reporting this via edac interface. Or it is just easy way
> to do but using edac interface is right solution and how to do it
> properly is different question.

Yeah, it would probably be easier if you would point out first what you
want to use the edac interface for and we can tell you whether it's
already there/doable/makes sense, etc.

Thanks.

/sys/devices/system/edac/mc/mc0/dbam:0x0000000000000077
/sys/devices/system/edac/mc/mc0/dhar:0x00000000c0004003
/sys/devices/system/edac/mc/mc0/inject_ecc_vector:0x0
/sys/devices/system/edac/mc/mc0/seconds_since_reset:169051
/sys/devices/system/edac/mc/mc0/ce_noinfo_count:0
/sys/devices/system/edac/mc/mc0/power/async:disabled
/sys/devices/system/edac/mc/mc0/rank0/size:2048
/sys/devices/system/edac/mc/mc0/rank0/power/async:disabled
/sys/devices/system/edac/mc/mc0/rank0/dimm_location:csrow 0 channel 0 
/sys/devices/system/edac/mc/mc0/rank0/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank0/dimm_mem_type:Unbuffered-DDR3
/sys/devices/system/edac/mc/mc0/rank0/dimm_label:mc#0csrow#0channel#0
/sys/devices/system/edac/mc/mc0/rank0/dimm_edac_mode:SECDED
/sys/devices/system/edac/mc/mc0/rank1/size:2048
/sys/devices/system/edac/mc/mc0/rank1/power/async:disabled
/sys/devices/system/edac/mc/mc0/rank1/dimm_location:csrow 0 channel 1 
/sys/devices/system/edac/mc/mc0/rank1/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank1/dimm_mem_type:Unbuffered-DDR3
/sys/devices/system/edac/mc/mc0/rank1/dimm_label:mc#0csrow#0channel#1
/sys/devices/system/edac/mc/mc0/rank1/dimm_edac_mode:SECDED
/sys/devices/system/edac/mc/mc0/rank2/size:2048
/sys/devices/system/edac/mc/mc0/rank2/power/async:disabled
/sys/devices/system/edac/mc/mc0/rank2/dimm_location:csrow 1 channel 0 
/sys/devices/system/edac/mc/mc0/rank2/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank2/dimm_mem_type:Unbuffered-DDR3
/sys/devices/system/edac/mc/mc0/rank2/dimm_label:mc#0csrow#1channel#0
/sys/devices/system/edac/mc/mc0/rank2/dimm_edac_mode:SECDED
/sys/devices/system/edac/mc/mc0/rank3/size:2048
/sys/devices/system/edac/mc/mc0/rank3/power/async:disabled
/sys/devices/system/edac/mc/mc0/rank3/dimm_location:csrow 1 channel 1 
/sys/devices/system/edac/mc/mc0/rank3/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank3/dimm_mem_type:Unbuffered-DDR3
/sys/devices/system/edac/mc/mc0/rank3/dimm_label:mc#0csrow#1channel#1
/sys/devices/system/edac/mc/mc0/rank3/dimm_edac_mode:SECDED
/sys/devices/system/edac/mc/mc0/rank4/size:2048
/sys/devices/system/edac/mc/mc0/rank4/power/async:disabled
/sys/devices/system/edac/mc/mc0/rank4/dimm_location:csrow 2 channel 0 
/sys/devices/system/edac/mc/mc0/rank4/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank4/dimm_mem_type:Unbuffered-DDR3
/sys/devices/system/edac/mc/mc0/rank4/dimm_label:mc#0csrow#2channel#0
/sys/devices/system/edac/mc/mc0/rank4/dimm_edac_mode:SECDED
/sys/devices/system/edac/mc/mc0/rank5/size:2048
/sys/devices/system/edac/mc/mc0/rank5/power/async:disabled
/sys/devices/system/edac/mc/mc0/rank5/dimm_location:csrow 2 channel 1 
/sys/devices/system/edac/mc/mc0/rank5/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank5/dimm_mem_type:Unbuffered-DDR3
/sys/devices/system/edac/mc/mc0/rank5/dimm_label:mc#0csrow#2channel#1
/sys/devices/system/edac/mc/mc0/rank5/dimm_edac_mode:SECDED
/sys/devices/system/edac/mc/mc0/rank6/size:2048
/sys/devices/system/edac/mc/mc0/rank6/power/async:disabled
/sys/devices/system/edac/mc/mc0/rank6/dimm_location:csrow 3 channel 0 
/sys/devices/system/edac/mc/mc0/rank6/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank6/dimm_mem_type:Unbuffered-DDR3
/sys/devices/system/edac/mc/mc0/rank6/dimm_label:mc#0csrow#3channel#0
/sys/devices/system/edac/mc/mc0/rank6/dimm_edac_mode:SECDED
/sys/devices/system/edac/mc/mc0/rank7/size:2048
/sys/devices/system/edac/mc/mc0/rank7/power/async:disabled
/sys/devices/system/edac/mc/mc0/rank7/dimm_location:csrow 3 channel 1 
/sys/devices/system/edac/mc/mc0/rank7/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank7/dimm_mem_type:Unbuffered-DDR3
/sys/devices/system/edac/mc/mc0/rank7/dimm_label:mc#0csrow#3channel#1
/sys/devices/system/edac/mc/mc0/rank7/dimm_edac_mode:SECDED
/sys/devices/system/edac/mc/mc0/sdram_scrub_rate:195300
/sys/devices/system/edac/mc/mc0/inject_word:0x0
/sys/devices/system/edac/mc/mc0/size_mb:16384
/sys/devices/system/edac/mc/mc0/max_location:csrow 7 channel 1 
/sys/devices/system/edac/mc/mc0/mc_name:F15h
/sys/devices/system/edac/mc/mc0/csrow0/power/async:disabled
/sys/devices/system/edac/mc/mc0/csrow0/ch0_dimm_label:mc#0csrow#0channel#0
/sys/devices/system/edac/mc/mc0/csrow0/ch0_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow0/ch1_dimm_label:mc#0csrow#0channel#1
/sys/devices/system/edac/mc/mc0/csrow0/size_mb:4096
/sys/devices/system/edac/mc/mc0/csrow0/ch1_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow0/ue_count:0
/sys/devices/system/edac/mc/mc0/csrow0/dev_type:Unknown
/sys/devices/system/edac/mc/mc0/csrow0/ce_count:0
/sys/devices/system/edac/mc/mc0/csrow0/edac_mode:SECDED
/sys/devices/system/edac/mc/mc0/csrow0/mem_type:Unbuffered-DDR3
/sys/devices/system/edac/mc/mc0/csrow1/power/async:disabled
/sys/devices/system/edac/mc/mc0/csrow1/ch0_dimm_label:mc#0csrow#1channel#0
/sys/devices/system/edac/mc/mc0/csrow1/ch0_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow1/ch1_dimm_label:mc#0csrow#1channel#1
/sys/devices/system/edac/mc/mc0/csrow1/size_mb:4096
/sys/devices/system/edac/mc/mc0/csrow1/ch1_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow1/ue_count:0
/sys/devices/system/edac/mc/mc0/csrow1/dev_type:Unknown
/sys/devices/system/edac/mc/mc0/csrow1/ce_count:0
/sys/devices/system/edac/mc/mc0/csrow1/edac_mode:SECDED
/sys/devices/system/edac/mc/mc0/csrow1/mem_type:Unbuffered-DDR3
/sys/devices/system/edac/mc/mc0/csrow2/power/async:disabled
/sys/devices/system/edac/mc/mc0/csrow2/ch0_dimm_label:mc#0csrow#2channel#0
/sys/devices/system/edac/mc/mc0/csrow2/ch0_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow2/ch1_dimm_label:mc#0csrow#2channel#1
/sys/devices/system/edac/mc/mc0/csrow2/size_mb:4096
/sys/devices/system/edac/mc/mc0/csrow2/ch1_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow2/ue_count:0
/sys/devices/system/edac/mc/mc0/csrow2/dev_type:Unknown
/sys/devices/system/edac/mc/mc0/csrow2/ce_count:0
/sys/devices/system/edac/mc/mc0/csrow2/edac_mode:SECDED
/sys/devices/system/edac/mc/mc0/csrow2/mem_type:Unbuffered-DDR3
/sys/devices/system/edac/mc/mc0/csrow3/power/async:disabled
/sys/devices/system/edac/mc/mc0/csrow3/ch0_dimm_label:mc#0csrow#3channel#0
/sys/devices/system/edac/mc/mc0/csrow3/ch0_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow3/ch1_dimm_label:mc#0csrow#3channel#1
/sys/devices/system/edac/mc/mc0/csrow3/size_mb:4096
/sys/devices/system/edac/mc/mc0/csrow3/ch1_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow3/ue_count:0
/sys/devices/system/edac/mc/mc0/csrow3/dev_type:Unknown
/sys/devices/system/edac/mc/mc0/csrow3/ce_count:0
/sys/devices/system/edac/mc/mc0/csrow3/edac_mode:SECDED
/sys/devices/system/edac/mc/mc0/csrow3/mem_type:Unbuffered-DDR3
/sys/devices/system/edac/mc/mc0/topmem2:0x000000043f000000
/sys/devices/system/edac/mc/mc0/ue_count:0
/sys/devices/system/edac/mc/mc0/topmem:0x00000000c0000000
/sys/devices/system/edac/mc/mc0/ue_noinfo_count:0
/sys/devices/system/edac/mc/mc0/ce_count:0
/sys/devices/system/edac/mc/mc0/dram_hole:c0000000 40000000 40000000
/sys/devices/system/edac/mc/mc0/inject_section:0x0
/sys/devices/system/edac/mc/power/async:disabled
/sys/devices/system/edac/pci/pci0/pe_count:0
/sys/devices/system/edac/pci/pci0/npe_count:0
/sys/devices/system/edac/pci/edac_pci_log_npe:1
/sys/devices/system/edac/pci/edac_pci_panic_on_pe:0
/sys/devices/system/edac/pci/edac_pci_log_pe:1
/sys/devices/system/edac/pci/pci_nonparity_count:0
/sys/devices/system/edac/pci/check_pci_errors:0
/sys/devices/system/edac/pci/pci_parity_count:0
/sys/devices/system/edac/power/async:disabled

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
