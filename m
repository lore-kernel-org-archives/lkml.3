Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab3KJMsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 07:48:40 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:61852 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab3KJMsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 07:48:37 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, dianders@chromium.org,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, grundler@chromium.org, cpgs@samsung.com
Subject: Re: [PATCH v6] iio: exynos_adc: use wait_for_completion_timeout instead of interruptible
Date: Sun, 10 Nov 2013 13:48:35 +0100
Message-ID: <4523891.jQuDssBx5e@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1383644730-23228-1-git-send-email-ch.naveen@samsung.com>
References: <1381479821-17276-1-git-send-email-ch.naveen@samsung.com> <1383644730-23228-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On Tuesday 05 of November 2013 15:15:30 Naveen Krishna Chatradhi wrote:
> 1. The irq routine is so simple (just one register read) shouldn't be
> long Hence, reduce the timeout to 100milli secs,

I believe that the timeout value depends mostly on maximum conversion time 
and interrupt handler complexity is not very significant here.

> 2. With 100ms of wait time, interruptible is very much unnecessary.
>    Hence, use wait_for_completion_timeout instead of
>    wait_for_completion_interruptible_timeout
> 3. Reset software if a timeout happens.
> 4. Add reinit_completion() before the wait_for_completion_timeout in
> raw_read()

All the four points listed above, even just by the form they are written 
in, suggest that they should be separate four patches.

In addition, patch description should explain why such change is needed, 
i.e. what it fixes, improves or prepares the code for.

> Note: submitted for review at
> https://patchwork.kernel.org/patch/2279591/
> 

This should not be located in patch description, but rather in comments 
section below, as is the change log.

> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Cc: Doug Anderson <dianders@chromium.org>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Reviewed-on: https://chromium-review.googlesource.com/172724
> Reviewed-by: Doug Anderson <dianders@chromium.org>
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
> Changes since v4:
> Moved INIT_COMPLETION call to the starting of the function
> 
> Changes since v5:
> INIT_COMPLETION was replaced by reinit_completion
> ("tree-wide: use reinit_completion instead of INIT_COMPLETION").
> Use it to avoid the following build error:
> undefined identifier 'INIT_COMPLETION'

Not really a comment to the patch, but rather a suggestion for future:

It is more convenient to read the change log if it goes from newest to 
oldest order.

Otherwise the changes alone look good.

Best regards,
Tomasz

