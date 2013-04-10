Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936200Ab3DJUD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:03:27 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:41561 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab3DJUD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:03:26 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130410172717.GA2480@netboy>
References: <20130409172820.GC27612@phenom.ffwll.local>
	<1365537090-11518-1-git-send-email-daniel.vetter@ffwll.ch>
	<20130410115901.GA4502@netboy>
	<20130410120724.GJ27612@phenom.ffwll.local>
	<20130410172717.GA2480@netboy>
Date: Wed, 10 Apr 2013 22:03:25 +0200
X-Google-Sender-Auth: 1ekwyV2Z2F5FYzPUqbP_SyqH-y4
Message-ID: <CAKMK7uGTqSdq_V=Pu-BGNhhTqOn=fz5-LvUXBXpGQJqzL1QOUQ@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: don't check inconsistent modeset
 state when force-restoring
From: Daniel Vetter <daniel@ffwll.ch>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Tomas Melin <tomas.melin@iki.fi>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 7:27 PM, Richard Cochran
<richardcochran@gmail.com> wrote:
> On Wed, Apr 10, 2013 at 02:07:24PM +0200, Daniel Vetter wrote:
>>
>> It's written against drm-intel-next-queued at
>>
>> http://cgit.freedesktop.org/~danvet/drm-intel
>>
>> I've thought that it should apply pretty cleanly against older kernels,
>> too. Apparently it conflicts a bit in intel_modeset_setup_hw_state, you
>> can just do the s/intel_crtc_restore_mode/__intel_set_mode/ change
>> manually.
>
> I couldn't see right away how to fix it up, so I just compiled your
> drm-intel-next-queued plus this patch. If I close the netbook's lid
> and open it again, the screen is blank, no backlight, and the machine
> seems to be frozen.
>
> I think I can live with the warning.

That patch should crash at all, so this is not expected. Can you pls
check whether plain drm-intel-nightly is broken, too?

I'll quickly port the patch (in it's latest v3 version) to 3.9-rc
kernels for you to test.
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
