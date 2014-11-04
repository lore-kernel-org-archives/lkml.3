Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaKDHxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:53:20 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32209 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaKDHxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:53:16 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-6c-545885ebe092
Message-id: <1415087593.2389.6.camel@AMDC1943>
Subject: Re: [PATCH v3 02/14] mfd/regulator: dt-bindings: max77686: Document
 of_compatible for regulator
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Tue, 04 Nov 2014 08:53:13 +0100
In-reply-to: <20141103170042.GC12011@x1>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
 <1414668053-31370-3-git-send-email-k.kozlowski@samsung.com>
 <20141103170042.GC12011@x1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t/xy7qvWyNCDO5NYrLYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g0bvgKpvF2aY37Bb3vx5ltPh2pYPJYtPja6wWl3fNYbOY
	cX4fk8Xty7wWa4/cZbc43c3qIODR0tzD5vH3+XUWj7+rXjB77Jx1l91j06pONo871/awecw7
	GeixeUm9R9+WVYwenzfJBXBFcdmkpOZklqUW6dslcGWsW3+DqeAdb8XaH41MDYzd3F2MnBwS
	AiYSX/pOs0HYYhIX7q0Hsrk4hASWMkrM276EHcL5zCix8c5fRpAqXgE9iQm7XrKD2MICWRJz
	lixhBrHZBIwlNi9fAtTNwSEioCJx7o05SC+zwH0Wie3r/4JtYBFQlVi97BUriM0poCGxcsUe
	MFtIYDGjxNZZNSA2s4C6xKR5i5hB5kgIKEs09rtBrBWU+DH5HgtEibzE5jVvmScwCsxC0jEL
	SdksJGULGJlXMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoTE2ZcdjIuPWR1iFOBgVOLhzVCP
	CBFiTSwrrsw9xCjBwawkwru6CijEm5JYWZValB9fVJqTWnyIkYmDU6qBsfmx32PvlGu9F2dt
	vMogrOYUuvBsTJrTk5jKxxt8JvckBzRt5X299dn3Oxf5N5/w3mWy87XWH82ZSzx8kuo1Wbc+
	eq93fPbdjKZTpz6Ezlyedle/Nk3qxE+7bYcfhRpHSq+ZIxdard/iFMtTtMs/l/FcqJreOQaW
	zgTmhd7Xs6Vj9v65x3qkRYmlOCPRUIu5qDgRAK/whEmRAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-11-03 at 17:00 +0000, Lee Jones wrote:
> On Thu, 30 Oct 2014, Krzysztof Kozlowski wrote:
> 
> > Document new required property for regulator driver: of_compatible. The
> > property allows MFD core to bind the driver to node with regulators and
> > this simplifies parsing regulators init data from DTS
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  Documentation/devicetree/bindings/mfd/max77686.txt | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> I want a thumbs-up from Mark on this before applying.

I'll be resending new version, without the compatible property.

Best regards,
Krzysztof

> 
> > diff --git a/Documentation/devicetree/bindings/mfd/max77686.txt b/Documentation/devicetree/bindings/mfd/max77686.txt
> > index 75fdfaf41831..f4010a9f66eb 100644
> > --- a/Documentation/devicetree/bindings/mfd/max77686.txt
> > +++ b/Documentation/devicetree/bindings/mfd/max77686.txt
> > @@ -18,8 +18,11 @@ Required properties:
> >  
> >  Optional node:
> >  - voltage-regulators : The regulators of max77686 have to be instantiated
> > -  under subnode named "voltage-regulators" using the following format.
> > +  under subnode named "voltage-regulators".
> > +  Required property:
> > +  - compatible : Must be "maxim,max77686-pmic"
> >  
> > +  Optional properties: For each regulator use following format:
> >  	regulator_name {
> >  		regulator-compatible = LDOn/BUCKn
> >  		standard regulator constraints....
> > @@ -49,6 +52,8 @@ Example:
> >  		reg = <0x09>;
> >  
> >  		voltage-regulators {
> > +			compatible = "maxim,max77686-pmic";
> > +
> >  			ldo11_reg {
> >  				regulator-compatible = "LDO11";
> >  				regulator-name = "vdd_ldo11";
> 

