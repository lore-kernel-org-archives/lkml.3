Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbaD1VOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:14:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:28891 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbaD1VOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:14:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,946,1389772800"; 
   d="scan'208";a="502515210"
Message-ID: <535EC4A7.5070001@intel.com>
Date: Mon, 28 Apr 2014 23:14:15 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 28 (drivers/pnp/quirks.c)
References: <20140428165724.6361cf10ebd3067b7f998c0f@canb.auug.org.au> <535E93C1.90908@infradead.org> <20140428211141.GA24070@google.com>
In-Reply-To: <20140428211141.GA24070@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/2014 11:11 PM, Bjorn Helgaas wrote:
> On Mon, Apr 28, 2014 at 10:45:37AM -0700, Randy Dunlap wrote:
>> On 04/27/14 23:57, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> This tree still fails (more than usual) the powerpc allyesconfig build.
>>>
>>> Changes since 20140424:
>>>
>> on i386:
>>
>>    CC      drivers/pnp/quirks.o
>> drivers/pnp/quirks.c: In function 'quirk_intel_mch':
>> drivers/pnp/quirks.c:393:2: error: implicit declaration of function 'pcibios_bus_to_resource' [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>> make[3]: *** [drivers/pnp/quirks.o] Error 1
> Thanks Randy.  This is a config that doesn't define CONFIG_PCI.  Rafael,
> here's an incremental fix, or the full updated patch is below.
>

Well, that went to Linus already, so a fix on top of 3.15-rc3 is needed.

> diff -u b/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
> --- b/drivers/pnp/quirks.c
> +++ b/drivers/pnp/quirks.c
> @@ -335,7 +335,7 @@
>   }
>   #endif
>   
> -#ifdef CONFIG_X86
> +#if defined(CONFIG_X86) && defined(CONFIG_PCI)

Do we need both or would CONFIG_PCI be sufficient?

>   /* Device IDs of parts that have 32KB MCH space */
>   static const unsigned int mch_quirk_devices[] = {
>   	0x0154,	/* Ivy Bridge */
> @@ -440,7 +440,7 @@
>   #ifdef CONFIG_AMD_NB
>   	{"PNP0c01", quirk_amd_mmconfig_area},
>   #endif
> -#ifdef CONFIG_X86
> +#if defined(CONFIG_X86) && defined(CONFIG_PCI)
>   	{"PNP0c02", quirk_intel_mch},
>   #endif
>   	{""}
>

Thanks,
Rafael

