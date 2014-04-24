Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaDXGDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 02:03:37 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:55689 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaDXGDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:03:04 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140424055023.GA31221@nuc-i3427.alporthouse.com>
References: <20140423202248.GA3621@amd.pavel.ucw.cz>
	<CAKMK7uFT5eW8Y8kKvWO1P_aN=SHgP+bZWB8fO2mATKaO=_DNjA@mail.gmail.com>
	<20140423220952.GA3627@amd.pavel.ucw.cz>
	<20140424055023.GA31221@nuc-i3427.alporthouse.com>
Date: Thu, 24 Apr 2014 08:03:04 +0200
Message-ID: <CAKMK7uFAgHJ-kYJEcDCvNm3B4ELKC8CFK8iP+-SL7bdT5-VQHA@mail.gmail.com>
Subject: Re: 3.15-rc2: i915 regression: only top 20% of screen works in X
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>, Pavel Machek <pavel@ucw.cz>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 7:50 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> That says that i915.ko failed to initialise the GPU (or rather the GPU
> wasn't responding) and bailed during module load. The key line here is
>
> [drm:init_ring_common] *ERROR* render ring initialization failed ctl
> 0001f001 head 00002034 tail 00000000 start 0012f000
>
> Jiri has been seeing a similar issue creep in during resume, but it is
> not reliable enough to bisect. Is your boot failure reliable enough to
> bisect? Also drm-intel-nightly should mitigate this failure and allow
> i915.ko to continue to load and run X, which would be worth testing to
> make sure that works as intended.

Oh right, g4x going beserk :( Apparently something changed in 3.15
somewhere which made this much more likely, but like Chris said in
Jiri's case it's too unreliable to reproduce for a bisect. We've had
this come&go pretty much ever since kms support was merged and never
tracked it down.

The bug is https://bugs.freedesktop.org/show_bug.cgi?id=76554

Like Chris said please test latest drm-intel-nighlty from
http://cgit.freedesktop.org/drm-intel to make sure that the recently
merged mitigation measures work properly. But those won't get your gpu
back, only the display and it's only for 3.16. We're still hunting a
proper fix for 3.15.

And if you can indeed reliably reproduce this a bisect could be really useful.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
