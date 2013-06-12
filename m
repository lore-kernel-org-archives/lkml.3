Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3FLOec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:34:32 -0400
Received: from bosmailout20.eigbox.net ([66.96.189.20]:35529 "EHLO
	bosmailout20.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab3FLOea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:34:30 -0400
X-Greylist: delayed 2483 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jun 2013 10:34:30 EDT
X-Authority-Analysis: v=2.0 cv=dt1Z+ic4 c=1 sm=1
 a=ABCSjpCQT5ywf69d+S7t6w==:17 a=bc2JKO6qiGsA:10 a=FB6NmUnAAagA:10
 a=gi2lbADIU9YA:10 a=hqD55VkP2l0A:10 a=IkcTkHD0fZMA:10 a=jYxPdhFhAAAA:8
 a=bw0tOsC81AkA:10 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=QyXUC8HyAAAA:8
 a=98j6GjRfuKdj89mTrOsA:9 a=QEXdDO2ut3YA:10 a=dGJ0OcVc7YAA:10
 a=UH8/iCWBfdUmbm4Ft4Vi3Q==:117
X-EN-OrigOutIP: 10.20.18.13
X-EN-IMPSID: nRt41l0060GvDVm01Rt4N1
Message-ID: <51B87D07.6050701@htibosch.net>
Date: Wed, 12 Jun 2013 21:52:07 +0800
From: Hein Tibosch <hein@htibosch.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v2 2/4] dma: move dw_dmac driver to an own directory
References: <1370435206-13474-1-git-send-email-andriy.shevchenko@linux.intel.com>  <1370435206-13474-3-git-send-email-andriy.shevchenko@linux.intel.com>  <20130612050829.GB4107@intel.com>  <CAHp75Ver2xo2f9crQZkAmJcTF=5cZZa3NgvufPqQW3+uTXffJA@mail.gmail.com>  <20130612073806.GG4107@intel.com>  <CAHp75VfsSDdLa_uPULbhVGproxnD5mofYm62O75y4xRbPBJ7pQ@mail.gmail.com>  <20130612075225.GI4107@intel.com>  <CAHp75Vc=hO_FF0WMvhPm6MMRuCb+=MhOEOCSYb_TaCRf-xQ=sg@mail.gmail.com>  <20130612081202.GK4107@intel.com> <1371027632.29283.332.camel@smile>
In-Reply-To: <1371027632.29283.332.camel@smile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.56.93
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/2013 5:00 PM, Andy Shevchenko wrote:
> [+ Hein]
>
> On Wed, 2013-06-12 at 13:42 +0530, Vinod Koul wrote: 
>> On Wed, Jun 12, 2013 at 11:38:37AM +0300, Andy Shevchenko wrote:
>>> On Wed, Jun 12, 2013 at 10:52 AM, Vinod Koul <vinod.koul@intel.com> wrote:
>>>> On Wed, Jun 12, 2013 at 11:27:51AM +0300, Andy Shevchenko wrote:
>>>>> On Wed, Jun 12, 2013 at 10:39 AM, Vinod Koul <vinod.koul@intel.com> wrote:
>>>>>
>>>>> []
>>>>>
>>>>>> Something like
>>>>>> config DW_DMAC_BIG_ENDIAN_IO
>>>>>>         tristate
>>>>>>
>>>>>> config DW_DMAC
>>>>>>         select DW_DMAC_BIG_ENDIAN_IO
>>>>>>
>>>>>> I belive DW_DMAC is for AVR support and the PCI ones is different right.
>>>>>> The point is that these things should be selected by the required symbols based
>>>>>> on what ARCH we are on and not be prompted for user to configure via menuconfig
>>>>> DW_DMAC is a generic platform driver which supports AVR32, ARM and
>>>>> Intel (ACPI case) platforms.
>>>>>
>>>>> We may do that option invisible to user
>>>> Yup
>>>>> and then use
>>>>>
>>>>> config DW_DMAC
>>>>>          select DW_DMAC_BIG_ENDIAN_IO if ARCH=AVR32
>>>> Thats would be the right way
>>> Do you prefer to have this as separate patch or integrated in the split?
>>> In my humble opinion I better to do separate patch.
>> Never mind, am applying your patches and below fix, let me if you guys are okay
>
> As far as I know we have at least one developer (Hein Tibosch) with such
> board. Let him share his opinion.
>
>> diff --git a/drivers/dma/dw/Kconfig b/drivers/dma/dw/Kconfig
>> index db2b41f..7be1cf8 100644
>> --- a/drivers/dma/dw/Kconfig
>> +++ b/drivers/dma/dw/Kconfig
>> @@ -10,6 +10,7 @@ config DW_DMAC_CORE
>>  config DW_DMAC
>>  	tristate "Synopsys DesignWare AHB DMA platform driver"
>>  	select DW_DMAC_CORE
>> +	select DW_DMAC_BIG_ENDIAN_IO if ARCH=AVR32
Yes sure! Avr32 users won't have any other choice as to select this option.

Hein

>>  	default y if CPU_AT32AP7000
>>  	help
>>  	  Support the Synopsys DesignWare AHB DMA controller. This
>> @@ -25,12 +26,4 @@ config DW_DMAC_PCI
>>  	  Intel Medfield has integrated this GPDMA controller.
>>  
>>  config DW_DMAC_BIG_ENDIAN_IO
>> -	bool "Use big endian I/O register access"
>> -	default y if AVR32
>> -	depends on DW_DMAC_CORE
>> -	help
>> -	  Say yes here to use big endian I/O access when reading and writing
>> -	  to the DMA controller registers. This is needed on some platforms,
>> -	  like the Atmel AVR32 architecture.
>> -
>> -	  If unsure, use the default setting.
>> +	bool
>> -
>>
>> --
>> ~Vinod

