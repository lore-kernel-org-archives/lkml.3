Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbaCEVA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:00:59 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:58308 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283AbaCEVA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:00:56 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140305123250.8caa9c6abc2b40d812bbb1b2@linux-foundation.org>
References: <1394011994-30604-1-git-send-email-daniel.vetter@ffwll.ch>
	<20140305123250.8caa9c6abc2b40d812bbb1b2@linux-foundation.org>
Date: Wed, 5 Mar 2014 22:00:56 +0100
Message-ID: <CAKMK7uHyQ04-bAjYw9Fjud_2bDwXkgq5iOQU+7N7aZGVYPT5WA@mail.gmail.com>
Subject: Re: [PATCH] [RFC] Taint the kernel for unsafe module options
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jean Delvare <khali@linux-fr.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Jon Mason <jon.mason@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 9:32 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed,  5 Mar 2014 10:33:14 +0100 Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
>> Users just love to set random piles of options since surely enabling
>> all the experimental stuff helps. Later on we get bug reports because
>> it all fell apart.
>>
>> Even more fun when it's labelled a regression when some change only
>> just made the feature possible (e.g. stolen memory fixes suddenly
>> making fbc possible).
>>
>> Make it clear that users are playing with fire here. In drm/i915 all
>> these options follow the same pattern of using -1 as the per-machine
>> default, and any other value being used for force the parameter.
>>
>> Adding a pile of cc's to solicit input and figure out whether this
>> would be generally useful - this quick rfc is just for drm/i915.
>
> Seems harmless and potentially useful to others so yes, I'd vote for
> putting it in core kernel.
>
> However this only handles integers.  Will we end up needed great gobs
> of new code to detect unsafe setting of u8's, strings, etc?

Well I've just done integers because hardcoding the -1 default was so
easy ... But thinking about it some more (and looking at some more mod
params in i915) passing the default to the macro and storing it in
some struct, together with the pointer for the variable sounds useful.
With that this could be easily extended to all kinds of types.

Now would such a temporary structure to store the default be
acceptable or is there some neater trick to pull this off?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
