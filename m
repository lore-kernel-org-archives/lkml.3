Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3BNIFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 03:05:48 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:40138 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab3BNIFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 03:05:47 -0500
X-AuditID: cbfec7f5-b7fd76d000007247-96-511c9ad8c292
Message-id: <511C9AD7.6000904@samsung.com>
Date: Thu, 14 Feb 2013 09:05:43 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107
 Thunderbird/17.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Chris Ball <cjb@laptop.org>, Kevin Liu <keyuan.liu@gmail.com>
Subject: Re: [PATCH 3/3 RESEND] mmc: sdhci: check voltage range only on
 regulators aware of voltage value
References: <87bobqrcb4.fsf@octavius.laptop.org>
 <1360656096-1671-1-git-send-email-m.szyprowski@samsung.com>
 <Pine.LNX.4.64.1302122309470.14434@axis700.grange>
 <511B41B8.3060506@samsung.com>
 <Pine.LNX.4.64.1302130844530.18535@axis700.grange>
 <20130213113525.GB5062@opensource.wolfsonmicro.com>
In-reply-to: <20130213113525.GB5062@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xq7o3ZskEGpy7omNxedccNosj//sZ
	HZg8Pm+SC2CM4rJJSc3JLEst0rdL4Mr4u2wTS8EfrooHu8+xNzD+5Ohi5OSQEDCRuLD8FSuE
	LSZx4d56ti5GLg4hgaWMEudfN7NCOM1MEhP23WEHqeIV0JK4/3YPM4jNIqAq8efQDzCbTcBQ
	outtFxuILSoQKrF23xpmiHpBiR+T77F0MXJwiABt+32/EmQms8A3RonX674wgdQIC2RLvLj9
	hRFi2XomiftfzoOdxCngINF44xjYIGYBM4lHLeugbHmJzWveMk9gFJiFZMcsJGWzkJQtYGRe
	xSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESjl93MC49ZnWIUYCDUYmH14BDJlCINbGsuDL3
	EKMEB7OSCO/LQKAQb0piZVVqUX58UWlOavEhRiYOTqkGxhNKSoE7v+e6H5Vaxruxo/n6Pra9
	sUVX35Qf3ZSnVm+24Om5iq//pyXpi7U2LlVWvBt0L2B2tN0Wvq7zNVu//H/9utLoA0/OnMb7
	tdMWaainXDYMWXAibc7ppgUT94R9rbh4Jzjzl807+U2fltXeKtcQdtqhwS9Tndlz8cn5xW6b
	Z56SPmBY8EGJpTgj0VCLuag4EQAG7GDvJQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2/13/2013 12:35 PM, Mark Brown wrote:
> On Wed, Feb 13, 2013 at 08:45:56AM +0100, Guennadi Liakhovetski wrote:
> > On Wed, 13 Feb 2013, Marek Szyprowski wrote:
>
> > > BTW, mmc_regulator_get_ocrmask() won't work with continuous range regulators.
>
> > This seems like a problem, that has to be fixed...
>
> Indeed, what's the issue?

There are probably 2 issues:

1. mmc_regulator_get_ocrmask() works only with regulators which support
regulator_count_voltages() and regulator_list_voltage(). Recently 
support for
continuous regulators have been merged. Such regulators doesn't provide
regulator_list_voltage() method, but are able to change/set voltage to the
given value. I agree that they are not very common, so right now we can
probably ignore them until the first board, which uses them arrives.

2. The second issue might be related to the testing of precise voltage 
values
in the ocr mask, not the whole allowed ranges. Such issues in sdhci.c 
driver
has been recently fixed by commit cec2e216f72c6b5ccdadb60aadbe99821d744503
("mmc: sdhci: Use regulator min/max voltage range according to spec"), but I
don't know MMC core code to judge if ocr mask is used for exact voltage
checking or only for checking the voltage ranges. However someone with good
mmc subsystem knowledge should check it.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


