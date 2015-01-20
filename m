Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbbATOVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:21:49 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43482 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbbATOVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:21:47 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-fe-54be647a0f86
Message-id: <1421763703.8855.10.camel@AMDC1943>
Subject: Re: [PATCH v5 4/5] mfd/regulator: dt-bindings: max77686: Document gpio
 properties
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Tue, 20 Jan 2015 15:21:43 +0100
In-reply-to: <20150120134111.GI13701@x1>
References: <1420458525-22576-1-git-send-email-k.kozlowski@samsung.com>
 <1420458525-22576-5-git-send-email-k.kozlowski@samsung.com>
 <20150120134111.GI13701@x1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xa7pVKftCDGYcVLLYOGM9q8XUh0/Y
	LOYfOcdq0f/4NbPF2aY37Bb3vx5ltPh2pYPJYtPja6wWl3fNYbOYcX4fkwOXx85Zd9k9Nq3q
	ZPO4c20Pm8fmJfUefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlXFt0mW2gpUCFWeX32BuYPzG
	08XIySEhYCKx7vgmVghbTOLCvfVsXYxcHEICSxkl1u05wgjhfGaU6N77mBGkildAX+Ly93Zm
	EFtYIEbiz69XYDabgLHE5uVLgLo5OEQEVCTOvTEH6WUWuMwkcfXyNrBeFgFVifsTD4DZnAIa
	EhsvPmOGWLCYUaJ55kl2kASzgLrEpHmLmEEGSQgoSzT2u0HsFZT4MfkeC0SJvMTmNW+ZJzAK
	zELSMQtJ2SwkZQsYmVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihETD1x2MS49ZHWIU4GBU
	4uE94bw3RIg1say4MvcQowQHs5II71nzfSFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGN1Dn5zo
	VU7mvsx7I3erneZ051+zN/7O0T53wvKfwZz7i2Qtee9c3Viybn3SBfN153q2GPWsfL4z0Mj3
	ifoZNY+Ov5tEDl+v3Wu9etuULXNddrfw3z42/YHaU4+++opvUgdz5id9EJk9OcUrLu37eknm
	5L9T31iXbX/UdJRDcb6MVNLkdyYhYfuUWIozEg21mIuKEwEbxZvfZAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2015-01-20 at 13:41 +0000, Lee Jones wrote:
> On Mon, 05 Jan 2015, Krzysztof Kozlowski wrote:
> 
> > Document usage of maxim,ena-gpios properties which turn on external/GPIO
> > control over regulator.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  Documentation/devicetree/bindings/mfd/max77686.txt | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/mfd/max77686.txt b/Documentation/devicetree/bindings/mfd/max77686.txt
> > index 75fdfaf41831..e39f0bc1f55e 100644
> > --- a/Documentation/devicetree/bindings/mfd/max77686.txt
> > +++ b/Documentation/devicetree/bindings/mfd/max77686.txt
> > @@ -39,6 +39,12 @@ to get matched with their hardware counterparts as follow:
> >  	-BUCKn	:	1-4.
> >    Use standard regulator bindings for it ('regulator-off-in-suspend').
> >  
> > +  LDO20, LDO21, LDO22, BUCK8 and BUCK9 can be configured to GPIO enable
> > +  control. To turn this feature on this property must be added to the regulator
> > +  sub-node:
> > +	- maxim,ena-gpios :	one GPIO specifier enable control (the gpio
> > +				flags are actually ignored and always
> > +				ACTIVE_HIGH is used)
> 
> How does this differ to the 'enable-gpio' property which has already
> been defined?

Strictly speaking - no difference, just a GPIO specifier.

However the 'enable-gpio' property exists only for gpio-regulator. The
regulator core does not support generic enable-gpio property and each
driver implements it on its own.

Anyway Mark Brown already applied this patch to his regulator tree.

Best regards,
Krzysztof

> 
> >  Example:
> >  
> > @@ -65,4 +71,12 @@ Example:
> >  				regulator-always-on;
> >  				regulator-boot-on;
> >  			};
> > +
> > +			buck9_reg {
> > +				regulator-compatible = "BUCK9";
> > +				regulator-name = "CAM_ISP_CORE_1.2V";
> > +				regulator-min-microvolt = <1000000>;
> > +				regulator-max-microvolt = <1200000>;
> > +				maxim,ena-gpios = <&gpm0 3 GPIO_ACTIVE_HIGH>;
> > +			};
> >  	}
> 

