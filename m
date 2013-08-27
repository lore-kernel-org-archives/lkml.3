Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3H0R2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 13:28:04 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:64165 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab3H0R2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 13:28:03 -0400
Message-ID: <521CE19D.2000805@cogentembedded.com>
Date: Tue, 27 Aug 2013 21:27:57 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rupesh Gujare <rupesh.gujare@atmel.com>
CC: devel@linuxdriverproject.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH 4/4] staging: ozwpan: Return error, if PD is not connected.
References: <1377618823-12246-1-git-send-email-rupesh.gujare@atmel.com> <1377618823-12246-4-git-send-email-rupesh.gujare@atmel.com>
In-Reply-To: <1377618823-12246-4-git-send-email-rupesh.gujare@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/27/2013 07:53 PM, Rupesh Gujare wrote:

> Return error if we receive write(), while PD is not connected.

> Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
> ---
>   drivers/staging/ozwpan/ozcdev.c |    2 ++
>   1 file changed, 2 insertions(+)

> diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
> index 03b41ee..22cb2ae 100644
> --- a/drivers/staging/ozwpan/ozcdev.c
> +++ b/drivers/staging/ozwpan/ozcdev.c
> @@ -162,6 +162,8 @@ static ssize_t oz_cdev_write(struct file *filp, const char __user *buf,
>   	spin_unlock_bh(&g_cdev.lock);
>   	if (pd == NULL)
>   		return -1;

    Note that returning -EPERM here is hardly correct.

> +	if (!(pd->state & OZ_PD_S_CONNECTED))
> +		return -ENXIO;

WBR, Sergei

