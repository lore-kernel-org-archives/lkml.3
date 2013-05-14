Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab3ENTyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 15:54:35 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:44522 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3ENTye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 15:54:34 -0400
MIME-Version: 1.0
In-Reply-To: <s5hr4haw190.wl%tiwai@suse.de>
References: <CALxABCbP9hkNQ=xTEUMWb+6UhmVs2N-5kauYJe7d=j1z_RL+LA@mail.gmail.com>
 <s5h8v3irjeb.wl%tiwai@suse.de> <s5hy5biq3kr.wl%tiwai@suse.de>
 <CALxABCbyALmAKwCC6wNOgQWs8jD2X72aH8_++OW6R7m7C3vgfw@mail.gmail.com> <s5hr4haw190.wl%tiwai@suse.de>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Tue, 14 May 2013 21:54:13 +0200
Message-ID: <CALxABCYQW_qxOu1WLiwJm6BOHPi_zgfYWKOAk9Y+hj+g1VLATg@mail.gmail.com>
Subject: Re: regression: from 3.8 to 3.9: headphones output no sound on Intel
 HDA, codec VIA VT1802
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 7:59 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> > Also, what happens if you apply the patch below?
>> > -       spec->set_widgets_power_state =  set_widgets_power_state_vt2002P;
>> > +       //spec->set_widgets_power_state =  set_widgets_power_state_vt2002P;
>>
>> This helps as well. Yay!
>> Thanks :) Whatever the outcome, I have them back more or less (more,
>> for me) properly.
>
> OK, then we know the place to fix now.
> Try the patch below instead.  Does it fix the problem as well?

Sadly, no. Now there is no headphone output at all. Not even to the
alternate PCM.

>> Probably unrelated, but I better mention it anyway: the "Auto-Mute Mode"
>> works strangely, it never mutes anything but headphones. It might work
>> as designed, but it is useless in this case: one still has to mute the
>> speaker manually when plugging headphones (or do something with input
>> events, which I failed to get to work).
>
> Does the problem still happen with the patch?
>

Well... Kind of no. As I said, there is no headphone output, BUT the laptop
built-in speakers ARE muted when the headphones plugged in.

>> And "Independent HP" has absolutely no effect, which is probably as it
>> should be on this laptop.
>
> With the independent HP turned on, there should be no output to the
> headphone through the normal PCM.  There is a secondary PCM device,
> and this is routed to the headphone when the independent HP is on.

Ah. I misunderstood (miscounted?) the playback PCMs: this card has three
(VT1802 Analog, VT1802 Alt Analog and ID 2806 Digital), the last one being
HDMI (just deconfigured, while I was trying to figure the headphones out).
The first two named appropriately (if one looks at them), and when tried
(hw:0,2. Strangely, there is no hw:0,1) it indeed works (with the revised
patch. Not with this one).

Regards,
Alex
