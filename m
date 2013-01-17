Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3AQMsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:48:53 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:53723 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab3AQMsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:48:52 -0500
Message-ID: <50F7F2F7.9010900@ahsoftware.de>
Date: Thu, 17 Jan 2013 13:47:51 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Jonathan Cameron <jic23@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: hid-sensor-time: Add missing spin_lock_init
References: <1358387389.17958.1.camel@phoenix>
In-Reply-To: <1358387389.17958.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.01.2013 02:49, schrieb Axel Lin:

Thanks, yes, I missed it the initialization of the spinlock.

Below is my ack.

Regards,

Alexander

> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Alexander Holler <holler@ahsoftware.de>

> ---
>   drivers/rtc/rtc-hid-sensor-time.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
> index 0438c9e..31c5728 100644
> --- a/drivers/rtc/rtc-hid-sensor-time.c
> +++ b/drivers/rtc/rtc-hid-sensor-time.c
> @@ -225,6 +225,7 @@ static int hid_time_probe(struct platform_device *pdev)
>
>   	platform_set_drvdata(pdev, time_state);
>
> +	spin_lock_init(&time_state->lock_last_time);
>   	init_completion(&time_state->comp_last_time);
>   	time_state->common_attributes.hsdev = hsdev;
>   	time_state->common_attributes.pdev = pdev;
>

