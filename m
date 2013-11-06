Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab3KFDpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 22:45:34 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:53464 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3KFDpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 22:45:33 -0500
MIME-Version: 1.0
In-Reply-To: <20131030230414.GA4064@udknight>
References: <20131030230414.GA4064@udknight>
Date: Wed, 6 Nov 2013 13:45:31 +1000
Message-ID: <CAPM=9tzgqeOcBLg__3+TriAcR1Yx7QKOJLEboRMvsoGmrS5bYg@mail.gmail.com>
Subject: Re: [PATCH 0/5] drm: fix resources leak in error handle code path
From: Dave Airlie <airlied@gmail.com>
To: Wang YanQing <udknight@gmail.com>, Dave Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 9:04 AM, Wang YanQing <udknight@gmail.com> wrote:
> This series patches fix resource leak
> issue in error handle code path I meet
> with drm, vmalloc leak, etc.

Daniel this seems to cross over a bit with your cleanups,

I also am not sure that the drm_cleanup_in_dev isn't going to cause
issues as it reorders the unload operation with respect to other
operations, and I wonder if legacy drivers might start crashing in
this situation.

Dave.
