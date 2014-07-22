Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaGVEFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 00:05:39 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:45245 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaGVEFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 00:05:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140709122953.11354.46381.stgit@patser>
References: <20140709093124.11354.3774.stgit@patser>
	<20140709122953.11354.46381.stgit@patser>
Date: Tue, 22 Jul 2014 14:05:35 +1000
Message-ID: <CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
Subject: Re: [PATCH 09/17] drm/radeon: use common fence implementation for fences
From: Dave Airlie <airlied@gmail.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Dave Airlie <airlied@linux.ie>, Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        "Koenig, Christian" <christian.koenig@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 July 2014 22:29, Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> ---
>  drivers/gpu/drm/radeon/radeon.h        |   15 +-
>  drivers/gpu/drm/radeon/radeon_device.c |   60 ++++++++-
>  drivers/gpu/drm/radeon/radeon_fence.c  |  223 ++++++++++++++++++++++++++------
>  3 files changed, 248 insertions(+), 50 deletions(-)
>

>From what I can see this is still suffering from the problem that we
need to find a proper solution to,

My summary of the issues after talking to Jerome and Ben and
re-reading things is:

We really need to work out a better interface into the drivers to be
able to avoid random atomic entrypoints,

I'm sure you have some ideas and I think you really need to
investigate them to move this thing forward,
even it if means some issues with android sync pts.

but none of the two major drivers seem to want the interface as-is so
something needs to give

My major question is why we need an atomic callback here at all, what
scenario does it cover?

Surely we can use a workqueue based callback to ask a driver to check
its signalling, is it really
that urgent?

Dave.
