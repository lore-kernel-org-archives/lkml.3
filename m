Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164AbaJPFfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:35:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:20827 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbaJPFfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:35:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="401069213"
Message-ID: <543F590D.90905@linux.intel.com>
Date: Thu, 16 Oct 2014 13:35:09 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Felipe Balbi <balbi@ti.com>, x86@kernel.org
Subject: Re: [Patch v2] x86: Make Atom PMC driver configurable.
References: <20141015144603.GA19944@redhat.com> <20141015145245.GB11511@saruman> <20141015145924.GA21199@redhat.com> <20141015172030.6bb3c522@alan.etchedpixels.co.uk> <20141016021859.GA12042@redhat.com> <20141016052448.GB14796@gmail.com>
In-Reply-To: <20141016052448.GB14796@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/16 13:24, Ingo Molnar wrote:
> 
> * Dave Jones <davej@redhat.com> wrote:
> 
>> The Atom PMC driver is always built-in, regardless of whether
>> the kernel being built is going to be run on an Atom (or even Intel) CPU.
>>
>> Signed-off-by: Dave Jones <davej@redhat.com>
>> Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
>> Cc: aubrey.li@linux.intel.com
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index f2327e88e07c..b4dfd96aeea8 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -2485,7 +2485,8 @@ config X86_DMA_REMAP
>>  	depends on STA2X11
>>  
>>  config PMC_ATOM
>> -	def_bool y
>> +	tristate "Intel Atom SOC power management controller driver"
>> +	default y
>>          depends on PCI
>>  
> 
> So what I think should happen is to decouple of the 'must work' 
> features from the optional debug features in this 'driver': the 
> Atom SoC power-off quirk should be made unconditional, as long as 
> the .config is Atom-supported (CPU_SUP_INTEL I guess).
> 
> All the other bits, such as the debugfs interface, should be in a 
> separately and appropriately named config option, 
> CONFIG_X86_INTEL_ATOM_PMC_DEBUG=y or so, with 'default n'.
> 
> The file should probably be split up, the quirk moved into one of 
> the generic quirk files, while pmc_atom.c should have the debugfs 
> interface.
> 
> That way we don't break anyone and remove the unnecessary code as 
> well. It's also a nice clean up.

Thanks for the suggestion, I'll take a look if I can refine it after
I clean up my plate. Please expect a delay here.

-Aubrey

> 
> Thanks,
> 
> 	Ingo
> 
> 

