Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777Ab3CQV7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 17:59:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576Ab3CQV7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 17:59:17 -0400
Date: Sun, 17 Mar 2013 17:58:58 -0400
From: Dave Jones <davej@redhat.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Ben Widawsky <ben@bwidawsk.net>,
        Tommi Rantala <tt.rantala@gmail.com>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Sanity check incoming ioctl data
 for a NULL pointer
Message-ID: <20130317215858.GD3703@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Ben Widawsky <ben@bwidawsk.net>,
	Tommi Rantala <tt.rantala@gmail.com>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <CA+ydwtpuBvbwxbt-tdgPUvj1EU7itmCHo_2B3w13HkD5+jWKow@mail.gmail.com>
 <1363265997-29023-1-git-send-email-chris@chris-wilson.co.uk>
 <20130315045004.GA14747@bwidawsk.net>
 <20130315082403.GA29916@cantiga.alporthouse.com>
 <20130315163606.GA17773@bwidawsk.net>
 <20130315220619.GA17405@cantiga.alporthouse.com>
 <20130315234942.GB715@bwidawsk.net>
 <20130316101920.GB17405@cantiga.alporthouse.com>
 <CAKMK7uFiMLcE_TYj5=sKZsVAcCnWSmg49qPrxjswH2s3J5byOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFiMLcE_TYj5=sKZsVAcCnWSmg49qPrxjswH2s3J5byOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 08:50:03PM +0100, Daniel Vetter wrote:

 > Doesn't that mean that we need these checks everywhere? Or at least a
 > fixup in drm core proper?
 > 
 > And I think we need to add trinity to our test setup eventually ;-)

Note that trinity's ioctl fuzzing is still very new (added in just
the last few weeks), and for drm isn't very advanced at all yet.
I was pretty surprised when Tommi's changes started turning up bugs
so quickly, but I guess a lot of the ioctl paths have just never been
audited for these kinds of bugs.

As you can see at 
https://github.com/kernelslacker/trinity/blob/master/ioctls/drm.c
It's literally just enumerating the known ioctl's, and using the 
generic fuzzing routines (so it just guesses what the argument is,
and hence passes crap like NULL, or a page of garbage).

Eventually I'd like to have routines for each of the individual ioctl
cases to pass something that looks slightly more realistic to what
it's expecting to see.
(Compare to say, the SCSI SG_IO routines here:
 https://github.com/kernelslacker/trinity/blob/master/ioctls/scsi.c
 [still kinda dumb, but gives an idea of the direction])

Lots of work ahead.

	Dave

