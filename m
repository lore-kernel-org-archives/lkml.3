Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3CKVIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:08:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60652 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab3CKVIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:08:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130311205251.GB31324@cantiga.alporthouse.com>
References: <20130311192716.GA18244@www.outflux.net>
	<20130311205251.GB31324@cantiga.alporthouse.com>
Date: Mon, 11 Mar 2013 14:08:22 -0700
X-Google-Sender-Auth: OJBmfRNSEwSf2_SnL7463um4fr8
Message-ID: <CAGXu5jKJqkWoiQOwWrfy33KDoSZdH_GB6O5=pr+yxi7U74pg8Q@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: bounds check execbuffer relocations
From: Kees Cook <keescook@chromium.org>
To: Chris Wilson <chris@chris-wilson.co.uk>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 1:52 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Mon, Mar 11, 2013 at 12:27:16PM -0700, Kees Cook wrote:
>> It is possible to wrap the counter used to allocate the buffer for
>> relocation copies. This could lead to heap writing overflows.
>
> Seems a sensible check, just in the wrong location. You need to do the
> checking upfront in validate_exec_list() so that the error condition is
> always hit and that the limits are applied consistently to all
> execbuffers.

I opted for it here because it kept it out of the fast path which
didn't need this check (it uses a list rather than an array). I will
move it to validate_exec_list().

Thanks!

-Kees

--
Kees Cook
Chrome OS Security
