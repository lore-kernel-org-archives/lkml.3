Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbaJ1IpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:45:23 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53551 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaJ1IpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:45:20 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-0b-544f579e58bf
Message-id: <1414485916.24949.15.camel@AMDC1943>
Subject: Re: [PATCH 1/8] regulator: max77802: Remove support for board files
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Tue, 28 Oct 2014 09:45:16 +0100
In-reply-to: <544E9EB2.2010408@collabora.co.uk>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
 <1414422226-10948-2-git-send-email-k.kozlowski@samsung.com>
 <544E9EB2.2010408@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e/4Zd154f4hBpuOclhsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6w6F1wlc3ibNMbdov7X48yWny70sFksenxNVaLy7vmsFnM
	OL+PyeL2ZV6LtUfusluc7mZ1EPBoae5h8/j7/DqLx99VL5g9ds66y+6xaVUnm8eda3vYPOad
	DPTYvKTeo2/LKkaPz5vkAriiuGxSUnMyy1KL9O0SuDJ+vmhlLLjJXbF2/WTGBsYDnF2MnBwS
	AiYSzS3dLBC2mMSFe+vZuhi5OIQEljJKfGg7COV8ZpTYNOUBI0gVr4CBxOTvR9lBbGEBH4mN
	XSfB4mwCxhKbly9hA7FFBOwkbqx+yAzSzCxwmEVi0YPrYAkWAVWJJQfbWEFsTgF9iRV/3zFC
	bFjFKHHz3SdmkASzgLrEpHmLgGwOoJuUJRr73SAWC0r8mHyPBaJEXmLzmrfMExgFZiHpmIWk
	bBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQmLtyw7GxcesDjEKcDAq8fDumOYb
	IsSaWFZcmXuIUYKDWUmEd7mKf4gQb0piZVVqUX58UWlOavEhRiYOTqkGxpygk0/6hS5LLpht
	57GtyeCCu//dUN61D13+PN67d8HKfZeEIpgY53lu+7Rgz7QHFtaX+CWffPz6ZwVL6Il+77v6
	idfERWfnPWLxdnBI3SUuu+edkM3Vm8utLkzJdYzd0VVQtyGe56zDGpllJ5X+5fnvzZftM/Za
	U7dU8uJ6ob92Scz2TWvP/VZiKc5INNRiLipOBABDhLmFkwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-10-27 at 20:36 +0100, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 10/27/2014 04:03 PM, Krzysztof Kozlowski wrote:
> > The driver is used only on Exynos based boards with DTS support.
> > Convert the driver to DTS-only version.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/regulator/max77802.c | 44 +++++++++++++++-----------------------------
> >  1 file changed, 15 insertions(+), 29 deletions(-)
> > 
> > diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
> > index 5839c4509e1f..61d03e9f8acf 100644
> > --- a/drivers/regulator/max77802.c
> > +++ b/drivers/regulator/max77802.c
> 
> The original ChromeOS max77xxx driver supported both DT and platform data
> configuration and that's why the max77802 driver was not DT-only.

If you mean custom vendor kernel (probably 3.4, 3.8 or 3.10 with board
files) then we shouldn't care. It is out of tree. The driver is for the
mainline kernel.

> 
> But I looked at the ChromeOS kernel now and indeed even in that tree there
> are no board files using the max77802 platform data so I agree that it
> should be removed.
> 
> Acked-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Thanks! However Mark had some comments which will reorganize the patch
completely. I'll be sending next version and probably I would need your
ack and testing again.

Best regards,
Krzysztof

> 
> Best regards,
> Javier

