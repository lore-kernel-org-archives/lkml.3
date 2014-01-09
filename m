Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbaAIJcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:32:16 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7338 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754170AbaAIJcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:32:11 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Neil Zhang <zhangwm@marvell.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 9 Jan 2014 01:32:07 -0800
Subject: RE: [PATCH] gpio: pxa: fix bug when get gpio value
Thread-Topic: [PATCH] gpio: pxa: fix bug when get gpio value
Thread-Index: Ac8NHM5x5HBTNy3OR+WUAB/vknaw4QAAK9ww
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE540BD53872@SC-VEXCH4.marvell.com>
References: <1389259557-1731-1-git-send-email-zhangwm@marvell.com>
In-Reply-To: <1389259557-1731-1-git-send-email-zhangwm@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-09_03:2014-01-07,2014-01-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1401090010
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s099WLPK032754


> -----Original Message-----
> From: Neil Zhang [mailto:zhangwm@marvell.com]
> Sent: 2014Äê1ÔÂ9ÈÕ 17:26
> To: linus.walleij@linaro.org; gnurou@gmail.com; linux-gpio@vger.kernel.org;
> linux-kernel@vger.kernel.or
> Cc: Neil Zhang
> Subject: [PATCH] gpio: pxa: fix bug when get gpio value
> 
> gpio_get_value should return 0 or 1.
> 
> I have checked mach-mmp / mach-pxa / plat-pxa / plat-orion / mach-orion5x.
> It's OK for all of them to change this function to return 0 and 1.
> 
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  drivers/gpio/gpio-pxa.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c index
> cc13d1b..42e6e64 100644
> --- a/drivers/gpio/gpio-pxa.c
> +++ b/drivers/gpio/gpio-pxa.c
> @@ -263,7 +263,8 @@ static int pxa_gpio_direction_output(struct gpio_chip
> *chip,
> 
>  static int pxa_gpio_get(struct gpio_chip *chip, unsigned offset)  {
> -	return readl_relaxed(gpio_chip_base(chip) + GPLR_OFFSET) & (1 <<
> offset);
> +	u32 gplr = readl_relaxed(gpio_chip_base(chip) + GPLR_OFFSET);
> +	return !!(gplr & (1 << offset));
>  }
> 
>  static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> --
> 1.7.9.5

Add right LKML.

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
