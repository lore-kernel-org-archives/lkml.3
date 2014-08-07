Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065AbaHGQs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:48:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8993 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaHGQs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:48:56 -0400
X-AuditID: cbfee61a-f79e46d00000134f-9c-53e3adf62620
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] mfd: sec-core: add missing sec_irq_init() return value
 checking
Date: Thu, 07 Aug 2014 18:48:52 +0200
Message-id: <2156078.GxeZgK3rLH@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <2486284.NeLpWWu75g@amdc1032>
References: <2486284.NeLpWWu75g@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jAd1vax8HG8z8aGXx+oWhxdmmN+wW
	978eZbS4vGsOm8WM8/uYLE53s1pcXPGFyYHd4861PWwe804GevRtWcXo8XmTXABLFJdNSmpO
	Zllqkb5dAlfGomWLmAv2c1a8+NXP3MD4gb2LkZNDQsBE4lXLUUYIW0ziwr31bF2MXBxCAosY
	JebfWMUC4bQwSbQc+MMCUsUmYCUxsX0VUAcHh4iAhsTenhqQGmaBl4wS3bP2MoHUCAuESfRt
	eApWzyKgKvH26hewOK+ApsTRLT/YQGxRAU+JHdtXgtmcAloSu3Y3gl0kBFRz9cJsZoh6QYkf
	k++BzWEWkJfYt38qK4StJbF+53GmCYwCs5CUzUJSNgtJ2QJG5lWMoqkFyQXFSem5hnrFibnF
	pXnpesn5uZsYwWH9TGoH48oGi0OMAhyMSjy8At2Pg4VYE8uKK3MPMUpwMCuJ8OqChHhTEiur
	Uovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5NLUgtgskycXBKNTAWTPXNEHm733H9lhMf
	+jMqfTYVFtj53s/wZXhouez3M62QLr7jM7sKOfXniTpEv77D92G6Z6/5QquHBwQlcrkjnFeI
	308R8wnKWvK9iGnuqconD3OfsIexm6o+U1uhO3/ambefOQ/s0rhR/6uSMeN4Wc3WlXu/vllT
	nt2+8n3dgTaZi8p/F0xXYinOSDTUYi4qTgQA/VjPfmcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added missing linux-samsung-soc ML, sorry for the noise ]

On Thursday, August 07, 2014 06:44:18 PM Bartlomiej Zolnierkiewicz wrote:
> sec_irq_init() can fail if it encounters unknown device type or
> on regmap_add_irq_chip() error.  Add missing sec_irq_init() return
> value checking to sec_pmic_probe().
> 
> Tested on Insignal's Exynos4412 based Origen board.
> 
> Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Sangbeom Kim <sbkim73@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> patch is against next-20140804 branch of linux-next kernel
> 
>  drivers/mfd/sec-core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index dba7e2b..f498867 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -353,7 +353,9 @@ static int sec_pmic_probe(struct i2c_client *i2c,
>  	if (pdata && pdata->cfg_pmic_irq)
>  		pdata->cfg_pmic_irq();
>  
> -	sec_irq_init(sec_pmic);
> +	ret = sec_irq_init(sec_pmic);
> +	if (ret)
> +		return ret;
>  
>  	pm_runtime_set_active(sec_pmic->dev);

