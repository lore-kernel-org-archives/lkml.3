Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbaJ1Iws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:52:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17516 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932598AbaJ1Iwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:52:41 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-65-544f5956813a
Message-id: <1414486356.24949.19.camel@AMDC1943>
Subject: Re: [PATCH 6/8] regulator: max77686: Add external GPIO control
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
Date: Tue, 28 Oct 2014 09:52:36 +0100
In-reply-to: <544EA4FA.6040704@collabora.co.uk>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
 <1414422226-10948-7-git-send-email-k.kozlowski@samsung.com>
 <544EA4FA.6040704@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t/xa7phkf4hBh8m61psnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6w6F1wlc3ibNMbdov7X48yWny70sFksenxNVaLy7vmsFnM
	OL+PyeL2ZV6LtUfusluc7mZ1EPBoae5h8/j7/DqLx99VL5g9ds66y+6xaVUnm8eda3vYPOad
	DPTYvKTeo2/LKkaPz5vkAriiuGxSUnMyy1KL9O0SuDIurfYsmMFWcffJJ+YGxi8sXYycHBIC
	JhI3d3QwQdhiEhfurWfrYuTiEBJYyijxZPlcKOczo8TKnfPBqngFDCQOtTSzgtjCAu4S9xce
	AouzCRhLbF6+hA3EFhGwk7ix+iEzSDOzwGEWiUUProMlWARUJZYsmwy2mlNAX6Jt0yUmiA2r
	GCV27D8IlmAWUJeYNG8RUDcH0E3KEo39bhCLBSV+TL4HVSIvsXnNW+YJjAKzkHTMQlI2C0nZ
	AkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghkfZ1B+PSY1aHGAU4GJV4eCNY/EOEWBPL
	iitzDzFKcDArifAuVwEK8aYkVlalFuXHF5XmpBYfYmTi4JRqYNx6snTudLUn7QsDYjTeKnMf
	08u4UXvh6dKnzv6uqwyVHB/W7Ty07Wi8qZihBfMj5g+mkziWbZ6Qtq7zs9Xq7/dzDs9ZHyIe
	nljltTiYdWbv6r3MEw/aPujbq2HTJWXBa8vUcD7hxLS9ugH3c0KTosp6bKQK3/VLMOR28fGU
	rhXh5Yk42XjxthJLcUaioRZzUXEiADvQ2AmSAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-10-27 at 21:03 +0100, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 10/27/2014 04:03 PM, Krzysztof Kozlowski wrote:
> > @@ -85,6 +91,9 @@ struct max77686_data {
> >  	struct max77686_regulator_data *regulators;
> >  	int num_regulators;
> >  
> > +	/* Array of size num_regulators with GPIOs for external control. */
> > +	int *ext_control_gpio;
> > +
> 
> The integer-based GPIO API is deprecated in favor of the descriptor-based GPIO
> interface (Documentation/gpio/consumer.txt). Could you please use the later?

Sure, I can. Please have in mind that regulator core still accepts old
GPIO so I will have to use desc_to_gpio(). That should work... and
should be future-ready.

Thanks for feedback,
Krzysztof

> 
> Best regards,
> Javier

