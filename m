Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab3EVVHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:07:19 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:45415 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab3EVVHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:07:13 -0400
MIME-Version: 1.0
In-Reply-To: <CALxABCZHwKPDKPsjWJmK=-QzcC3fs2bKqHU0SCUmdH7OqGDNdA@mail.gmail.com>
References: <CALxABCbP9hkNQ=xTEUMWb+6UhmVs2N-5kauYJe7d=j1z_RL+LA@mail.gmail.com>
 <s5h8v3irjeb.wl%tiwai@suse.de> <s5hy5biq3kr.wl%tiwai@suse.de>
 <CALxABCbyALmAKwCC6wNOgQWs8jD2X72aH8_++OW6R7m7C3vgfw@mail.gmail.com>
 <s5hr4haw190.wl%tiwai@suse.de> <s5hd2stq152.wl%tiwai@suse.de>
 <CALxABCaxJkG486g2reFDJD_nKzyaZkJnsRrwaLFNC9eFZBcXTg@mail.gmail.com>
 <s5ha9nwx1j3.wl%tiwai@suse.de> <CALxABCZMyqh5SSo=RpQCJNUR_p9yrG5x9DimFpzvgkCFLr4eug@mail.gmail.com>
 <s5h1u97jik9.wl%tiwai@suse.de> <CALxABCa27gVVJGWM-crvFOPmJXdZ0FEBc3=dPZ0pG+AhDB78cA@mail.gmail.com>
 <s5hk3myuoq6.wl%tiwai@suse.de> <CALxABCZHwKPDKPsjWJmK=-QzcC3fs2bKqHU0SCUmdH7OqGDNdA@mail.gmail.com>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Wed, 22 May 2013 23:06:53 +0200
Message-ID: <CALxABCaubJgHkr60r4M5igJtZhCOMhZbzCvGByb3gOg5spSFUQ@mail.gmail.com>
Subject: Re: regression: from 3.8 to 3.9: headphones output no sound on Intel
 HDA, codec VIA VT1802
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping? Can I do something for you?

Regards,
Alex

On Sat, May 18, 2013 at 10:29 PM, Alex Riesen <raa.lkml@gmail.com> wrote:
> Sorry for delayed replies. I have not much time for this lately.
>
> On Fri, May 17, 2013 at 8:04 AM, Takashi Iwai <tiwai@suse.de> wrote:
>>> Well... It seems that something went unnoticed. This command seems
>>> to be essential for this (and the revised) patch to get the headphone
>>> output at all:
>>>
>>>         hda-verb /dev/snd/hwC0D0 0x25 SET_PIN_WID 0xc0
>>
>> Do you mean that the headphone doesn't work without this even after
>> the patch?  It's weird that the alsa-info.sh output you attached below
>> already contains it, i.e. 0x25 showing 0xc0.
>
> Yes. It is after the latest patch.
>
>> Or, is the attached output the result after you ran hda-verb like the
>> above?
>
> Er, yes.
>
>>> It does. And there is no output from the speakers.
>>
>> Hmm.  I'm confused.  I thought you mentioned that the speaker is
>> unmuted?
>
> I think I am as confused as you, if not more. I redid the tests
> but recorded everything this time with script(1). It is without
> timing information (would be boring anyway, with me figuring
> the arguments), so just cat it. Just in case: it sets xterm title.
> The transcript is in headphone.gz.
>
>> - Use the patched kernel, play without headphone, confirm that the
>>   speaker works.  Get alsa-info.sh output at this point.
>
> That's 3.9.2-wo-headphone.alsa.gz
>
>> - Plug the headphone, play, and check whether the headphone works and
>>   the speaker is muted.
>>   Again, get alsa-info.sh output at this point, no matter whether the
>>   headphone works or not.
>
> That's 3.9.2-w-headphone.alsa.gz. Headphone not working, speakers
> correctly muted.
>
>> In anyway, if you make things working, please give exactly what you
>> did, and take again alsa-info.sh output, too.
>
> 3.9.2-w-headphone-working.alsa.gz. The working state is lost after
> unplugging and replugging the headphones. It is different to the
> case when the alternate channel is used (Independent HP): replugging
> does not break the output than.
>
> Sorry for confusion and thanks!
>
> Regards,
> Alex
