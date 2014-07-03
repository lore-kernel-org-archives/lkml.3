Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbaGCV7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:59:22 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:63130 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbaGCV7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:59:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140703215200.GG32514@n2100.arm.linux.org.uk>
References: <1403081488-13114-1-git-send-email-benjamin.gaignard@linaro.org>
	<CAF6AEGsLbmos9nz-AYv2v0g33BYdAgKYTe8_ihDWEF3GK_=gjQ@mail.gmail.com>
	<20140703215200.GG32514@n2100.arm.linux.org.uk>
Date: Thu, 3 Jul 2014 17:59:15 -0400
Message-ID: <CAF6AEGsAtqCjrvrgcXmOY0nie89ppFHBcRPtt36ESHWBNqobTg@mail.gmail.com>
Subject: Re: [PATCH v5 00/11] Add DRM for stih4xx platforms
From: Rob Clark <robdclark@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 5:52 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Jul 03, 2014 at 05:31:21PM -0400, Rob Clark wrote:
>> >From a brief look, it looks like my comments have been addressed, so I
>> think this is starting to shape up..
>>
>> Laurent/Thierry/Russell, I don't suppose any of you are likely to have
>> time before 3.17 merge window to give sti one last once-over to see
>> what I missed ;-)
>
> As this appears to be using the component helpers, it would be good for
> the author to be pre-warned about the change to the API.  I'm going to
> be doing this as a two step thing.
>
> The first stage of it has just been taken by Greg this evening.  This
> retires old behaviour that was needed for the initial versions of imx-drm,
> and fixes a bug.  More importantly, it introduces a new interface where
> you build the list of expected components before calling
> component_master_add(), passing it into that function.
>
> It is slightly less flexible from the driver writer's view point, but
> allows us to do more in the component helper, and support some features
> that others would like to see (such as being able to add additional
> optional components after the initial bind (that's not much interest
> to DRM though.)
>
> This should make the v3.17 merge window.  I'm hoping that by forewarning
> about the change, that people can be aware of it and have patches
> prepared for v3.18 (or maybe even v3.17) to convert over to it, so we
> can get rid of the older interface before we get too many users of it.
>
> I've just peeked at the binding document in the first patch.  I notice
> that it isn't making use of the of_graph stuff, which is a bit of a
> shame because I've sent a RFC patch adding drivers/gpu/drm/drm_of.c
> to provide a helper which encoders can use to get the CRTC mask from
> an of_graph representation.

which reminds me, I need to have a look at the drm_of stuff..

> I'm using this not only for imx-drm, but also for tda998x - and that's
> where the problems are likely to start if we end up with different
> DRM implementations doing different solutions to the connectivity
> problem.

If it simplifies merge-order stuff, I'd be ok with a follow-up patch
that converts over (assuming it shouldn't have an impact on the DT
bindings, which I'm only assuming it should not..)

Probably it would be a good idea if Benjamin at least had a patch
ready to go to convert over which could be merged right after your
stuff hits drm-next.

BR,
-R

> --
> FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
> improving, and getting towards what was expected from it.
