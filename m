Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877AbaCSMmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:42:06 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21987 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721AbaCSMmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:42:03 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f796d000005a13-b7-53299098455f
Content-transfer-encoding: 8BIT
Message-id: <1395232919.15174.7.camel@AMDC1943>
Subject: Re: [PATCH] mfd: sec-core: Fix uninitialized 'regmap_rtc' on S2MPA01
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, broonie@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 19 Mar 2014 13:41:59 +0100
In-reply-to: <20140319091404.GF31687@lee--X1>
References: <20140318110947.GR25478@lee--X1>
 <1395148286-32002-1-git-send-email-k.kozlowski@samsung.com>
 <20140319091404.GF31687@lee--X1>
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t/xK7ozJmgGG9zvULeY+vAJm8X8I+dY
	Le5/PcpocXnXHDaLk396GR1YPTat6mTzuHNtD5vH501yAcxRXDYpqTmZZalF+nYJXBmzrz1j
	KWjgrLi//TJbA+NU9i5GTg4JAROJi++es0LYYhIX7q1n62Lk4hASWMoo8Xl1J1iCV0BQ4sfk
	eyxdjBwczALyEkcuZYOEmQXUJSbNW8QMUf+ZUWLb1xYWiHp9iZ1Hp4LZwgK+EotaJ4HZbALG
	EpuXL2EDmSMioCJx7o05xMgqiRPbpUBMFgFViXfbPUCKOQV0JRbv3sYOMb2XUeJJw0aok5Uk
	drd3sk9gFJiF5LhZCMfNQnLcAkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghYftlB+Pi
	Y1aHGAU4GJV4eCVjNYKFWBPLiitzDzFKcDArifC29msGC/GmJFZWpRblxxeV5qQWH2Jk4uCU
	amB0Z/27KE5qkqxY4OE308SPrvjzQlJDy6MrY2c6r4jbpierKqIz9j4PrQmY4JfKZdG+plbE
	VrrmlP9svYCbBRMmHTv1sf97xYM5nSuYrk3dqjlzQmGU8cZtRRoy5opnOpK+CGj9qPrk7iu9
	850k828lr9OmL1c4ivqdfvWv9kL3X43W3et6Mu4osRRnJBpqMRcVJwIAI80uXzkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 09:14 +0000, Lee Jones wrote:
> > Initialize the 'regmap_rtc' on S2MPA01 to some sane value. Sane at least
> > for S5M87X chipsets, not S2MPS/S2MPA but it won't be used because
> > rtc-s5m driver does not support S2MPA01.
> > 
> > This fixes following error:
> > drivers/mfd/sec-core.c:342:45: warning: ‘regmap_rtc’ may be used uninitialized in this function [-Wuninitialized]
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/mfd/sec-core.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> 
> Please don't send patches in the middle of threads like this (v2's are
> a different story as it saves on re-sending entire patch-sets), as I
> very nearly missed it.

OK, I understand. I put it in the middle because it was a follow up of
your immutable branch ib-mfd-regulator-3.15 (merging mine S2MPS14 and
Sachin's S2MPA01).

> 
> We already have drivers doing similar things so I'll apply this as a
> temporary fix, but please find something a little less 'hacky' to
> supersede it _soon_.

Sure, I just sent a patch for it.

Best regards,
Krzysztof

