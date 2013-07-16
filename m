Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab3GPLNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:13:45 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:36071 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3GPLNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:13:44 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130716083140.GK2823@cantiga.alporthouse.com>
References: <20130714163009.22374.22100.stgit@zurg>
	<CAKMK7uEtReZxvzJj9LsSXEJEBNiK492CCONdsF5VFK2cA3u0FA@mail.gmail.com>
	<51E2E65D.5050803@openvz.org>
	<20130716063101.GK5784@phenom.ffwll.local>
	<CALYGNiOtt7FUCTqcyBELoHYEVw_zqmA=bpmHy_nDkhXCduB9qg@mail.gmail.com>
	<20130716074458.GM5784@phenom.ffwll.local>
	<20130716083140.GK2823@cantiga.alporthouse.com>
Date: Tue, 16 Jul 2013 13:13:43 +0200
X-Google-Sender-Auth: opQY_lMvLAWV-1LOhK8HQy2-jts
Message-ID: <CAKMK7uFyu74z5+EFJHdXxHaaVHN=YG89Ak2obZ_hubxam+1G5w@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: fix long-standing SNB regression in power
 consumption after resume
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 10:31 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Tue, Jul 16, 2013 at 09:44:59AM +0200, Daniel Vetter wrote:
>> The issue I have with the current patch is that it looks a bit like
>> duct-tape since the point where we drop the forcewake references seems to
>> lack justification. The write to MBCTL itself will temporarily wake up the
>> chip, so just wrapping that up in with forcewake is very likely not good
>> enough. So I fear that we'll only hold forcewake long enough on most
>> systems and still have a bunch of oddball broken systems out there.
>>
>> Holding forcewake otoh until we've fully set up rps/rc6 makes imo tons of
>> sense, hence why I've brought up the idea. Same reasoning applies to
>> extending the w/a to all systems supporting rc6.
>
> In which case disable rc6 at the start of init gating and only enable it
> at the end of the deferred task. That I think will better test your
> hypothesis and make the transistion steps clearer.

Hm yeah, that would be much clearer instead of risky tricks with a
refcount which is only dropped someplace completely else.
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
