Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab3BDIDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:03:16 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:48849 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3BDIDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:03:15 -0500
MIME-Version: 1.0
In-Reply-To: <006201ce02a2$9ae72480$d0b56d80$@samsung.com>
References: <1357733199-17206-4-git-send-email-a.kesavan@samsung.com>
	<1358515490-7565-1-git-send-email-a.kesavan@samsung.com>
	<CAM4voakyRiC6nvNv63nK3H3T168MjP-JevbCuksoKbpT=HQqJw@mail.gmail.com>
	<006201ce02a2$9ae72480$d0b56d80$@samsung.com>
Date: Mon, 4 Feb 2013 13:33:13 +0530
Message-ID: <CAM4voa=rzE3Z16Jx465CHt-3JVe8CBSefBJdX4X8Yu-8urZo7Q@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] PM: Devfreq: Add Exynos5-bus devfreq driver for Exynos5250
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: "myungjoo.ham" <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kgene.kim@samsung.com, kyungmin.park@samsung.com, rjw@sisk.pl,
        jhbird.choi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Sorry for being late.
>
> One concern is that I cannot apply Patch 1/4 directly as the .dts file isn't
> available to me.
> Do you intend to apply that patch to another tree and apply the other three
> to devfreq tree?
I have been merging the devfreq tree into Kgene's tree for my testing. I am not
sure how this should get in, any suggestions ?
>
> Another is the location of exynos_ppmu.h.
> Who is going to refer exynos_ppmu.h?
> If Exynos devfreq drivers are the only files to refer, wouldn't it be better
> located at drivers/devfreq/exynos/ ?
>
> Or do you intend to let someone else (drivers located not in
> drivers/devfreq) access exynos-ppmu?
> (If so, who's going to be? and that means we are going to have
> include/linux/devfreq/, I don't think it'd be appropriate to populate
> include/linux with device driver specific headers)
In an earlier comment on this patch Olof suggested I place it in
include/linux/. It is going to be
used only by Exynos and I will move it into drivers/devfreq/exynos as
per your suggestion.
>
>
>
> And, there are errors (we do not have __devinit/__devexit anymore):
>
>   CC      drivers/devfreq/exynos/exynos5_bus.o
> drivers/devfreq/exynos/exynos5_bus.c:315:18: error: expected =, ,, ;, asm or
> __attribute__ before int
> drivers/devfreq/exynos/exynos5_bus.c:430:18: error: expected =, ,, ;, asm or
> __attribute__ before int
> drivers/devfreq/exynos/exynos5_bus.c:462:11: error:
> exynos5_busfreq_int_probe undeclared here (not in a function)
> drivers/devfreq/exynos/exynos5_bus.c:463:2: error: implicit declaration of
> function __devexit_p [-Werror=implicit-function-declaration]
> drivers/devfreq/exynos/exynos5_bus.c:463:24: error:
> exynos5_busfreq_int_remove undeclared here (not in a function)
> drivers/devfreq/exynos/exynos5_bus.c:235:35: warning:
> exynos5_devfreq_int_profile defined but not used [-Wunused-variable]
> drivers/devfreq/exynos/exynos5_bus.c:243:12: warning:
> exynos5250_init_int_tables defined but not used [-Wunused-function]
> drivers/devfreq/exynos/exynos5_bus.c:259:12: warning:
> exynos5_busfreq_int_pm_notifier_event defined but not used
> [-Wunused-function]
> cc1: some warnings being treated as errors
I will fix these and re-post.
>
>
>
> Cheers,
> MyungJoo.
>
Abhilash
