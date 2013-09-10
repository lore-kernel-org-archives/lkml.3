Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab3IJPuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:50:00 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:57899 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab3IJPt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:49:59 -0400
MIME-Version: 1.0
In-Reply-To: <CA+qSnqh1X6_xHD4GX1P=acEUg9+0=3dVSZHm-NYXvCvupFB8_g@mail.gmail.com>
References: <alpine.DEB.2.00.1309051139240.25450@skynet.skynet.ie>
	<CA+55aFwyKmVWkrV3=XiuruZzeTicpfW-JrwjWzpq9eP2yGPeJA@mail.gmail.com>
	<CA+qSnqh1X6_xHD4GX1P=acEUg9+0=3dVSZHm-NYXvCvupFB8_g@mail.gmail.com>
Date: Tue, 10 Sep 2013 08:49:58 -0700
X-Google-Sender-Auth: Z7oCce19BND_lEllAg-vsE0WjWU
Message-ID: <CA+55aFzRCNteHoSBRL9cVAHtZwA419G+fPBAaofYextsHpDLYw@mail.gmail.com>
Subject: Re: [git pull] drm tree for 3.12-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sean V Kelley <sean.v.kelley@intel.com>, Dave Airlie <airlied@redhat.com>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Dave - your linux.ie email generates bounces for me, trying redhat instead ]

On Mon, Sep 9, 2013 at 11:25 PM, Sean V Kelley <sean.v.kelley@intel.com> wrote:
>>
>> I'm also a bit bummed that hw acceleration of video doesn't seem to
>> work on Haswell, meaning that full-screen is now a jerky mess. I fear
>> that that is user-space libraries/X.org, but I thought I'd mention it
>> in the hope of getting a "oh, it's working for us, you'll get a fix
>> for it soon".
>
> Can you give a little more detail about video not working?  Video
> accel should work fine with the current versions of libva/intel-driver
> available in Fedora 19 - assuming that's what you're using.

It is indeed F19.

Easy test: go to youtube, and watch things that are in 1080p HD. They
play fine in a window (using about 70% CPU), but full-screened to
2560x1440 they play at about one or two frames per second.

Non-HD content seems to be fine even full-screen. Either just because
it's so much easier to do, or because some level of scaling is
hw-accelerated.

It may well be that I'm using chrome (and chrome seems to tend to use
its own library versions), and firefox indeed seems to be a bit
better. But by "a bit better" I mean closer to full frame rate in
full-screen, but lots of tearing - and it was stil using 70% CPU when
displaying in a window. So I think firefox is also still doing
everything in software but may be better about using threads for it.

My previous i5-670 which was inferior in almost every other way didn't
have these problems.. It had the same 2560x1440 display.

              Linus
