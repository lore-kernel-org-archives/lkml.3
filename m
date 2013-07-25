Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3GYWPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 18:15:31 -0400
Received: from home.keithp.com ([63.227.221.253]:57114 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881Ab3GYWP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 18:15:29 -0400
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH 4/5] drm/i915: Add async page flip support for IVB
Date: Thu, 25 Jul 2013 15:15:13 -0700
Message-Id: <1374790515-29657-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <CAKMK7uFiL+p48Phwc=jmWtsOgjNOYJzTCWmHe3Bp7-jWMpTtTA@mail.gmail.com>
References: <CAKMK7uFiL+p48Phwc=jmWtsOgjNOYJzTCWmHe3Bp7-jWMpTtTA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Generally I think checking our current sw state instead of reading hw
> registers would be safer, e.g. in case we start to queue up more than
> one pageflip. For async pageflips in benchmark mode "flip as fast as
> you can queue" would be a sensible mode.

Ok, I've moved the tiling checks to the general code and removed the
stride checks as those are already present there. These were moved to
the general code because the pointer to the previous FB has already
been overwritten by the time the queue_flip functions are called.

This should be followed by replacements for the last to patches in the
series.

-keith

