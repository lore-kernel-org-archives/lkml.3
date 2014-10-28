Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbaJ1JLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:11:17 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14748 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaJ1JLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:11:13 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-ee-544f5daec9a6
Message-id: <1414487468.24949.21.camel@AMDC1943>
Subject: Re: [PATCH 3/8] mfd: max77686/802: Remove support for board files
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
Date: Tue, 28 Oct 2014 10:11:08 +0100
In-reply-to: <544EA178.3090506@collabora.co.uk>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
 <1414422226-10948-4-git-send-email-k.kozlowski@samsung.com>
 <544EA178.3090506@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e/4Vd11sf4hBucuy1psnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6w6F1wlc3ibNMbdov7X48yWny70sFksenxNVaLy7vmsFnM
	OL+PyeL2ZV6LtUfusluc7mZ1EPBoae5h8/j7/DqLx99VL5g9ds66y+6xaVUnm8eda3vYPOad
	DPTYvKTeo2/LKkaPz5vkAriiuGxSUnMyy1KL9O0SuDIar/cwFuzjqXjUe4atgfE9ZxcjJ4eE
	gInE56V32SBsMYkL99YD2VwcQgJLGSXe929hhXA+M0oc3T6HFaSKV8BA4tXjRYwgtrCAl8Sn
	SUvZQWw2AWOJzcuXgE0SEbCTuLH6ITNIM7PAYRaJRQ+ugyVYBFQlPv/cC9bMKaAv0XquC2rd
	KkaJiztXg21gFlCXmDRvEVA3B9BNyhKN/W4QiwUlfky+xwJRIi+xec1b5gmMArOQdMxCUjYL
	SdkCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCGx9nUH49JjVocYBTgYlXh4I1j8Q4RY
	E8uKK3MPMUpwMCuJ8EbEAIV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwCu4yCk2f/LDEy+Dy8jRt
	o6kvJib8+rKHpYL56lV/9WPSTBsluxMuil3uNahQmPyg3Td4y1SWghudEfe2Nj+1lJub5nzp
	qw6DRZXcRwlhSbHA1qpf78t51bZlxd2O8OFLrlUO3Smn8uDNvUIZJfvD27x2da+YtDPhZGH7
	4f+vmiRb9l5LWvVAiaU4I9FQi7moOBEAnwpxQZMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-10-27 at 20:48 +0100, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 10/27/2014 04:03 PM, Krzysztof Kozlowski wrote:
> > The driver is used only on Exynos based boards with DTS support.
> > Convert the driver to DTS-only version. This simplifies a little the
> > code:
> > 1. No dead (unused) entries in platform_data structure.
> > 2. More code removed (from all three patches: 34 insertions(+), 107
> >    deletions).
> > 3. Regulator driver does not depend on allocated memory
> >    from MFD driver.
> > 4. It makes also easier extending the regulator driver
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/mfd/max77686.c               | 23 -----------------------
> >  include/linux/mfd/max77686-private.h |  1 -
> >  include/linux/mfd/max77686.h         | 22 ----------------------
> >  3 files changed, 46 deletions(-)
> > 
> > diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
> > index 929795eae9fc..3da237afacde 100644
> > --- a/drivers/mfd/max77686.c
> > +++ b/drivers/mfd/max77686.c
> 
> As I said in Patch 2/8, I think this driver should depend on OF since
> is now DT-only. Regulator drivers don't need to do this since they
> already depend on MFD_MAX77686. With that change feel free to add:
> 
> Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> 
> Please also add my Reviewed-by tag to Patch 2/8 since I just noticed
> that I forgot to add it.

Thank you, I'll add depends on OF.

Best regards,
Krzysztof
> 
> Best regards,
> Javier

