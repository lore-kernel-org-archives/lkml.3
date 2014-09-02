Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaIBEPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 00:15:42 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:50450 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaIBEPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 00:15:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140902040527.GA5508@thunk.org>
References: <20140902040527.GA5508@thunk.org>
Date: Tue, 2 Sep 2014 14:15:39 +1000
Message-ID: <CAPM=9txYd6LBojX+y5TYdW=8O=v49mcodj4iBZAmytXTRL68LA@mail.gmail.com>
Subject: Re: [REGRESSION] i915: failure to see Dell 30" monitor connected to a
 Lenovo Haswell docking station
From: Dave Airlie <airlied@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jani Nikula <jani.nikula@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 September 2014 14:05, Theodore Ts'o <tytso@mit.edu> wrote:
> I recently upgraded to v3.17-rc3, and on my Lenovo T540p, I can no
> longer see the my Dell 30" monitor when it is connected via the
> docking station using a Displayport connector.  This worked using 3.16
> kernel.
>
> If I connect to the monitor using the mini-display, by passing the
> docking station, things work fine (but of course it's annoying not to
> be able to use the docking station).
>
> Is this a known problem?  This is not the first time that we've had
> regressions with this docking station.   It's vaguely reminsicent of
>
>         https://bugs.freedesktop.org/show_bug.cgi?id=71267
>
> Except the system isn't hanging; it's just not seeing the monitor at all.

Have you the Dell 30" set to Displayport 1.2 enabled mode?

If so, then see if disabling that in the monitor menus helps.

This is probably due to the fact we now attempt to talk to new DP devices
with the protocol they provide. So previously the monitor exposed DP 1.2
and we just didn't care, now if it exposes it we attempt to talk to it.

Dave.
