Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaDYQ2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:28:21 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:40528 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbaDYQ2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:28:14 -0400
MIME-Version: 1.0
In-Reply-To: <1398420888-5506-4-git-send-email-ch.naveen@samsung.com>
References: <1398420888-5506-1-git-send-email-ch.naveen@samsung.com>
	<1398420888-5506-4-git-send-email-ch.naveen@samsung.com>
Date: Fri, 25 Apr 2014 09:28:13 -0700
X-Google-Sender-Auth: MaDrFsUbV08P-XVs0UdIMulsOTY
Message-ID: <CAD=FV=Uds1i0dsuhFKXbNY6+kVRsFe0D0EQ3FATJnwjPGD3k0Q@mail.gmail.com>
Subject: Re: [PATCH 3/5] iio: exynos_adc: reduce timeout and use wait_for_completion_timeout
From: Doug Anderson <dianders@chromium.org>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, "cpgs ." <cpgs@samsung.com>,
        Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen,

On Fri, Apr 25, 2014 at 3:14 AM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> ADC module on Exynos5 SoCs runs at 600KSPS. At this conversion rate,
> waiting for 1000 msecs is wasteful (incase of h/w failure).
>
> Hence, reduce the time out to 100msecs and use
> wait_for_completion_timeout() instead of
> wait_for_completion_interruptible_timeout()
>
> Also, handle the return values in exynos_raw_read() call.

You probably didn't need to mention this--it's just a natural part of
changing from wait_for_completion_interruptible_timeout() to
wait_for_completion_timeout().

>
> Change-Id: Icb8cade162094b2777c9f3c77120635deef5947c

Please don't send upstream with Change-Id.  Have you considered patman
<http://git.denx.de/?p=u-boot.git;a=blob;f=tools/patman/README;hb=refs/heads/master>?

> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> This change is a part of the patch reviewd at https://lkml.org/lkml/2013/11/5/92
>
>  drivers/iio/adc/exynos_adc.c |   18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)

Other than problems above, this looks fine to me.  If you fix them,
feel free to add my Reviewed-by tag.

-Doug
