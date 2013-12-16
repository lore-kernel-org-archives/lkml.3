Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab3LPHIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 02:08:40 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17972 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3LPHIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 02:08:38 -0500
X-AuditID: cbfec7f4-b7fc96d000006cd4-fa-52aea6f4ecdb
Message-id: <1387177714.4280.2.camel@AMDC1943>
Subject: Re: linux-next: build failure after merge of the final tree
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Date: Mon, 16 Dec 2013 08:08:34 +0100
In-reply-to: <20131216164721.79bfe996919a8ec3576867c7@canb.auug.org.au>
References: <20131216164721.79bfe996919a8ec3576867c7@canb.auug.org.au>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xy7pflq0LMli6iN1izvo1bBabrl9n
	tTjb9Ibd4vKuOWwWBxe2MVps3XuV3eJR31t2B3aPxhs32DzuXNvD5nFixm8Wj74tqxg9Pm+S
	C2CN4rJJSc3JLEst0rdL4MpYd+4Ee8EJvooJjzeyNDBe5+5i5OSQEDCR+PXpDROELSZx4d56
	ti5GLg4hgaWMEssnrGKCcD4zSpzb2MIKUsUroCfRt3w5C4gtLOAiceHfC0YQm03AWGLz8iVA
	3RwcIgLaEgd+C4D0Mgs8YJS4u+U7WD2LgKrErZ8r2EFsTgF3iS0dN9lAbCEBN4nTL/6D2cwC
	6hKT5i1ihrhISWJ3eyc7RFxeYvOat8wQNwhK/Jh8j2UCo8AsJC2zkJTNQlK2gJF5FaNoamly
	QXFSeq6hXnFibnFpXrpecn7uJkZImH/Zwbj4mNUhRgEORiUeXgXLdUFCrIllxZW5hxglOJiV
	RHhjrq4NEuJNSaysSi3Kjy8qzUktPsTIxMEp1cCoGbxXa59YS3hX/Ie5mdJShwW+vz6ceZtb
	8tbM66+PeJTY3d9xquPA56D9Zk5HtuQE/g96EXv20EupycaerzxLdkyPqLqb8PBwyJrq2Y4m
	K5k9DU3sNCyUa3eVbnERT578eLd0qX8Hn9zLwNSta3PzhV1vLzY28EiLWBnA9nHWfcVz7QuU
	ZkgosRRnJBpqMRcVJwIAH+HFHVECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I sent a fix for this already on last Wednesday but I forgot to put you
on as recipient.
http://thread.gmane.org/gmane.linux.kernel/1612360
Fix is needed also for clock driver and on Saturday Rashika Kheria
posted similar patch.

Best regards,
Krzysztof


On Mon, 2013-12-16 at 16:47 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/regulator/s2mps11.c: In function 's2mps11_pmic_probe':
> drivers/regulator/s2mps11.c:441:23: error: 'struct sec_pmic_dev' has no member named 'regmap'
>   config.regmap = iodev->regmap;
>                        ^
> 
> Caused by commit 3e1e4a5f3a32 ("mfd/rtc: s5m: fix register updating by
> adding regmap for RTC") from Linus' tree.  Grep is your friend ...
> 
> I have added the following fix patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 16 Dec 2013 16:43:02 +1100
> Subject: [PATCH] mfd/rtc: fix for previous RTC fix
> 
> This updates drivers/regulator/s2mps11.c for the changes in commit
> 3e1e4a5f3a32 ("mfd/rtc: s5m: fix register updating by adding regmap
> for RTC").
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/regulator/s2mps11.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
> index 333677d68d0e..9e61922d8230 100644
> --- a/drivers/regulator/s2mps11.c
> +++ b/drivers/regulator/s2mps11.c
> @@ -438,7 +438,7 @@ common_reg:
>  	platform_set_drvdata(pdev, s2mps11);
>  
>  	config.dev = &pdev->dev;
> -	config.regmap = iodev->regmap;
> +	config.regmap = iodev->regmap_pmic;
>  	config.driver_data = s2mps11;
>  	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++) {
>  		if (!reg_np) {
> -- 
> 1.8.5.1
> 

