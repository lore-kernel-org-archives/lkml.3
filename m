Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab3IJIQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:16:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56250 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab3IJIQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:16:37 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyy_pKt07MgB9PzKg-LLKj1PH0q1t8y2Zu42srCyw-W4w@mail.gmail.com>
References: <alpine.DEB.2.00.1309051139240.25450@skynet.skynet.ie>
	<CA+55aFwyKmVWkrV3=XiuruZzeTicpfW-JrwjWzpq9eP2yGPeJA@mail.gmail.com>
	<20130905153243.43d0346e@jbarnes-desktop>
	<CA+55aFybVR6MqWpQfTu3jK8mgSg8Z53gz0Ah77ZK1+40Fx=FsQ@mail.gmail.com>
	<CA+55aFwOme_LD6qqmzdEQ6AXiK8My7PWU1y5VV2tLgkO1HU7xg@mail.gmail.com>
	<CA+55aFyy_pKt07MgB9PzKg-LLKj1PH0q1t8y2Zu42srCyw-W4w@mail.gmail.com>
Date: Tue, 10 Sep 2013 10:16:33 +0200
Message-ID: <CAN+gG=Fi2dQGGcYsmNA6-39fh2J7zoD0DkJnbq44wKHH9GURyQ@mail.gmail.com>
Subject: Re: [git pull] drm tree for 3.12-rc1
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>,
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

On Fri, Sep 6, 2013 at 2:56 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Sep 5, 2013 at 4:19 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> So I've decided I'm going to try to bisect this after all. I've done
>> enough pulls for today anyway, I guess. Let's see if I can bisect it
>> by just trying to boot many times each try.
>
> Ok, it's not the recent drm pull at all. I can't find a good kernel in
> the bunch - they all fail eventually.
>
> It may have been going in for as long as I've had this Haswell
> machine, and I was just lucky (and not rebooting a lot until in the
> merge window - and 4/5 boots work fine).
>
> It may also be user-space and have come in with the mesa update I got
> through yum yesterday. So there might be multiple reasons why I saw it
> today after the drm pull for the first time.
>
> The black screen - when it happens - happens after the fedora logo has
> flashed, and gdm is supposed to start up. I tried reproducing it by
> logging out and back in again (to restart X), but that doesn't do it.
> Maybe timing-related with boot or just demand-loading of binaries the
> first time, whatever.. Or mayby it's something special that gdm does
> at startup?
>

Hi Linus,

this _may_ be related to:
 https://bugzilla.redhat.com/show_bug.cgi?id=989763

I also have a 3rd gen Intel core GPU (so not HSW) which shut off the
backlight while launching GDM (but for me, it happens at each boot).
Using the brightness increase keyboard shortcut is enough for me to
light up the backlight and see the session login.

Not sure it will solve the problem, but it worth trying :)

Cheers,
Benjamin
