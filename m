Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaFFGpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 02:45:10 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:63682 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaFFGpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 02:45:08 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140606120315.6f2b1441@canb.auug.org.au>
References: <20140606120315.6f2b1441@canb.auug.org.au>
Date: Fri, 6 Jun 2014 08:45:07 +0200
Message-ID: <CAKMK7uGxKrAQq7Gjfz7U-Aby2KbOfLbuZUY486VK98obXK0mPA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the drm-intel-fixes tree
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 4:03 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the drm-intel-fixes tree, today's linux-next build
> (x86_64 allmodconfig) failed like this:
>
>
> drivers/gpu/drm/i915/intel_fbdev.c: In function 'intel_fb_initial_config':
> drivers/gpu/drm/i915/intel_fbdev.c:392:4: error: implicit declaration of function 'drm_get_connector_name' [-Werror=implicit-function-declaration]
>     DRM_DEBUG_KMS("using first mode listed on connector %s\n",
>     ^
>
> This is just the error I reported yesterday against the drm and
> drm-intel trees, but migrated to the drm-intel-fixes tree.  Your -fixes
> tree shoudl really only contain stuff that depend on Linus' trees ...
> but here it include all of yesterday's drm tree as well.

Should be fixed now since Dave pushed out the backmerge to drm-next
with the resolution.

I'm sorry about the mess this caused but Linus' interleaved merge
window has caused quite a havoc with my branch model here. But since I
have everything ready already and no outstanding fixes I've moved
drm-intel-fixes already over to track 3.17 and gather patches on top
of the all the work readied before the merge window.

> I have used the drm-intel-fixes tree from next-20140605 for today.

I think you should drop drm-intel-fixes until 3.16 is out and the
merge window properly public, otherwise this mess will repeat.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
