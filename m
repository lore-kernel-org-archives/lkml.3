Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaLPBuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 20:50:16 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:36628 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaLPBuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 20:50:14 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxmT98972EM7OaJoF_P8AoA1Lyj6WcN9LaT+MC_wgrhRQ@mail.gmail.com>
References: <alpine.DEB.2.00.1412150715300.27943@skynet.skynet.ie>
	<CA+55aFzBS4p6NZcaggPmgOuRqnny4q+FcH6RM-5swJCw205JgA@mail.gmail.com>
	<CAPM=9twW6f2OoW4h8FAvKc+5f3MSTf1jnP+NCrnrQuWc_33tRA@mail.gmail.com>
	<CA+55aFxmT98972EM7OaJoF_P8AoA1Lyj6WcN9LaT+MC_wgrhRQ@mail.gmail.com>
Date: Tue, 16 Dec 2014 11:50:11 +1000
Message-ID: <CAPM=9tx=vkMFhiRRYkoaxL+a9vjMREMTO=xo68Xxsxuto5LWhw@mail.gmail.com>
Subject: Re: [git pull] drm for 3.19-rc1
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 December 2014 at 11:03, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Dec 15, 2014 at 4:48 PM, Dave Airlie <airlied@gmail.com> wrote:
>>
>> I'd be inclined to just revert this for now, it is annoying we let
>> userspace away with this, but we probably need to find a better
>> way to enforce it, since the cat is out of the bag.
>
> .. why did that commit ever even get far enough to get to me?
>
> It seems to happen on any reasonably modern Intel graphics - at least
> it happens on both my laptop and my desktop. And I'm running
> bog-standard F20, so either nobody ever even tested that broken thing,
> or nobody bothered to look at the messages to notice it was broken.
> Either way, it shows a rather distinct lack of actual testing,
> wouldn't you say?
>
> I really see no excuse for crap like this. If I find obvious bugs
> immediately, on my very normal hardware and very normal distribution,
> that means that there is something wrong in the development process.
> If I was some subtle timing-dependent thing, or I were to be using
> eally odd hardware, or I had to do something special to trigger it,
> that would be one thing. But that's definitely not the case here.

Its a rather straightforward revert, patch should have used an
DRM_INFO rather than WARN at this point, people like WARN
because automatic tools find them on the Internet and make it
easier to track down, but it also freaks everyone out when they
see a backtrace, and there are ongoing discussion with the WARN
fans to tone them down. especially where things continue fine after
them. I think a few people have become immune to i915 WARNs
in logs, and we are trying to bring that back a bit.

Now you might complain that printing anything in this case is bad,
but I've got machines with buckets of deprecated sysctl warnings
etc, so the precedent has well been set for at least trying to track
down bad userspace behaviour.
e.g. I see
WARNING! power/level is deprecated; use power/control instead

This patch was just over zealous in picking it reporting method.

I'd have to ask the i915 folks why it didn't get seen there,
I haven't had the bandwidth to test -next on the haswell laptop
I have here and I expect this would happen on it fine, but I've been
running it on a few amd/nvidia laptops to diversify testing a bit.

The patch came from VMware developers and maybe it
didn't get into the Intel developers test cycle early enough
for them to notice it. Its main job was to find out early if
userspace things were breaking the rules, and it looks
like yes they were, and its a pity nobody noticed earlier.

Dave.
