Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab3ATPm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 10:42:59 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:61734 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3ATPm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 10:42:58 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CAF6AEGsSEtpJNKgHpZsUM9aadxYfHV7BhjfS86q0SH5ZXYaZ3w@mail.gmail.com>
References: <CAF6AEGsSEtpJNKgHpZsUM9aadxYfHV7BhjfS86q0SH5ZXYaZ3w@mail.gmail.com>
Date: Sun, 20 Jan 2013 16:42:55 +0100
Message-ID: <CAKMK7uH29is7Ky5_w2eu5iic42+TJt+vLdQk=mqBfL77o-BhjA@mail.gmail.com>
Subject: Re: thoughts on requiring multi-arch support for arm drm drivers?
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Rob Clark <robdclark@gmail.com>
Cc: dri-devel@lists.freedesktop.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 4:08 PM, Rob Clark <robdclark@gmail.com> wrote:
> One thing I've run into in the past when trying to make changes in drm
> core, and Daniel Vetter has mentioned the same, is that it is a bit of
> a pain to compile test things for the arm drivers that do not support
> CONFIG_ARCH_MULTIPLATFORM.  I went through a while back and fixed up
> the low hanging fruit (basically the drivers that just needed a
> Kconfig change).  But, IIRC some of the backlight related code in
> shmob had some non-trivial plat dependencies.  And I think when tegra
> came in, it introduced some non-trivial plat dependencies.
>
> What do others think about requiring multiarch or no arch dependencies
> for new drivers, and cleaning up existing drivers.  Even if it is at
> reduced functionality (like maybe #ifdef CONFIG_ARCH_SHMOBILE for some
> of the backlight code in shmob) or doesn't even work but is just for
> the purpose of being able to compile test the rest of the code?
>
> Thoughts?

Definitely in favour of this. Also, I think the arm world _really_
needs something like Wu Fenggungs 0-day kernel testing/building
machines, which checks every commit pushed to around a 150 git kernel
maintainer repos with randconfigs, sparse (and iirc other static
checkers like cocinelle), and test-boots them on kvm. It's not just
that every driver seems to need it's own special defconfig/platform to
even be selectable in Kconfig, they also seem to randomly (and often)
break compilation if you're on the wrong tree or don't have the
exactly required golden config ...

I don't have any issues with compile-testing on different
architectures. But this kind of pain makes larger subsystem reworks
like the drm kms locking rework I've just done unnecessarily
cumbersome.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
