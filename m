Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183Ab3LKGTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 01:19:55 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7841 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750719Ab3LKGTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 01:19:51 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Neil Zhang <zhangwm@marvell.com>, "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 10 Dec 2013 22:19:46 -0800
Subject: RE: [PATCH] usb: phy: Initilize the spinlock in notifier
Thread-Topic: [PATCH] usb: phy: Initilize the spinlock in notifier
Thread-Index: Ac72Lo5/oypBXKN5TCeoIJ67NM5Y0QACkCog
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE4F8E31608A@SC-VEXCH4.marvell.com>
References: <1386738308-19773-1-git-send-email-zhangwm@marvell.com>
In-Reply-To: <1386738308-19773-1-git-send-email-zhangwm@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2013-12-11_02:2013-12-10,2013-12-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1312100266
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBB6K0eq022609


> -----Original Message-----
> From: Neil Zhang [mailto:zhangwm@marvell.com]
> Sent: 2013Äê12ÔÂ11ÈÕ 13:05
> To: balbi@ti.com; gregkh@linuxfoundation.org
> Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Neil Zhang
> Subject: [PATCH] usb: phy: Initilize the spinlock in notifier
> 
> We need to initilize every spinlock before use it.
> So lets initilize the spinlock in notifier when add a new phy device.
> 
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  drivers/usb/phy/phy.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c index
> 1b74523..479ceb8 100644
> --- a/drivers/usb/phy/phy.c
> +++ b/drivers/usb/phy/phy.c
> @@ -367,6 +367,8 @@ int usb_add_phy_dev(struct usb_phy *x)
>  		return -EINVAL;
>  	}
> 
> +	spin_lock_init(&x->notifier.lock);
> +
>  	spin_lock_irqsave(&phy_lock, flags);
>  	list_for_each_entry(phy_bind, &phy_bind_list, list)
>  		if (!(strcmp(phy_bind->phy_dev_name, dev_name(x->dev))))
> --
> 1.7.9.5

Please ignore this patch and check another one.
Sorry for this noise.

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
