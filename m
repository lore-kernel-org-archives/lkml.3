Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428Ab3ECQIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:08:54 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:50585 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289Ab3ECQIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:08:52 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130503143951.GB8320@zod.gha.chartermi.net>
References: <alpine.DEB.2.00.1305030224580.12778@skynet.skynet.ie>
	<20130503143951.GB8320@zod.gha.chartermi.net>
Date: Fri, 3 May 2013 18:08:52 +0200
Message-ID: <CAKMK7uF46a87KDg=n-rLhq2kjuPCpexHGwfR9UcPc_smZjqQzg@mail.gmail.com>
Subject: Re: [git pull] drm for 3.10-rc1
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 4:39 PM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Fri, May 03, 2013 at 02:25:57AM +0100, Dave Airlie wrote:
>>The following changes since commit b6a9b7f6b1f21735a7456d534dc0e68e61359d2c:
>>
>>  mm: prevent mmap_cache race in find_vma() (2013-04-04 11:46:28 -0700)
>>
>>are available in the git repository at:
>>
>>  git://people.freedesktop.org/~airlied/linux.git drm-next
>>
>>for you to fetch changes up to 307b9c022720f9de90d58e51743e01e9a42aec59:
>>
>>  qxl: update to new idr interfaces. (2013-05-03 10:37:20 +1000)
>>
>>----------------------------------------------------------------
>
> So something in this batch of commits breaks a Macbook Pro Retina I have
> sitting here.  If I boot a Fedora kernel based on  Linux
> v3.9-8153-g5a148af, things boot up as they did previously with 3.9.0 and
> are generally working fine.  If I boot with a kernel based on Linux
> v3.9-8933-gce85722, it will boot but as soon as plymouth starts, I get
> nothing but static on the screen (like 1950s TV static).
>
> This machine is using i915 graphics, so I booted with nomodeset and did
> the 'modprobe drm debug=15; modprobe i915 modeset=1' trick and it
> repeated the failure with that.  I've gathered a bunch of data like
> dmesg, an intel_reg_snapshot, etc.  It's all attached below.
>
> I'll start bisecting to see if I can narrow down the commit that broke
> things, but I thought I would give a heads up now in case anyone has any
> ideas.

Looked through the log files and didn't see a clue. And usually DP
tends to fail pretty noisily. So I think the bisect result would be
interestin. Meanwhile:
- do you have drm.debug=0xe dmesg for a working kernel, too?
- is the panel completely dead or is just the backlight on (or panel
on but backlight off)?

Thanks, Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
