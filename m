Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaGWHJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:09:23 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:37165 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaGWHJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:09:22 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <53CF5EFE.6070307@canonical.com>
References: <20140709093124.11354.3774.stgit@patser>
	<20140709122953.11354.46381.stgit@patser>
	<CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
	<53CE2421.5040906@amd.com>
	<20140722114607.GL15237@phenom.ffwll.local>
	<20140722115737.GN15237@phenom.ffwll.local>
	<53CE56ED.4040109@vodafone.de>
	<20140722132652.GO15237@phenom.ffwll.local>
	<53CE6AFA.1060807@vodafone.de>
	<CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>
	<53CE84AA.9030703@amd.com>
	<CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com>
	<53CE8A57.2000803@vodafone.de>
	<53CF58FB.8070609@canonical.com>
	<53CF5B9F.1050800@amd.com>
	<53CF5EFE.6070307@canonical.com>
Date: Wed, 23 Jul 2014 09:09:21 +0200
Message-ID: <CAKMK7uHijSve_CsDE+pUk8+tjCAZjL7-nZCKeUkKuuufCPS4tQ@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence
 implementation for fences
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>,
        Dave Airlie <airlied@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 9:06 AM, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
>> Can we somehow avoid the need to call fence_signal() at all? The interrupts at least on radeon are way to unreliable for such a thing. Can enable_signalling fail? What's the reason for fence_signaled() in the first place?
> It doesn't need to be completely reliable, or finish immediately.
>
> And any time wake_up_all(&rdev->fence_queue) is called all the fences that were enabled will be rechecked.

I raised this already somewhere else, but should we have some common
infrastructure in the core fence code to recheck fences periodically?
radeon doesn't seem to be the only hw where this isn't reliable
enough. Of course timer-based rechecking would only work if the driver
provides the fence->signalled callback to recheck actual fence state.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
