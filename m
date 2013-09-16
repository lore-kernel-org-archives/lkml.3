Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab3IPJdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 05:33:21 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:49855 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667Ab3IPJdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 05:33:20 -0400
From: Denis CIOCCA <denis.ciocca@st.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jonathan Cameron <jic23@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Date: Mon, 16 Sep 2013 11:32:45 +0200
Subject: Re: [PATCH 38/38] iio: magn-core: st: Provide support for the
 LSM303DLH
Thread-Topic: [PATCH 38/38] iio: magn-core: st: Provide support for the
 LSM303DLH
Thread-Index: Ac6yv7T2FR4onOtjRLOcxSdZfoJ2Zg==
Message-ID: <5236D03D.2030506@st.com>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-39-git-send-email-lee.jones@linaro.org>
 <5234A28D.1030409@kernel.org> <20130916073151.GB3999@lee--X1>
In-Reply-To: <20130916073151.GB3999@lee--X1>
Accept-Language: it-IT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
acceptlanguage: it-IT, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8G9XPiF003072

Hi Lee,
> index 12e7e79..b2e2917 100644
> --- a/drivers/iio/magnetometer/st_magn_core.c
> +++ b/drivers/iio/magnetometer/st_magn_core.c
> @@ -151,7 +151,8 @@ static const struct st_sensors st_magn_sensors[] = {
>   		.wai = ST_MAGN_1_WAI_EXP,
>   		.sensors_supported = {
>   			[0] = LSM303DLHC_MAGN_DEV_NAME,
> -			[1] = LSM303DLM_MAGN_DEV_NAME,
> +			[1] = LSM303DLH_MAGN_DEV_NAME,
> +			[0] = LSM303DLM_MAGN_DEV_NAME,
Are you sure that it works?
Because LSM303DLH magnetometer use different kind of WAI registers. This 
driver read 0x0f and in this case the value is 0 and the driver do not 
probe...You have to read the identification registers (0x0a, 0x0b, 0x0c) 
in that case.

Denisÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
