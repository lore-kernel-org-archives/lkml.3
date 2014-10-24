Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbaJXNCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:02:43 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:58056 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375AbaJXNCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:02:40 -0400
Message-ID: <544A4DED.6090009@cogentembedded.com>
Date: Fri, 24 Oct 2014 17:02:37 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>, wsa@the-dreams.de,
        ludovic.desroches@atmel.com
CC: khilman@kernel.org, nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/3] i2c/at91: add support for system PM
References: <1414133417-11530-1-git-send-email-wenyou.yang@atmel.com> <1414133417-11530-3-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1414133417-11530-3-git-send-email-wenyou.yang@atmel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/24/2014 10:50 AM, Wenyou Yang wrote:

> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> ---
>   drivers/i2c/busses/i2c-at91.c |   26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)

> diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
> index a25fb5e..6a84a2a 100644
> --- a/drivers/i2c/busses/i2c-at91.c
> +++ b/drivers/i2c/busses/i2c-at91.c
> @@ -861,7 +861,33 @@ static int at91_twi_runtime_resume(struct device *dev)
[...]
> +static int at91_twi_resume_noirq(struct device *dev)
> +{
> +	int ret;
> +
> +	if (!pm_runtime_status_suspended(dev)) {
> +		ret = at91_twi_runtime_resume(dev);

    Resume if *not* suspended?

> +		if (ret)
> +			return ret;
> +	}
> +
> +	pm_runtime_mark_last_busy(dev);
> +	pm_request_autosuspend(dev);
> +
> +	return 0;
> +}
> +
[...]

WBR, Sergei

