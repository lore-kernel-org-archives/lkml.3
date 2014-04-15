Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaDOIM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:12:28 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37156 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaDOIMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:12:22 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-ee-534ce9e3f35d
Message-id: <1397549539.29169.2.camel@AMDC1943>
Subject: Re: [PATCH 4/4] regulator: s5m8767: Use same binding for external
 control as in s2mps11
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Date: Tue, 15 Apr 2014 10:12:19 +0200
In-reply-to: <CAK9yfHwL4o7-7Q03dw9JdD1UDsP_v2=we1kadRXaGAuaN1de_g@mail.gmail.com>
References: <1397462949-22379-1-git-send-email-k.kozlowski@samsung.com>
 <1397462949-22379-5-git-send-email-k.kozlowski@samsung.com>
 <20140414211106.GC12304@sirena.org.uk>
 <CAK9yfHwL4o7-7Q03dw9JdD1UDsP_v2=we1kadRXaGAuaN1de_g@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.8.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e/4Zd3HL32CDQ7fMrHYOGM9q8XUh0/Y
	LOYfOcdq0f9mIavFuVcrGS3ONr1ht7j/9SijxbcrHUwWl3fNYbOYcX4fk8XaI3fZLZZev8hk
	MWH6WhaL1r1H2C1O/ulltDjdzWpxccUXJov1M16zOAh5rJm3htHjcl8vk8fOWXfZPVYu/8Lm
	sWlVJ5vHnWt72DzmnQz06NuyitHj8ya5AM4oLpuU1JzMstQifbsErozba5azFvSyV3R0/GBq
	YNzO2sXIySEhYCLR090DZYtJXLi3nq2LkYtDSGApo0TLoc/MIAkhgc+MEh1tgSA2r4C+RMfx
	0ywgtrBAksTiO2vBatgEjCU2L1/CBmKLCGhJvOxezgQyiFngDKvEgVtLGLsYOThYBFQlpu7l
	BKnhFAiWONI/jR1i2VdGiZvnZ7KDJJgF1CUmzVvEDHGRksS5dWsYIRYLSvyYfI8FokZeYvOa
	t8wTGAVmIWmZhaRsFpKyBYzMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFCIu/rDsalx6wO
	MQpwMCrx8E545x0sxJpYVlyZe4hRgoNZSYT3dbJPsBBvSmJlVWpRfnxRaU5q8SFGJg5OKWBI
	bja1u5x2cxfv67wcBtN3TmucjlYtDT5UNT0qVXB1bJZPv/o1lajlKtImYSnx918HXvhl+9lc
	2u1D/tuLLVL/pTk+5jM13XezPu/1N9Kd62ppAdOPeV1bL6XU/qiZnKfN12F9qGmzUKJxhc1G
	6S/7LtxJD54iZf7ujaHo77k938tDTe6e91BiKc5INNRiLipOBABankyAmgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-04-15 at 13:26 +0530, Sachin Kamat wrote:
> On 15 April 2014 02:41, Mark Brown <broonie@kernel.org> wrote:
> > On Mon, Apr 14, 2014 at 10:09:09AM +0200, Krzysztof Kozlowski wrote:
> >
> >> -     - s5m8767,pmic-ext-control-gpios: (optional) GPIO specifier for one
> >> +     - samsung,ext-control-gpios: (optional) GPIO specifier for one
> >>               GPIO controlling this regulator (enable/disable); This is
> >>               valid only for buck9.
> >
> > This is an incompatible change.  It's OK to deprecate the old property
> > but it's bad form to just remove it.
> 
> I agree with Mark. Also, there is no need to make it generic.

I thought it would be good to make it consistent and to reduce the
number of bindings with same meaning on similar drivers. However I don't
mind skipping this patch.

Thanks for applying rest of patches.

Best regards,
Krzysztof

