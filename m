Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab3AQCEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:04:43 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:32785 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758223Ab3AQCEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:04:41 -0500
MIME-Version: 1.0
In-Reply-To: <1358387389.17958.1.camel@phoenix>
References: <1358387389.17958.1.camel@phoenix>
Date: Wed, 16 Jan 2013 23:58:38 -0200
Message-ID: <CACnwZYfV=czMR=FLwQseubK-G8GnuiVW_wsnFKTnw=rHrZ8dgg@mail.gmail.com>
Subject: Re: [PATCH] rtc: hid-sensor-time: Add missing spin_lock_init
From: Thiago Farina <tfransosi@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexander Holler <holler@ahsoftware.de>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 11:49 PM, Axel Lin <axel.lin@ingics.com> wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/rtc/rtc-hid-sensor-time.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
> index 0438c9e..31c5728 100644
> --- a/drivers/rtc/rtc-hid-sensor-time.c
> +++ b/drivers/rtc/rtc-hid-sensor-time.c
> @@ -225,6 +225,7 @@ static int hid_time_probe(struct platform_device *pdev)
>
>         platform_set_drvdata(pdev, time_state);
>
> +       spin_lock_init(&time_state->lock_last_time);
Can you explain in the commit message why it is missing?

For people not familiar with this code that isn't obvious.
