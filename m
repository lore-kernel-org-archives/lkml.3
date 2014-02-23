Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158AbaBWMSd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 07:18:33 -0500
Received: from mail.wdtv.com ([66.118.69.84]:36639 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbaBWMSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 07:18:31 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: It BOOTS! 3.13.5 that is.
Date: Sun, 23 Feb 2014 07:18:20 -0500
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201402222022.20370.gheskett@wdtv.com> <201402230018.34029.gheskett@wdtv.com> <CAKb7UvgA8o7TLC+bR+hFoZLSUQaoSebgV=X2-u6M-kPVy+Vccw@mail.gmail.com>
In-Reply-To: <CAKb7UvgA8o7TLC+bR+hFoZLSUQaoSebgV=X2-u6M-kPVy+Vccw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201402230718.20113.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 February 2014, Ilia Mirkin wrote:
>On Sun, Feb 23, 2014 at 12:18 AM, Gene Heskett <gheskett@wdtv.com> wrote:
>> On Saturday 22 February 2014, Ilia Mirkin wrote:
>>>On Sat, Feb 22, 2014 at 11:00 PM, Gene Heskett <gheskett@wdtv.com> 
wrote:
>>>> On Saturday 22 February 2014, Ilia Mirkin wrote:
>>>>>On Sat, Feb 22, 2014 at 10:42 PM, Gene Heskett <gheskett@wdtv.com>
>> 
>> wrote:
>>>>>> On Saturday 22 February 2014, Ilia Mirkin wrote:
>>>>>>>On Sat, Feb 22, 2014 at 8:22 PM, Gene Heskett <gheskett@wdtv.com>
>> 
>> wrote:
>>>>>>>> But my tv card isn't being found by kaffeine.  It is this card:
>>>>>>>> 
>>>>>>>> 01:08.0 Multimedia video controller: Conexant Systems, Inc.
>>>>>>>> CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
>>>>>>>> 
>>>>>>>>         Subsystem: pcHDTV Device 3000
>>>>>>>>         Flags: bus master, medium devsel, latency 32, IRQ 10
>>>>>>>>         Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
>>>>>>>>         Capabilities: [44] Vital Product Data <?>
>>>>>>>>         Capabilities: [4c] Power Management version 2
>>>>>>>> 
>>>>>>>> 01:08.2 Multimedia controller: Conexant Systems, Inc.
>>>>>>>> CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)
>>>>>>>> 
>>>>>>>>         Subsystem: pcHDTV Device 3000
>>>>>>>>         Flags: bus master, medium devsel, latency 32, IRQ 10
>>>>>>>>         Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
>>>>>>>>         Capabilities: [4c] Power Management version 2
>>>>>>>> 
>>>>>>>> From an lspci
>>>>>>>> 
>>>>>>>> In a make xconfig, I cannot find this specific card in the list
>>>>>>>> of DVB front ends.  What modules do I need to make sure are
>>>>>>>> being built?
>>>>>>>
>>>>>>>You're looking for VIDEO_CX88 ("Conexant 2388x (bt878 successor)
>>>>>>>support") and its various sub-options (esp CX88_DVB). iirc the
>>>>>>>pchdtv3000 had a OR51132 tuner, but right now the config is set to
>>>>>>>auto-select a whole bunch of tuners if you have
>>>>>>>MEDIA_SUBDRV_AUTOSELECT turned on. Otherwise make sure to select
>>>>>>>that tuner device. (Hm, I appear to have both OR51132 and CX22702
>>>>>>>enabled, and I have that same card.)
>>>>>>>
>>>>>>>  -ilia
>>>>>> 
>>>>>> or51132 rings a bell and is enabled, CX22702 is not.  And I don't
>>>>>> seem to be able to find the CX88** at all.  I'll give the CX22702 a
>>>>>> shot, thanks a bunch ilia.
>>>>>
>>>>>grep CX88 .config
>>>>>
>>>> That returns a linefeed only.  And I have done some dozen or so make
>>>> oldconfigs.
>>>> 
>>>>>If it says "not set" for things like CONFIG_VIDEO_CX88_DVB, you won't
>>>>>get anything to work.
>>>>>
>>>>>  -ilia
>>>> 
>>>> If this fails, I'll see if I can plug that in with an editor, but the
>>>> last time I tried that, the friggin make did an automatic oldconfig
>>>> and stripped it.  Its enough to make one want to reduce the
>>>> neighborhood cat population.
>>>
>>>Adding random stuff to .config won't work, as you noticed.
>>>
>>>>>>From menuconfig search results for CX88 (ugh, sorry about the x's, but
>>>
>>>I'm too lazy to edit them out)
>>>
>>>  x Symbol: VIDEO_CX88 [=m]
>>>  x x Type  : tristate
>>>  
>>>     x x Prompt: Conexant 2388x (bt878 successor) support
>>>     
>>>        x x   Location:
>>>           x x     -> Device Drivers
>>>           
>>>              x x       -> Multimedia support (MEDIA_SUPPORT [=m])
>>>              
>>>                 x x (1)     -> Media PCI Adapters (MEDIA_PCI_SUPPORT
>>>
>>>[=y])                  x x   Defined at
>>>drivers/media/pci/cx88/Kconfig:1
>>>
>>>                          x x   Depends on: MEDIA_SUPPORT [=m] &&
>>>
>>>MEDIA_PCI_SUPPORT [=y] && (MEDIA_AN x x   Selects: I2C_ALGOBIT [=m] &&
>>>VIDEO_BTCX [=m] && VIDEOBUF_DMA_SG [=m]  x
>>>
>>>HTH,
>>>
>>>  -ilia
>> 
>> Sorry, no such beast As VIDEO_CX88.
>> 
>> Now that tells me something in the VIDEO dept isn't set, but what?
>
>Look at the e-mail I sent. It includes the full path to enabling the
>right things. First select "Device Drivers", then enable "Multimedia
>support", then enable "Media PCI Adapters". You should see "Conexant
>2388x" in there.
>
>  -ilia

Nope, but I found it just before I went to bed.  Reading through the 
various Kconfig files, it turned out that there are 2 more requisits to 
even being able to see it, its also dependent on RC_CORE which was not 
enabled.  So I fired off a build and went to bed knowing it would take 
an hour as amanda was also running.  Now I am about to reboot to test.

After the reboot, an lsmod shows the correct (I think, crosscheck this 
list please) modules loaded:
gene@coyote:~/src/linux-3.13.5/drivers/media/rc$ lsmod |grep cx
cx8802                 11232  0 
cx8800                 23126  0 
cx88xx                 69224  2 cx8802,cx8800
v4l2_common             3438  3 tuner,cx8800,cx88xx
videodev               88190  4 tuner,cx8800,cx88xx,v4l2_common
tveeprom               11057  1 cx88xx
btcx_risc               2799  3 cx8802,cx8800,cx88xx
videobuf_dma_sg         7044  3 cx8802,cx8800,cx88xx
videobuf_core          13768  5 videobuf_dvb,cx8802,cx8800,cx88xx,videobuf_dma_sg
i2c_algo_bit            4647  2 cx88xx,nouveau
i2c_core               17109  12 or51132,tuner,cx8800,cx88xx,v4l2_common,videodev,tveeprom,i2c_nforce2,nouveau,drm_kms_helper,drm,i2c_algo_bit

But kaffeine can't find it. The tv configure pulldown did show it, ghosted
like something else has a lock on it, so I removed it thinking it might
rescan and find it, but no such luck.  And the kde manual for kaffeine
seems to be on the missing list.

There is evidence in the dmesg that too many tuners are enabled, and no
evidence of the /lib/firmware/dvb-fe-or51132-vsb.fw being applied. It
has been powered down several times, and it needs that firmware
reloaded each time, and I've forgot how to do that.

I know it worked but poorly with kernel 2.6.32-132-RTAI, so thats the 
next step, reboot to that to dbl-check.

Thanks Ilia.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

