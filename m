Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbaCSI1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:27:41 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:62448 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaCSI1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:27:36 -0400
MIME-Version: 1.0
In-Reply-To: <1395148286-32002-1-git-send-email-k.kozlowski@samsung.com>
References: <20140318110947.GR25478@lee--X1>
	<1395148286-32002-1-git-send-email-k.kozlowski@samsung.com>
Date: Wed, 19 Mar 2014 13:57:35 +0530
Message-ID: <CAK9yfHwNmN+M8ncSGjUwnfXs1p-e7pCy5Y-K7uX6JV5JyWYhEg@mail.gmail.com>
Subject: Re: [PATCH] mfd: sec-core: Fix uninitialized 'regmap_rtc' on S2MPA01
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 March 2014 18:41, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> Initialize the 'regmap_rtc' on S2MPA01 to some sane value. Sane at least
> for S5M87X chipsets, not S2MPS/S2MPA but it won't be used because
> rtc-s5m driver does not support S2MPA01.
>
> This fixes following error:
> drivers/mfd/sec-core.c:342:45: warning: 'regmap_rtc' may be used uninitialized in this function [-Wuninitialized]
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

>From the point of suppressing this warning and considering how it is
done for S2MPS11,
Acked-by: Sachin Kamat <sachin.kamat@linaro.org>

However, shouldn't we be making this RTC handling conditional/optional
depending upon
whether the h/w or s/w supports/implements it?

-- 
With warm regards,
Sachin
