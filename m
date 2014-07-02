Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaGBMmC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:42:02 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45513 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaGBMl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:41:59 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-f5-53b3fe1504b6
Message-id: <53B3FE12.3000608@samsung.com>
Date: Wed, 02 Jul 2014 14:41:54 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Tomasz Figa <t.figa@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?VG9tYXN6IFN0YW5pc8WCYXdza2k=?= <t.stanislaws@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Andrzej Hajda <a.hajda@samsung.com>,
        Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: ABBA deadlock in Common Clock Framework
References: <53B3E5F8.80501@samsung.com>
 <20140702114924.GC3679@tbergstrom-lnx.Nvidia.com>
In-reply-to: <20140702114924.GC3679@tbergstrom-lnx.Nvidia.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t/xK7qi/zYHGzTfEbG4te4cq8XUh0/Y
	LO5/PcposenxNVaLy7vmsFnMOL+PyeLphItsFpPWTmW0WD/jNYvFvPaXrBYrT8xiduD22LSq
	k83jzrU9bB6bl9R79Da/Y/Po27KK0ePkqScsHp83yQWwR3HZpKTmZJalFunbJXBl/Hk8n7Vg
	FkvF8x2/WBsYtzB3MXJySAiYSJw8eBXKFpO4cG89WxcjF4eQwFJGiT97mxghnE+MEv1Nrewg
	VbwCWhIPDs4F62ARUJX43D4JzGYTMJToPdrHCGKLCkRIHOh7xgpRLyjxY/I9FhBbRCBEovV2
	LzvIUGaBO8wSu5ZfAWsWBjpj9aNtQDYH0LYYiXfNCiBhTgE7ies3u8FmMguoS0yat4gZwpaX
	2LzmLfMERoFZSFbMQlI2C0nZAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghEfJ1B+PS
	Y1aHGAU4GJV4eF/obwoWYk0sK67MPcQowcGsJMLbf2NzsBBvSmJlVWpRfnxRaU5q8SFGJg5O
	qQZGqQn9H/5ePcEg9Pc0a96OlaqfWrSeFDLen2YesiXsx6IZy4OUEoSkHPbHPz6hLp2+4cq8
	0HXOSeIdpr9XV+xVal7wtGNf0yeJ6i8nmbt3BaXWWT2qfKr1dfW9XZbsrT3Gapf33W9kzlof
	v5LDRIm/4e2jw0Fzv/240RajyFF9z9k3wUcu0lBbiaU4I9FQi7moOBEAFTb7B24CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/14 13:49, Peter De Schrijver wrote:
> Or if you use notifiers which use i2c... See also
> http://comments.gmane.org/gmane.linux.kernel/1553699. One workaround is to
> always leave the clock of the i2c controller in a prepared state.

Keeping the clock always prepared might not be that bad, given
prepare/unprepare ops are empty on Exynos and I'd say chances
this ever changes are very low. Now we have just an overhead
of calling to the clock core before and after each single I2C
transfer.

--
Regards,
Sylwester
