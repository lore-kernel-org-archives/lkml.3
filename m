Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbaHHNOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:14:17 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:48010 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbaHHNOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:14:16 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <53E4B338.3040904@suse.com>
References: <53E4B338.3040904@suse.com>
Date: Fri, 8 Aug 2014 15:14:15 +0200
Message-ID: <CAKMK7uEqfLudZbj1ArKJVXET69d+g+SA3=GtXQ0zXi+FeudAag@mail.gmail.com>
Subject: Re: Usage of _PAGE_PCD et al in i915 driver
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Juergen Gross <jgross@suse.com>
Cc: Ben Widawsky <benjamin.widawsky@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Barnes, Jesse" <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding relevant mailing lists.

On Fri, Aug 8, 2014 at 1:23 PM, Juergen Gross <jgross@suse.com> wrote:
> I'm just about to create a patch for full PAT support in the Linux
> kernel, including Xen. For this purpose I introduce a translation
> between cache modes and pte bits.
>
> Scanning the kernel sources for usage of the cache mode bits in the
> pte I discovered  drivers/gpu/drm/i915/i915_gem_gtt.h is using
> _PAGE_PCD, _PAGE_PWT and _PAGE_PAT. I think those defines are used
> to create ptes not for usage by the main processor, but for the
> graphics processor. Is this true? In this case I'd suggest to define
> i915-specific macros instead of using the x86 ones.

Yeah, those are gpu specific PAT tables, but the hw engineers
specifically designed this to match, and we've tried to follow the cpu
side to match it. Especially in the future that will be somewhat
important, since we want to fully share the entire address space
between cpu and gpu on the next platform. Jesse is working on that.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
