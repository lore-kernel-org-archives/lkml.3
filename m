Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbaA2KIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 05:08:23 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57120 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaA2KIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 05:08:21 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-5b-52e8d312be91
Message-id: <1390990097.2207.2.camel@AMDC1943>
Subject: Re: [PATCH 05/18] mfd: max14577: Use of_match_ptr() in i2c_driver
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Date: Wed, 29 Jan 2014 11:08:17 +0100
In-reply-to: <1390911522-28209-6-git-send-email-k.kozlowski@samsung.com>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-6-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xq7pCl18EGZyfp24x9eETNovrX56z
	WpxtesNucf/rUUaLb1c6mCw2Pb7GanF51xw2i7VH7rJb3G5cwWZxupvVgctj56y77B6bVnWy
	edy5tofNY97JQI/NS+o9+rasYvT4vEkugD2KyyYlNSezLLVI3y6BK2PS7OXMBf2cFQ2Nh1kb
	GA+ydzFyckgImEgcvdLGCmGLSVy4t54NxBYSWMoocfCufhcjF5D9mVHiccMHJpAEr4CeRP+Z
	7WC2sICXxKP2yWANbALGEpuXLwGzRQTcJP6tO8QG0swssJ9J4tinTywgCRYBVYl7p9YydjFy
	cHAKeEi8/eABsayVUaJ7UjKIzSygLjFp3iJmiIOUJHa3d7JDxOUlNq95ywxxg6DEj8n3WCYw
	CsxC0jILSdksJGULGJlXMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoRExNcdjEuPWR1iFOBg
	VOLh3XDjeZAQa2JZcWXuIUYJDmYlEd7Vp18ECfGmJFZWpRblxxeV5qQWH2Jk4uCUamCc+nrR
	3hjzsOvR2uvyDkzy+iO4V5ZnLcPBwsbuf0fvpxlNe/2v05lt05wpMdWS+p3TT3mY7M9n3i9v
	3a/Gqns8tl2ip/ok8+6/SzZlVLy431nH2HTqpVXS1MOnVXrkvuznkbjCFKZ0Pv7po8TW5SGv
	Nkaf9svO2+cQFsfWePa4kpXrt6QHa48psRRnJBpqMRcVJwIA3QNKQ2YCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to drop this patch.

It does not make sense as "max14577_dt_match" is always compiled and
of_match_ptr was removed on purpose by Sachin Kamat (ae679c12e8; mfd:
max14577: Remove redundant of_match_ptr helper).

Best regards,
Krzysztof Kozlowski


On Tue, 2014-01-28 at 13:18 +0100, Krzysztof Kozlowski wrote:
> Use of_match_ptr() in assignment of i2c_driver.of_match_table.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/mfd/max14577.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> index 2ac2f2d7cea6..75b37082a3fe 100644
> --- a/drivers/mfd/max14577.c
> +++ b/drivers/mfd/max14577.c
> @@ -224,7 +224,7 @@ static struct i2c_driver max14577_i2c_driver = {
>  		.name = "max14577",
>  		.owner = THIS_MODULE,
>  		.pm = &max14577_pm,
> -		.of_match_table = max14577_dt_match,
> +		.of_match_table = of_match_ptr(max14577_dt_match),
>  	},
>  	.probe = max14577_i2c_probe,
>  	.remove = max14577_i2c_remove,

