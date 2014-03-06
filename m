Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbaCFC5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 21:57:44 -0500
Received: from ozlabs.org ([203.10.76.45]:47701 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379AbaCFC5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 21:57:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Jon Mason <jon.mason@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] Taint the kernel for unsafe module options
In-Reply-To: <1394011994-30604-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1394011994-30604-1-git-send-email-daniel.vetter@ffwll.ch>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 06 Mar 2014 11:19:54 +1030
Message-ID: <87r46gywul.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Vetter <daniel.vetter@ffwll.ch> writes:
> Users just love to set random piles of options since surely enabling
> all the experimental stuff helps. Later on we get bug reports because
> it all fell apart.
>
> Even more fun when it's labelled a regression when some change only
> just made the feature possible (e.g. stolen memory fixes suddenly
> making fbc possible).
>
> Make it clear that users are playing with fire here. In drm/i915 all
> these options follow the same pattern of using -1 as the per-machine
> default, and any other value being used for force the parameter.
>
> Adding a pile of cc's to solicit input and figure out whether this
> would be generally useful - this quick rfc is just for drm/i915.

If this is a good idea, you can write a macro module_param_unsafe_named
which is a general wrapper.

> -module_param_named(modeset, i915.modeset, int, 0400);

Wait, WTF?  Why do you prefix i915 here manually?  That means that
the commandline parameter would be "i915.i915.modeset=" and the
module parameter would be "i915.modeset="...

Confused,
Rusty.
