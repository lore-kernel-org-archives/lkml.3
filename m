Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbaCSIlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:41:21 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60848 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbaCSIlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:41:18 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-3e-5329582ae192
Message-id: <1395218473.18730.6.camel@AMDC1943>
Subject: Re: [PATCH] mfd: sec-core: Fix uninitialized 'regmap_rtc' on S2MPA01
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 19 Mar 2014 09:41:13 +0100
In-reply-to: <CAK9yfHwNmN+M8ncSGjUwnfXs1p-e7pCy5Y-K7uX6JV5JyWYhEg@mail.gmail.com>
References: <20140318110947.GR25478@lee--X1>
 <1395148286-32002-1-git-send-email-k.kozlowski@samsung.com>
 <CAK9yfHwNmN+M8ncSGjUwnfXs1p-e7pCy5Y-K7uX6JV5JyWYhEg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t/xy7paEZrBBos7zS2mPnzCZjH/yDlW
	i/tfjzJaXN41h83i5J9eRgdWj02rOtk87lzbw+bxeZNcAHMUl01Kak5mWWqRvl0CV0bHos8s
	BSs4Kh4+W8/UwPiCrYuRk0NCwESi++UVKFtM4sK99UA2F4eQwFJGiUl72qCcz4wSk982MIJU
	8QroSyzee5IFxBYW8JVY1DoJzGYTMJbYvHwJ2CQRAS2Jl93LmUBsZoGVjBIXevRAbBYBVYkv
	Z5cwg9icAsESE94fBLOFBDYySpydmgNRry4xad4iZoiLlCR2t3eyQ8TlJTavecsMcYOgxI/J
	91gmMArMQtIyC0nZLCRlCxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEhO/XHYxLj1kd
	YhTgYFTi4ZWI1QgWYk0sK67MPcQowcGsJMIrfBcoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgTHq
	TXuUyg+ZHy8EirQiF7oGbllvWLi3fu3PexuambcGL/UMe+P05MVp29ccAl+SZfNeiunM+pv8
	Z4WtVXLJHKNrq374LRYVvNPBPttjS2gQW9REmfyvSeXSrNtzX77wvf3R00VB7bB36q2N7JWL
	qkOE/vLdydkm8GSe73nWZadS/l+afND+3nslluKMREMt5qLiRACwGtm6PQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 13:57 +0530, Sachin Kamat wrote:
> On 18 March 2014 18:41, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> > Initialize the 'regmap_rtc' on S2MPA01 to some sane value. Sane at least
> > for S5M87X chipsets, not S2MPS/S2MPA but it won't be used because
> > rtc-s5m driver does not support S2MPA01.
> >
> > This fixes following error:
> > drivers/mfd/sec-core.c:342:45: warning: 'regmap_rtc' may be used uninitialized in this function [-Wuninitialized]
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> From the point of suppressing this warning and considering how it is
> done for S2MPS11,
> Acked-by: Sachin Kamat <sachin.kamat@linaro.org>
> 
> However, shouldn't we be making this RTC handling conditional/optional
> depending upon
> whether the h/w or s/w supports/implements it?

I think the rtc-s5m driver should instantiate his regmap on its own. The
same with i2c dummy device. This would remove problems with unsupported
chipsets by rtc-s5m driver.


Best regards,
Krzysztof

