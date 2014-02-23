Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaBWFSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 00:18:37 -0500
Received: from mail.wdtv.com ([66.118.69.84]:41519 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaBWFSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 00:18:35 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: It BOOTS! 3.13.5 that is.
Date: Sun, 23 Feb 2014 00:18:33 -0500
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201402222022.20370.gheskett@wdtv.com> <201402222300.35472.gheskett@wdtv.com> <CAKb7Uvj1mKeS=gR6xBQnz4J1Ft3kKSftrdCRF7md+CabGy--4g@mail.gmail.com>
In-Reply-To: <CAKb7Uvj1mKeS=gR6xBQnz4J1Ft3kKSftrdCRF7md+CabGy--4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201402230018.34029.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 February 2014, Ilia Mirkin wrote:
>On Sat, Feb 22, 2014 at 11:00 PM, Gene Heskett <gheskett@wdtv.com> wrote:
>> On Saturday 22 February 2014, Ilia Mirkin wrote:
>>>On Sat, Feb 22, 2014 at 10:42 PM, Gene Heskett <gheskett@wdtv.com> 
wrote:
>>>> On Saturday 22 February 2014, Ilia Mirkin wrote:
>>>>>On Sat, Feb 22, 2014 at 8:22 PM, Gene Heskett <gheskett@wdtv.com> 
wrote:
>>>>>> But my tv card isn't being found by kaffeine.  It is this card:
>>>>>> 
>>>>>> 01:08.0 Multimedia video controller: Conexant Systems, Inc.
>>>>>> CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
>>>>>> 
>>>>>>         Subsystem: pcHDTV Device 3000
>>>>>>         Flags: bus master, medium devsel, latency 32, IRQ 10
>>>>>>         Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
>>>>>>         Capabilities: [44] Vital Product Data <?>
>>>>>>         Capabilities: [4c] Power Management version 2
>>>>>> 
>>>>>> 01:08.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3
>>>>>> PCI Video and Audio Decoder [MPEG Port] (rev 05)
>>>>>> 
>>>>>>         Subsystem: pcHDTV Device 3000
>>>>>>         Flags: bus master, medium devsel, latency 32, IRQ 10
>>>>>>         Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
>>>>>>         Capabilities: [4c] Power Management version 2
>>>>>> 
>>>>>> From an lspci
>>>>>> 
>>>>>> In a make xconfig, I cannot find this specific card in the list of
>>>>>> DVB front ends.  What modules do I need to make sure are being
>>>>>> built?
>>>>>
>>>>>You're looking for VIDEO_CX88 ("Conexant 2388x (bt878 successor)
>>>>>support") and its various sub-options (esp CX88_DVB). iirc the
>>>>>pchdtv3000 had a OR51132 tuner, but right now the config is set to
>>>>>auto-select a whole bunch of tuners if you have
>>>>>MEDIA_SUBDRV_AUTOSELECT turned on. Otherwise make sure to select that
>>>>>tuner device. (Hm, I appear to have both OR51132 and CX22702 enabled,
>>>>>and I have that same card.)
>>>>>
>>>>>  -ilia
>>>> 
>>>> or51132 rings a bell and is enabled, CX22702 is not.  And I don't
>>>> seem to be able to find the CX88** at all.  I'll give the CX22702 a
>>>> shot, thanks a bunch ilia.
>>>
>>>grep CX88 .config
>>>
>> That returns a linefeed only.  And I have done some dozen or so make
>> oldconfigs.
>> 
>>>If it says "not set" for things like CONFIG_VIDEO_CX88_DVB, you won't
>>>get anything to work.
>>>
>>>  -ilia
>> 
>> If this fails, I'll see if I can plug that in with an editor, but the
>> last time I tried that, the friggin make did an automatic oldconfig
>> and stripped it.  Its enough to make one want to reduce the
>> neighborhood cat population.
>
>Adding random stuff to .config won't work, as you noticed.
>
>>From menuconfig search results for CX88 (ugh, sorry about the x's, but
>I'm too lazy to edit them out)
>
>  x Symbol: VIDEO_CX88 [=m]                                              
>  x x Type  : tristate                                                  
>     x x Prompt: Conexant 2388x (bt878 successor) support               
>        x x   Location:                                                 
>           x x     -> Device Drivers                                    
>              x x       -> Multimedia support (MEDIA_SUPPORT [=m])      
>                 x x (1)     -> Media PCI Adapters (MEDIA_PCI_SUPPORT
>[=y])                  x x   Defined at drivers/media/pci/cx88/Kconfig:1
>                          x x   Depends on: MEDIA_SUPPORT [=m] &&
>MEDIA_PCI_SUPPORT [=y] && (MEDIA_AN x x   Selects: I2C_ALGOBIT [=m] &&
>VIDEO_BTCX [=m] && VIDEOBUF_DMA_SG [=m]  x
>
>HTH,
>
>  -ilia

Sorry, no such beast As VIDEO_CX88.

Now that tells me something in the VIDEO dept isn't set, but what?

Thanks Ilia.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

