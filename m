Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab3H2RfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:35:18 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4629 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab3H2RfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:35:16 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Sherman Yin" <syin@broadcom.com>
To: "Linus Walleij" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
cc: "Stephen Warren" <swarren@nvidia.com>,
        "Maxime Ripard" <maxime.ripard@free-electrons.com>
Subject: RE: [PATCH] pinctrl: sunxi: drop lock on error path
Thread-Topic: [PATCH] pinctrl: sunxi: drop lock on error path
Thread-Index: AQHOpNwoQQMJ8qDPuEiABiBsb7Xy2pmsccCQ
Date: Thu, 29 Aug 2013 17:35:08 +0000
Message-ID: <051069C10411E24D9749790C498526FA1BDE04FD@SJEXCHMB12.corp.ad.broadcom.com>
References: <1377796784-31147-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1377796784-31147-1-git-send-email-linus.walleij@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E015C6F2L879476703-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>@@ -291,8 +291,10 @@ static int sunxi_pconf_group_set(struct pinctrl_dev
>*pctldev,
> 		switch (pinconf_to_config_param(configs[i])) {
> 		case PIN_CONFIG_DRIVE_STRENGTH:
> 			strength = pinconf_to_config_argument(configs[i]);
>-			if (strength > 40)
>+			if (strength > 40) {
>+				spin_unlock_irqrestore(&pctl->lock, flags);
> 				return -EINVAL;
>+			}
> 			/*
> 			 * We convert from mA to what the register expects:
> 			 *   0: 10mA

Looks good.

Regards,
Sherman

