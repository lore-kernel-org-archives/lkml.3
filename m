Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbaEIVSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:18:12 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:53773 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558AbaEIVSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:18:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140509170335.GZ18465@intel.com>
References: <CADDKRnCwxmJ8RonvZaizTT9R1jPU++tPPSQAH5OKD5=h9bQhMA@mail.gmail.com>
	<CAKMK7uG20sF403PJcmWTD=kPF9seV4sXZpp9_hEq3LvV3kK5Hg@mail.gmail.com>
	<CADDKRnB1DCzgjX-q-cgFFW48uT5r5MUcuc5D6chekEET5dFxxA@mail.gmail.com>
	<20140509161438.GH31479@strange.amr.corp.intel.com>
	<20140509170335.GZ18465@intel.com>
Date: Sat, 10 May 2014 07:18:08 +1000
Message-ID: <CAPM=9txjONPn_p131Q1d=0D8Ma0K_6_DGF3ztDPG65wCXOfW0Q@mail.gmail.com>
Subject: Re: [Intel-gfx] [3.14.0-rc4] regression: drm FIFO underruns
From: Dave Airlie <airlied@gmail.com>
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: Damien Lespiau <damien.lespiau@intel.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 May 2014 03:03, Ville Syrjälä <ville.syrjala@linux.intel.com> wrote:
> On Fri, May 09, 2014 at 05:14:38PM +0100, Damien Lespiau wrote:
>> On Fri, May 09, 2014 at 06:11:37PM +0200, Jörg Otte wrote:
>> > > Jörg, can you please boot with drm.debug=0xe, reproduce the issue and
>> > > then attach the complete dmesg? Please make sure that the dmesg
>> > > contains the boot-up stuff too.
>> > >
>> > > Thanks, Daniel
>> > Here it is. I should mention it only happens at boot-up.
>>
>> [    0.374095] [drm] Wrong MCH_SSKPD value: 0x20100406
>> [    0.374096] [drm] This can cause pipe underruns and display issues.
>> [    0.374097] [drm] Please upgrade your BIOS to fix this.
>
> That can be a factor, but I think we may have some more general issue
> in the modeset sequence which causes these to get reported. I'm getting
> some on my machine as well where SSKPD looks more sane. Maybe we turn on
> the error reporting too early or something.
>
> But I'm not going to spend time worrying about these before my previous
> watermark stuff gets merged. Also the underrun reporting code itself
> would need some kind of rewrite to be really useful.
>
> If the display doesn't blank out during use everything is more or less
> fine and you can ignore these errors. It's quite likely that the
> errors were always present and you didn't know it. We just made them
> more prominent recently.

Please don't make things more prominent if the fixes can't be merged
without rewriting the world,

Distros have auto reporting tools for the major backtrace warnings,
and releasing kernels with unfixable ones in it make it hard to know
what is real and what isn't.

Dave.
