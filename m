Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbbAUEf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 23:35:29 -0500
Received: from leo.clearchain.com ([199.73.29.74]:55413 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbbAUEf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 23:35:27 -0500
Date: Wed, 21 Jan 2015 14:35:20 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Henrik Rydberg <rydberg@bitmath.org>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Update rydberg's addresses
Message-ID: <20150121043520.GB17900@jelly.redhat.com>
References: <1418979967-2134-1-git-send-email-rydberg@bitmath.org>
 <CAN+gG=Gmgk+wKSnHkSAERoWt+1PqAojNSZt6jo=qmzPOqJs+3Q@mail.gmail.com>
 <54BED60C.3030303@bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BED60C.3030303@bitmath.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (mail.clearchain.com [127.0.0.1]); Wed, 21 Jan 2015 15:05:26 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 11:26:20PM +0100, Henrik Rydberg wrote:
> Hi Benjamin,
> 
> > Henrik, I just used the get_maintainer to add you on CC to an input-mt
> > patch series, and it ended up using the @euromail.se instead of your
> > still valid one. I can resend to you the patch series if you want.
> 
> Thanks, that won't be necessary.
> 
> I looked through the the patchset, and it strikes me as mostly renames without
> deeper explanations, which all in all puts them in the not-needed category, I am
> afraid. An in-depth explanation could be added as a text block somewhere without
> touching the current code.

I disagree. Patches that improve readability of the code are rarely in the
not-needed category. Looking at Input: mt: document input_mt_set_matrix()
for example: without that comment I'd have no idea if what the function does
is correct or not because I'd have no idea what it's _supposed_ to do.
 
> The only patch that does something is the last one, and what it does could
> easily be performed in userland, by further processing of the contacts there. I
> therefore see no use for any of those patches in the kernel.
> 
> Is there a good reason for the first reaction to be to add special tweaks such
> as this one in the kernel, rather than in a dedicated userland input system? I
> am genuinely curious.

it wasn't the first reaction. it was the third, after we hacked up 
synaptics [1], then libinput [2], both rather unsatisfactory. Not sure what
chromeos does but they'll probably would need similar code. And any other
users of the evdev API of course.

Anyway, yes, you're right, it can be done in userland, depending on the
implementation of userland. Putting proper support for this in synaptics
would require a rather large rewrite of the touch handling for example [3]
So we need multiple different implementations. Of course, we could factor
this out into a library, at which point we have another API to track and
piece of code to maintain and slot in between the device node and the
consumer of the events. And effectively we'd have then written the same code
that's already in the kernel anyway (which we can't copy directly because
GPL vs MIT etc.).

The big ticket item though is that without this patch the message is: you
can't trust protocol B to actually track the touchpoints correctly. Which
goes against to what it's supposed to help with in the first place.
So now we need some userspace code to verify the kernel touchpoint tracking,
but since this only affects some devices you'd need some code to identify
devices that need to be double checked. The kernel has that info, we don't
have (all of) it in userspace. All of this effort to work around what the
kernel is supposed to do in the first place.

So yeah, I think there are plenty of good reasons for having this in the
kernel :)

Cheers,
   Peter

[1] http://lists.x.org/archives/xorg-devel/2014-September/043866.html
[2] http://lists.freedesktop.org/archives/wayland-devel/2014-September/017340.html
[3] which I try to avoid given that synaptics is somewhere between hanging
on life support and receiving pallative care.
