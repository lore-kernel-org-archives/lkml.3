Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaCJJzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:55:43 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:37402 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaCJJzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:55:40 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140310092919.GG20302@nuc-i3427.alporthouse.com>
References: <20140224160628.GU3852@intel.com>
	<1394304546-19433-1-git-send-email-sagar.a.kamble@intel.com>
	<CADnq5_P_j66y2j3v8r9jHOffhfz3L3_fQpnP-OFdfOeLEWqs8A@mail.gmail.com>
	<1394305472.18918.1.camel@sagar-desktop>
	<1394305669.18918.3.camel@sagar-desktop>
	<20140310092919.GG20302@nuc-i3427.alporthouse.com>
Date: Mon, 10 Mar 2014 10:55:40 +0100
Message-ID: <CAKMK7uEFpkRs5euH_un=3MEstwO2PMwk0RAOhP-2+cgfMK1sgA@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH v3 1/1] drm/i915: Enabling 128x128 and 256x256
 ARGB Cursor Support
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Sagar Arun Kamble <sagar.a.kamble@intel.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 10:29 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> Realized after sending mail that we just get to know current cursor
>> width and height. Can we have capability that exposes all supported
>> cursor sizes?
>
> The cap exposes the max cursor size. Knowing our hardware we can infer
> that pot sizes from 64 to max are supported, but it would be better if
> we did expose that information through the cap as well.

I think the right approach here is to expose this through the
cursor-as-real-plane interface, which kinda has this already. On top
of that we can then add a few fourcc enumerations of the fixed rgba
cursor layouts like 64x64, 128x128, ... This helps if the plane is a
general one with very high limits, but also with special support for
cursor formats.

If anyone wants to go crazy we could then also add new fourccs for all
the other cursor layouts - atm only rgba with fixed dimensions can be
support with the current cursor ioctl.

So reviewing the overall situation I actually _don't_ want a new
cap/ioctl/prop here just for now. As long as we need to go with intel
specific hacks userspace might as well probe things manually and act
upon the -EINVAL.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
