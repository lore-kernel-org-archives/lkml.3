Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760913Ab3DKSON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:14:13 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:65479 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3DKSOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:14:11 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130411175220.GC2482@netboy>
References: <20130409172820.GC27612@phenom.ffwll.local>
	<1365537090-11518-1-git-send-email-daniel.vetter@ffwll.ch>
	<20130410115901.GA4502@netboy>
	<20130410120724.GJ27612@phenom.ffwll.local>
	<20130410172717.GA2480@netboy>
	<CAKMK7uGTqSdq_V=Pu-BGNhhTqOn=fz5-LvUXBXpGQJqzL1QOUQ@mail.gmail.com>
	<20130411175220.GC2482@netboy>
Date: Thu, 11 Apr 2013 20:14:10 +0200
X-Google-Sender-Auth: Sib8mfgMgE2IyIWUR5_Wqhit6nk
Message-ID: <CAKMK7uFVpnbxT-P+eEoFjKPJ1bEom7Q_PhNcr1ZnzApkc8mqug@mail.gmail.com>
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

On Thu, Apr 11, 2013 at 7:52 PM, Richard Cochran
<richardcochran@gmail.com> wrote:
> On Wed, Apr 10, 2013 at 10:03:25PM +0200, Daniel Vetter wrote:
>
>> That patch should crash at all, so this is not expected. Can you pls
>> check whether plain drm-intel-nightly is broken, too?
>
> I did try drm-intel-nightly just now (1dd83e3), and it also freezes
> the machine. I first verified that the power button shutdown is
> working (before starting X). Then, with X running, closing and
> reopening the lid results in a blank screen (no backlight) and a
> seemingly frozen box.

I've just tracked down and fixed an bug which can lead to a hard-hang
in the crtc restore code (which is used both in the lid handler when
opening and on resume). If you could please test this patch (on top of
drm-intel-nightly):

https://patchwork.kernel.org/patch/2428971/

>> I'll quickly port the patch (in it's latest v3 version) to 3.9-rc
>> kernels for you to test.
>
> Okay, I'll try this next.

Thanks, Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
