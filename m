Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaIQIjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:39:43 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39171 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaIQIjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:39:40 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.61.81]
In-Reply-To: <CAD=FV=VsSg5QLbdhgb4vV1+boeWaksCGj4MfGnCQnyhQR6Dr5A@mail.gmail.com>
References: <1409216559-22402-1-git-send-email-cw00.choi@samsung.com>
	<1409216559-22402-5-git-send-email-cw00.choi@samsung.com>
	<CABxcv=ku9fjFfzyXZEnCGpTrWQ0pN+5mLWay90jXBhkFeWb7sg@mail.gmail.com>
	<CAD8Lp47M8jHLrQAdYUn6NZn2Ety_02E6HPzPDUX3uGLVqf1riw@mail.gmail.com>
	<CABxcv==CBbaY_GVgmWe5QzJdhMipyx5TpZ4_3oKLzkyiGPOBrw@mail.gmail.com>
	<CAD=FV=VsSg5QLbdhgb4vV1+boeWaksCGj4MfGnCQnyhQR6Dr5A@mail.gmail.com>
Date: Wed, 17 Sep 2014 10:39:39 +0200
Message-ID: <CABxcv=m2XbqDTskHD0U3h+o7kXH51KVySs7tVBGpyozLmzUqkw@mail.gmail.com>
Subject: Re: [PATCHv3 4/5] rtc: s3c: Add support for RTC of Exynos3250 SoC
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Daniel Drake <drake@endlessm.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, rtc-linux@googlegroups.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On Wed, Sep 17, 2014 at 12:15 AM, Doug Anderson <dianders@chromium.org> wrote:
>
> I think you can turn off CONFIG_COMMON_CLK_MAX77686 and then this
> clock will be left at whatever the bootloader set it to, right?  Then
> there will be no auto-disabling by the CCF and the RTC will work.

Yes, that's how Daniel was working around the issue.

> That's one argument for making the clock "optional".
>

Indeed.

> NOTE: I don't think that the builtin RTC is terribly important for any
> exynos-based Chromebooks that I'm aware of.  We rely on the RTC that's
> part of the Maxim PMIC itself and pretty much ignore the one built-in
> to the exynos.  I think there are some cases it was used (as a
> fallback wakeup source in certain test scripts), but nothing very
> important.
>

Ok, I'll post the patch I shared before that makes the rtc to claim
the max77802 32kHz clock as "rtc_src" anyways since that is the right
thing to do even if the "rtc_src" ends being optional due DT backward
compat.

> -Doug

Best regards,
Javier
