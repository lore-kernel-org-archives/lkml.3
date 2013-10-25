Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3JYPmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:42:10 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:51871 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3JYPmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:42:07 -0400
MIME-Version: 1.0
In-Reply-To: <1381814135-16252-1-git-send-email-ch.naveen@samsung.com>
References: <1381479821-17276-1-git-send-email-ch.naveen@samsung.com>
	<1381814135-16252-1-git-send-email-ch.naveen@samsung.com>
Date: Fri, 25 Oct 2013 08:42:05 -0700
X-Google-Sender-Auth: ueQkGjXtzJXRhvl-zkWGf9q_KR0
Message-ID: <CAD=FV=XgpivoeAPfh+_G_bmbsdmADK73C9wdMALTr7+wt-AR=g@mail.gmail.com>
Subject: Re: [PATCH v4] iio: exynos_adc: use wait_for_completion_timeout
 instead of interruptible
From: Doug Anderson <dianders@chromium.org>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Grant Grundler <grundler@chromium.org>
Cc: linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, "cpgs ." <cpgs@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen,

On Mon, Oct 14, 2013 at 10:15 PM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> This patch does the following
> 1. The irq routine is so simple (just one register read) shouldn't be long
>    Hence, reduce the timeout to 100milli secs,
> 2. With 100ms of wait time, interruptible is very much unnecessary.
>    Hence, use wait_for_completion_timeout instead of
>    wait_for_completion_interruptible_timeout
> 3. Reset software if a timeout happens.
> 4. Add INIT_COMPLETION before the wait_for_completion_timeout in raw_read()
>
> Note: submitted for review at https://patchwork.kernel.org/patch/2279591/
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Cc: Doug Anderson <dianders@chromium.org>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> ---
> Changes since v1:
> As per discussion at
> http://marc.info/?l=linux-kernel&m=136517637228869&w=3
>
> Changes since v2:
> None.
> Rebased and reposting.
>
> Changes since v3:
> 1. commit message change and
> 2. removed an unncessary assignment
>
>  drivers/iio/adc/exynos_adc.c |   69 +++++++++++++++++++++++-------------------
>  1 file changed, 38 insertions(+), 31 deletions(-)

Please spin to match the changes that Grant requested on our gerrit at
<https://chromium-review.googlesource.com/172724>.  Thanks!  :)

-Doug
