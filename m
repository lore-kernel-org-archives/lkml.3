Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaGGNez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:34:55 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:32879 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbaGGNey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:34:54 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <CAPM=9txtM09G8_nW1ZTFNQqc_h_ZSBhUumrY0eZd_v+bxQ28wg@mail.gmail.com>
References: <alpine.DEB.2.00.1407052310460.24632@skynet.skynet.ie>
	<5878240.sEB4GAESUK@grover>
	<CAPM=9txtM09G8_nW1ZTFNQqc_h_ZSBhUumrY0eZd_v+bxQ28wg@mail.gmail.com>
Date: Mon, 7 Jul 2014 15:34:53 +0200
X-Google-Sender-Auth: ZOkkDfAziBvXh0702uukwfZ5tfA
Message-ID: <CAKMK7uG7=wZwHwHMseAxg0eS6Tv229k3LKx7P=+u6GQYq+0NiQ@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Ed Tomlinson <edt@aei.ca>, Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 6, 2014 at 10:49 AM, Dave Airlie <airlied@gmail.com> wrote:
> On 6 July 2014 12:24, Ed Tomlinson <edt@aei.ca> wrote:
>> Hi Dave,
>>
>> This is NOT fixing problems with a stalled boot due to VGA problems as
>> reported in thread: [PATCH 5/5] drm/i915: Kick out vga console
>> It can be fixed by reverting: a4de05268e674e8ed31df6348269e22d6c6a1803
>> or applying the patch from Chris Wilson which can be found as a reply to my report.
>
> I was hoping Daniel would get to it, but he is on holidays (as am I
> really!), I'll take a look at the fix when I'm back in the office
> myself if nobody has sent it to me.

I've just sent Ed a refined diff for testing to make sure that we only
unbind vgacon if necessariy, but still unregister it (to make sure it
can't ever interfere with module unloading). If that checks out I'll
submit this as a real patch, otherwise we can go with Chris' slightly
bigger cannon.

In any case there seems to be a bigger dragon lurking since unbinding
the radeon fbcon really should kill the machine (but it can result in
a bit of a black screen, so checking that vgacon is bound is trtdt
nevertheless).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
