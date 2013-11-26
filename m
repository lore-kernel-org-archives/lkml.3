Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3KZJRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 04:17:55 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9540 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3KZJRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 04:17:51 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfec7f4-b7fea6d0000026ac-98-5294673db3d1
Content-transfer-encoding: 8BIT
Message-id: <5294673B.4050608@samsung.com>
Date: Tue, 26 Nov 2013 10:17:47 +0100
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
Newsgroups: gmane.linux.kernel
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: s5m-rtc: Fix info->rtc assignment
References: <1384516479-31791-1-git-send-email-geert@linux-m68k.org>
In-reply-to: <1384516479-31791-1-git-send-email-geert@linux-m68k.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t/xq7q26VOCDPqeqVvMWb+GzeLZrb1M
	Fpd3zWGz2N/ZwWhx8k8vo8XFFV+YHNg89kw8yeZx59oeNo8TM36zeBw63MHo0bdlFaPH501y
	AWxRXDYpqTmZZalF+nYJXBkXP/WxF+xir7hw7g9TA+MUti5GTg4JAROJ2fvPsEPYYhIX7q0H
	inNxCAksZZRo/n+GFSTBKyAo8WPyPZYuRg4OZgF5iSOXskHCzAJmEo9a1jFD1H9mlJi47CQz
	RL2WxNujF8CGsgioSkz4+YQJxGYTMJbYvHwJ2GJRgQiJv/PWM4LYfAJyEhO3PgMbJCKwglHi
	Rtd5NogNNhILf0xnBVksLGAtce15PkhYSMBF4vLXNrBeTgFXidufnrNMYBScheTUWQinzkJy
	6gJG5lWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIaH/ZQfj4mNWhxgFOBiVeHgLuicHCbEm
	lhVX5h5ilOBgVhLhdb0PFOJNSaysSi3Kjy8qzUktPsTIxMEp1cDIMDm0PvdKoCuzVCz3Cenw
	qjSr+q932krSSm+u/tt+7k3l/u45psJnv67dkdawUOuh/5X0q4FTkrw5u+585lCY7jzR2MVV
	Z/tah08qftPktlQar3WS/HT0iFD97iNnXr3f6b9oz2PWNwIr8+SM7v1Y5bzwl+BZrV1XugwO
	T9Q8ZcYdGrHl9MIiJZbijERDLeai4kQAxWkMglsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 12:54 PM, Geert Uytterhoeven wrote:
> drivers/rtc/rtc-s5m.c: In function ‘s5m_rtc_probe’:
> drivers/rtc/rtc-s5m.c:545: warning: assignment from incompatible pointer type
>
> struct s5m_rtc_info.rtc has type "struct regmap *", while
> struct sec_pmic_dev.rtc has type "struct i2c_client *".
>
> Probably the author wanted to assign "struct sec_pmic_dev.regmap", which
> has the correct type.
>
> Also, as "rtc" doesn't make much sense as a name for a regmap, rename it to
> "regmap".
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> I would be really surprised if this driver didn't just crash...
> Please test. Thanks!
>
>   drivers/rtc/rtc-s5m.c |   54 ++++++++++++++++++++++++-------------------------
>   1 file changed, 27 insertions(+), 27 deletions(-)

Seems good, tested on device with S5M8767.

Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


