Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaELLZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 07:25:27 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:51933 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaELLZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 07:25:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAKMK7uHLSfW0wN-uXMejOcnvaYpZfVSfSh7+NpqAUBCOvbK2eg@mail.gmail.com>
References: <CADDKRnCwxmJ8RonvZaizTT9R1jPU++tPPSQAH5OKD5=h9bQhMA@mail.gmail.com>
	<CAKMK7uG20sF403PJcmWTD=kPF9seV4sXZpp9_hEq3LvV3kK5Hg@mail.gmail.com>
	<CADDKRnB1DCzgjX-q-cgFFW48uT5r5MUcuc5D6chekEET5dFxxA@mail.gmail.com>
	<20140509161438.GH31479@strange.amr.corp.intel.com>
	<20140509170335.GZ18465@intel.com>
	<CADDKRnAiQawK6vi0XO2FDdfGDbcwWQzdeu-rfEU8viJzARO+yQ@mail.gmail.com>
	<CAKMK7uHLSfW0wN-uXMejOcnvaYpZfVSfSh7+NpqAUBCOvbK2eg@mail.gmail.com>
Date: Mon, 12 May 2014 13:25:24 +0200
Message-ID: <CADDKRnCzHQw7_Cr2jpZ7qC50hrdmr0XRaYyMxaOSaqihNGccDA@mail.gmail.com>
Subject: Re: [Intel-gfx] [3.14.0-rc4] regression: drm FIFO underruns
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Damien Lespiau <damien.lespiau@intel.com>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-11 18:49 GMT+02:00 Daniel Vetter <daniel.vetter@ffwll.ch>:
> On Sat, May 10, 2014 at 10:52 AM, Jörg Otte <jrg.otte@gmail.com> wrote:
>>> On Fri, May 09, 2014 at 05:14:38PM +0100, Damien Lespiau wrote:
>>>> On Fri, May 09, 2014 at 06:11:37PM +0200, Jörg Otte wrote:
>>>> > > Jörg, can you please boot with drm.debug=0xe, reproduce the issue and
>>>> > > then attach the complete dmesg? Please make sure that the dmesg
>>>> > > contains the boot-up stuff too.
>>>> > >
>>>> > > Thanks, Daniel
>>>> > Here it is. I should mention it only happens at boot-up.
>>>>
>>>> [    0.374095] [drm] Wrong MCH_SSKPD value: 0x20100406
>>>> [    0.374096] [drm] This can cause pipe underruns and display issues.
>>>> [    0.374097] [drm] Please upgrade your BIOS to fix this.
>>>
>>> That can be a factor, but I think we may have some more general issue
>>> in the modeset sequence which causes these to get reported. I'm getting
>>> some on my machine as well where SSKPD looks more sane. Maybe we turn on
>>> the error reporting too early or something.
>>>
>>> But I'm not going to spend time worrying about these before my previous
>>> watermark stuff gets merged. Also the underrun reporting code itself
>>> would need some kind of rewrite to be really useful.
>>>
>>> If the display doesn't blank out during use everything is more or less
>>> fine and you can ignore these errors. It's quite likely that the
>>> errors were always present and you didn't know it. We just made them
>>> more prominent recently.
>>>
>>> --
>>> Ville Syrjälä
>>> Intel OTC
>>
>> It comes out on the boot-up screen which is normally clean. So it becomes
>> highly visible for anyone.
>
> To make sure that you're only seeing this at boot up and not elseplace
> please check that it doesn't show up when you do anything of the
> below:
> a) suspend/resume
> b) changing the output mode (e.g. with xrandr --mode)
> c) changing the output pipe (e.g. with xrandr --crtc)
> d) all of the above but with heavy system load, e.g. compile kernels
> with make -j <num-cores*2>
>
> Also please test the latest drm-intel-nightly branch from
> http://cgit.freedesktop.org/drm-intel to make sure we haven't yet
> fixed this in our -next branch.
>

Ok, that was a lot of homework ;)

I checked a,b,d):  All worked without FIFO underruns.

For c): I must admit I don't know what --crtc is good for and
the man page isn't very useful. I can't enter a meaningful command.

Branch drm-intel-nightly as of
ed60c27 drm-intel-nightly: 2014y-05m-09d-21h-51m-45s integration manifest
looks badly:
   - KDE splash screen on boot-up is not visible
   - x-windows don't have title and menu bars
   - KDE system menu is not visible
   - moving windows around destroys its content
apart from that: Via control key I can open a terminal and I checked
a,b), both worked without FIFO underruns.

Thanks, Jörg
