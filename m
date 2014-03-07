Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaCGDkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:40:43 -0500
Received: from ozlabs.org ([203.10.76.45]:49209 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbaCGDkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:40:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Jon Mason <jon.mason@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] Taint the kernel for unsafe module options
In-Reply-To: <20140306075835.GC17001@phenom.ffwll.local>
References: <1394011994-30604-1-git-send-email-daniel.vetter@ffwll.ch> <87r46gywul.fsf@rustcorp.com.au> <20140306075835.GC17001@phenom.ffwll.local>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 07 Mar 2014 13:58:21 +1030
Message-ID: <8738iuznze.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Vetter <daniel@ffwll.ch> writes:
> On Thu, Mar 06, 2014 at 11:19:54AM +1030, Rusty Russell wrote:
>> Daniel Vetter <daniel.vetter@ffwll.ch> writes:
>> > Users just love to set random piles of options since surely enabling
>> > all the experimental stuff helps. Later on we get bug reports because
>> > it all fell apart.
>> >
>> > Even more fun when it's labelled a regression when some change only
>> > just made the feature possible (e.g. stolen memory fixes suddenly
>> > making fbc possible).
>> >
>> > Make it clear that users are playing with fire here. In drm/i915 all
>> > these options follow the same pattern of using -1 as the per-machine
>> > default, and any other value being used for force the parameter.
>> >
>> > Adding a pile of cc's to solicit input and figure out whether this
>> > would be generally useful - this quick rfc is just for drm/i915.
>> 
>> If this is a good idea, you can write a macro module_param_unsafe_named
>> which is a general wrapper.
>
> For this to work I need to somehow store the safe default value somewhere.
> since with bools or strings there really isn't such a thing, even less
> than with integers where my fairly abitrary -1 choice is already
> restricting. But I don't have a good idea how to do that, since creating a
> local static struct in the macro to store the default + the pointer to the
> storage location feels a bit ugly.

I was thinking that if use the parameter, they get marked unsafe.  If
they use it to set it to the default, Don't Do That.

>> > -module_param_named(modeset, i915.modeset, int, 0400);
>> 
>> Wait, WTF?  Why do you prefix i915 here manually?  That means that
>> the commandline parameter would be "i915.i915.modeset=" and the
>> module parameter would be "i915.modeset="...
>
> Nope, this is the named macro. The name of the param is the first
> parameter to the macro "modeset", "i915.modeset" is just the variable
> it'll get stored in. We've specifically switched to the _named version to
> avoid ugly i915.i915* paramters ;-)

Oh, oops, my bad reading!  I'll shut up now :)

Thanks,
Rusty.
