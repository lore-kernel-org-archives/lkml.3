Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaKCMHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:07:12 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21116 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaKCMHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:07:09 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f6c6d00000120b-49-54576fe86c37
Content-transfer-encoding: 8BIT
Message-id: <1415016422.4241.28.camel@AMDC1943>
Subject: Re: [PATCH 6/8] regulator: max77686: Add external GPIO control
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 03 Nov 2014 13:07:02 +0100
In-reply-to: <20141031103217.GJ18557@sirena.org.uk>
References: <1414422226-10948-7-git-send-email-k.kozlowski@samsung.com>
 <544EA4FA.6040704@collabora.co.uk> <1414486356.24949.19.camel@AMDC1943>
 <1414498308.24949.32.camel@AMDC1943> <1414579362.18868.11.camel@AMDC1943>
 <5450C63B.3000602@collabora.co.uk>
 <CAAVeFuLncbkNLGxEAj90yMmugRDNjtjeGoV_QYTMDZ7NVMJCmg@mail.gmail.com>
 <1414681386.26703.6.camel@AMDC1943>
 <CAAVeFuJo1wTyxOo4FEZM3=GTejuSHi+mnr=QV6HUeV5mAOCmqg@mail.gmail.com>
 <1414741898.20071.8.camel@AMDC1943> <20141031103217.GJ18557@sirena.org.uk>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e/4Fd0X+eEhBp9Ps1lsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC3OvXrEYnH0d4FF74KrbBZnm96wW9z/epTR4tuVDiaLKX+WM1ls
	enyN1eLyrjlsFjPO72OyuH2Z12LtkbvsFqe7WR2EPFqae9g8/j6/zuLxd9ULZo+ds+6ye2xa
	1cnmcefaHjaPeScDPTYvqffo27KK0ePzJrkArigum5TUnMyy1CJ9uwSujG8vPAv6uCvOPu1g
	aWD8zdHFyMkhIWAicfjLUTYIW0ziwr31QDYXh5DAUkaJWf2bWEESvAKCEj8m32PpYuTgYBaQ
	lzhyKRskzCygLjFp3iJmiPrPjBLvJv1kh6jXl9gzpQ1sqLCAu8T9hYeYQGw2AWOJzcuXgMVF
	BJQlrn7fywLSzCxwiE2iY8kBZpAEi4CqxK9va8FsTqCGFX9vMEFsaGaReL33KhvIFRJA3Y39
	bhMYBWYhuW8Wwn2zkNy3gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZI5H3Zwbj4mNUh
	RgEORiUe3gmXw0KEWBPLiitzDzFKcDArifD+SwkPEeJNSaysSi3Kjy8qzUktPsTIxMEp1cC4
	pYHpza+5d/bJ8rnFrSnbv4jh4i2dupWSfw52eh7SUlzJcHBeQ8p65sS3N1IWJjP6xjku1vW4
	bVRjerN28u+zttpLdWLjaldMkdiWmF1UVnrpxZy9Hxf67Vqw4LrViSNvIvfsTPJTXaWwf6r7
	5KlXVznHvZVYmXjKvNJ6nawzX0xjIgdHWts2JZbijERDLeai4kQA6lkbzZoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-10-31 at 10:32 +0000, Mark Brown wrote:
> On Fri, Oct 31, 2014 at 08:51:38AM +0100, Krzysztof Kozlowski wrote:
> 
> > However new DT style parsing (regulator_of_get_init_data()) does the
> > basic parsing stuff and this removes a lot of code from driver. The
> > driver no longer parses all regulaotrs but the regulator core does it.
> > Unfortunately regulator core does not parse custom bindings (like such
> > GPIOs) so I would have to iterate once again through all regulators just
> > to find "gpios" property.
> 
> We could always add a callback for the driver to handle any custom
> properties...  one of the advantages of an OS like Linux is that we can
> improve the core code.

I thought about this - adding a callback, called on each child in
regulator_of_get_init_data(). However the reason behind this callback is
to parse GPIO and set config.ena_gpio. However in that context the
regulator_config is const so the callback cannot change it. Unless it
casts it to non-const... which isn't what we want I think.

So now I wonder whether adding generic bindings for ena_gpio make sense.
These would look like bindings for fixed-regulator (with "ena-" prefix).
Unfortunately this would duplicate a little the ena_gpio in
regulator_config... but to me it seems more appropriate.

What do you think about adding generic bindings for ena_gpio?

Best regards,
Krzysztof


