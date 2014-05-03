Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbaECGk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 02:40:56 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:44210 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaECGkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 02:40:55 -0400
Message-ID: <1399099252.4310.1.camel@violet>
Subject: Re: [PATCH] i2c: qup: Fix pm_runtime_get_sync usage
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Andy Gross <agross@codeaurora.org>
Cc: linux-i2c@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Date: Sat, 03 May 2014 09:40:52 +0300
In-Reply-To: <1399082069-6666-1-git-send-email-agross@codeaurora.org>
References: <1399082069-6666-1-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-02 at 20:54 -0500, Andy Gross wrote:
> This patch corrects the error check on the call to pm_runtime_get_sync.
> 
> Signed-off-by: Andy Gross <agross@codeaurora.org>


Reviewed-by: Ivan T. Ivanov <iivanov@mm-sol.com>

> ---
>  drivers/i2c/busses/i2c-qup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
> index 1b4cf14..2a5efb5 100644
> --- a/drivers/i2c/busses/i2c-qup.c
> +++ b/drivers/i2c/busses/i2c-qup.c
> @@ -479,7 +479,7 @@ static int qup_i2c_xfer(struct i2c_adapter *adap,
>  	int ret, idx;
>  
>  	ret = pm_runtime_get_sync(qup->dev);
> -	if (ret)
> +	if (ret < 0)
>  		goto out;
>  
>  	writel(1, qup->base + QUP_SW_RESET);


