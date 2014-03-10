Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaCJKHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:07:38 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:55043 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaCJKHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:07:37 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140310100425.GH20302@nuc-i3427.alporthouse.com>
References: <20140224160628.GU3852@intel.com>
	<1394304546-19433-1-git-send-email-sagar.a.kamble@intel.com>
	<CADnq5_P_j66y2j3v8r9jHOffhfz3L3_fQpnP-OFdfOeLEWqs8A@mail.gmail.com>
	<1394305472.18918.1.camel@sagar-desktop>
	<1394305669.18918.3.camel@sagar-desktop>
	<20140310092919.GG20302@nuc-i3427.alporthouse.com>
	<CAKMK7uEFpkRs5euH_un=3MEstwO2PMwk0RAOhP-2+cgfMK1sgA@mail.gmail.com>
	<20140310100425.GH20302@nuc-i3427.alporthouse.com>
Date: Mon, 10 Mar 2014 11:07:36 +0100
Message-ID: <CAKMK7uH8WnsoPVEHhARLHao3XS6wVT-=3aUU0BNrxTQBT5=qXA@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH v3 1/1] drm/i915: Enabling 128x128 and 256x256
 ARGB Cursor Support
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sagar Arun Kamble <sagar.a.kamble@intel.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 11:04 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> > The cap exposes the max cursor size. Knowing our hardware we can infer
>> > that pot sizes from 64 to max are supported, but it would be better if
>> > we did expose that information through the cap as well.
>>
>> I think the right approach here is to expose this through the
>> cursor-as-real-plane interface, which kinda has this already. On top
>> of that we can then add a few fourcc enumerations of the fixed rgba
>> cursor layouts like 64x64, 128x128, ... This helps if the plane is a
>> general one with very high limits, but also with special support for
>> cursor formats.
>>
>> If anyone wants to go crazy we could then also add new fourccs for all
>> the other cursor layouts - atm only rgba with fixed dimensions can be
>> support with the current cursor ioctl.
>>
>> So reviewing the overall situation I actually _don't_ want a new
>> cap/ioctl/prop here just for now. As long as we need to go with intel
>> specific hacks userspace might as well probe things manually and act
>> upon the -EINVAL.
>
> Adding the cap allows existing userspace to dtrt...

1. Move cursor off-screen.
2. Check desired cursor layout with set_cursor.
3. Pick real cursor, set it.

Or

1. Use set_cursor on disabled crtc.

Both aren't pretty, but that ugly should help to move
cursors-as-real-planes forward ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
