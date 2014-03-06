Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaCFH6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 02:58:42 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:64777 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaCFH6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 02:58:40 -0500
Date: Thu, 6 Mar 2014 08:58:35 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Jon Mason <jon.mason@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] Taint the kernel for unsafe module options
Message-ID: <20140306075835.GC17001@phenom.ffwll.local>
Mail-Followup-To: Rusty Russell <rusty@rustcorp.com.au>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	Jean Delvare <khali@linux-fr.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Li Zhong <zhong@linux.vnet.ibm.com>,
	Jon Mason <jon.mason@intel.com>, linux-kernel@vger.kernel.org
References: <1394011994-30604-1-git-send-email-daniel.vetter@ffwll.ch>
 <87r46gywul.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r46gywul.fsf@rustcorp.com.au>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 11:19:54AM +1030, Rusty Russell wrote:
> Daniel Vetter <daniel.vetter@ffwll.ch> writes:
> > Users just love to set random piles of options since surely enabling
> > all the experimental stuff helps. Later on we get bug reports because
> > it all fell apart.
> >
> > Even more fun when it's labelled a regression when some change only
> > just made the feature possible (e.g. stolen memory fixes suddenly
> > making fbc possible).
> >
> > Make it clear that users are playing with fire here. In drm/i915 all
> > these options follow the same pattern of using -1 as the per-machine
> > default, and any other value being used for force the parameter.
> >
> > Adding a pile of cc's to solicit input and figure out whether this
> > would be generally useful - this quick rfc is just for drm/i915.
> 
> If this is a good idea, you can write a macro module_param_unsafe_named
> which is a general wrapper.

For this to work I need to somehow store the safe default value somewhere.
since with bools or strings there really isn't such a thing, even less
than with integers where my fairly abitrary -1 choice is already
restricting. But I don't have a good idea how to do that, since creating a
local static struct in the macro to store the default + the pointer to the
storage location feels a bit ugly.

> > -module_param_named(modeset, i915.modeset, int, 0400);
> 
> Wait, WTF?  Why do you prefix i915 here manually?  That means that
> the commandline parameter would be "i915.i915.modeset=" and the
> module parameter would be "i915.modeset="...

Nope, this is the named macro. The name of the param is the first
parameter to the macro "modeset", "i915.modeset" is just the variable
it'll get stored in. We've specifically switched to the _named version to
avoid ugly i915.i915* paramters ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
