Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbaFSOg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:36:26 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:40440 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbaFSOgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:36:25 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <CAKMK7uGEVFnSYkaxLgfJ=JxUjEFst=axmQ-OW_jyFzKFqZZyVA@mail.gmail.com>
References: <1403131134-9533-1-git-send-email-bergo.torino@gmail.com>
	<CAKMK7uFbZgoVDkiJV34Tvf_KDdZo+xi9w3Qi+9_9-+WvPOKR3w@mail.gmail.com>
	<20140619124507.GA12390@t400>
	<CAKMK7uGEVFnSYkaxLgfJ=JxUjEFst=axmQ-OW_jyFzKFqZZyVA@mail.gmail.com>
Date: Thu, 19 Jun 2014 16:36:24 +0200
Message-ID: <CAKMK7uEbtqa3uF82CwnD4mBYfOsFpGO-Cm94_U2UFw7orTULnA@mail.gmail.com>
Subject: Re: [PATCH] drivers/i915: Fix unnoticed failure of init_ring_common()
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Konrad Zapalowicz <bergo.torino@gmail.com>
Cc: "Nikula, Jani" <jani.nikula@linux.intel.com>,
        Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 4:35 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> The actual bug we seem to have is blowing up on the ggtt_unpin in
> context_fini. Which is doubly-impossible: Gen4 doesn't have hw
> contexts, so should have dctx->obj == NULL. And ring init failures
> fail earlier so shouldn't even hit the context_fini code below the
> cleanup_gem: label in driver_load. Seriously confused here.

Also please retest with latest upstream, we've made the ring init
failure non-letal for the driver. That should help you, too.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
