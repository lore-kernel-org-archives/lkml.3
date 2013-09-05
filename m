Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab3IEWvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:51:52 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:49906 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab3IEWvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:51:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130905153243.43d0346e@jbarnes-desktop>
References: <alpine.DEB.2.00.1309051139240.25450@skynet.skynet.ie>
	<CA+55aFwyKmVWkrV3=XiuruZzeTicpfW-JrwjWzpq9eP2yGPeJA@mail.gmail.com>
	<20130905153243.43d0346e@jbarnes-desktop>
Date: Thu, 5 Sep 2013 15:51:48 -0700
X-Google-Sender-Auth: 9ZpaBZbE-XFJ4UlV0jOI-AO1uck
Message-ID: <CA+55aFybVR6MqWpQfTu3jK8mgSg8Z53gz0Ah77ZK1+40Fx=FsQ@mail.gmail.com>
Subject: Re: [git pull] drm tree for 3.12-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Beauchesne, Gwenole" <gwenole.beauchesne@intel.com>,
        Sean V Kelley <sean.v.kelley@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 3:32 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Thu, 5 Sep 2013 12:18:32 -0700
>>
>> The first time I booted this, I just got a black screen on my Haswell
>> desktop when X11 started up.  I could ctrl-alt-BS and ctrl-alt-del to
>> reboot the machine, and neither the Xorg.0.log nor the dmesg contained
>> anything interesting.
>
> Did the console come back after ctl-alt-bs?  Or was it just a blind
> reboot?  Troubling that it doesn't happen again...

Blind reboot.

And Dave's theory that it is a "boot from old kernel to show the
problem in case it's some missing hw setup" is a good one, but doesn't
match my experience: I did boot the old kernel in between (to see what
went wrong), so both the working and nonworking setups were from
warm-booting from an old kernel..

I've booted a few times since (it's the merge window, so I boot fairly
frequently), and it hasn't happened again...

Looking more closely at the log-file, I notice that the

> AFAIK we have libva support out there for HSW.  The trick is getting
> your stack to actually use it.  Gwenole or Sean may be able to help.
>
>> Because my shiny new 65W haswell is really nice and does a "make
>> allmodconfig" in half the time of my old machine, but the GPU side has
>> been something of a step backwards...
>
> Well we definitely don't want that...

There's another thing I've noticed with Haswell - while putting the
screen to sleep works fine with DP, it comes back with odd corruption.
Pressing enter to get the actual password prompt correctly repaints
things, so it's not always noticeable - but using something else than
the enter key to wake things up seems to show it consistently (also
happens with "xset dpms force off", you don't have to wait for
locking)

Of course, this may be old user-land, again. It's current F19, the
intel module says "compiled for 1.14.2, module version = 2.21.12".

Maybe the problem I had with HDMI/DVI was just a different expression
of this same bug.

             Linus
