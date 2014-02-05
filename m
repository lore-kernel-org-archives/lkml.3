Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbaBEMtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 07:49:40 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18911 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaBEMtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 07:49:39 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-04-52f23360b3fa
Message-id: <1391604574.3726.20.camel@AMDC1943>
Subject: Re: [PATCH 16/18] charger: max14577: Add support for MAX77836 charger
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Jenny Tc <jenny.tc@intel.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Wed, 05 Feb 2014 13:49:34 +0100
In-reply-to: <20140203113031.GA8848@jenny-desktop>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-17-git-send-email-k.kozlowski@samsung.com>
 <20140203113031.GA8848@jenny-desktop>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t/xK7oJxp+CDD7fVbA4uFXTYurDJ2wW
	1788Z7WY9OQ9s8XElZOZLdZ+7WG3ONv0ht3i/tejjBbfrnQwWWx6fI3V4vKuOWwWa4/cZbe4
	3biCzeJ0N6sDn8eE/k+MHjtn3WX32LxCy2PxnpdMHptWdbJ53Lm2h81j3slAj81L6j36tqxi
	9Pi8SS6AK4rLJiU1J7MstUjfLoEr4+GXDraCSxwVO9+dZmtgfMPWxcjJISFgIvF990sWCFtM
	4sK99UBxLg4hgaWMEiunLWWGcD4zSuybdo6xi5GDg1dAX6LrkTNIg7CAn8SZeQ1MIDabgLHE
	5uVLwIaKCChKfO/aDzaIWaCNReLmo6usIAkWAVWJ51O2gW3jFDCSODZpJtS2dYwSX7/fA0sw
	C6hLTJq3iBniJCWJ3e2d7BBxeYnNa96CxXkFBCV+TL7HMoFRYBaSlllIymYhKVvAyLyKUTS1
	NLmgOCk911CvODG3uDQvXS85P3cTIySuvuxgXHzM6hCjAAejEg9vh+jHICHWxLLiytxDjBIc
	zEoivHYGn4KEeFMSK6tSi/Lji0pzUosPMTJxcEo1MNrq/Y1Qq3jmWvKqbWVM1M8d58UU3rcJ
	/mv+dDUrjT1FtKys/Y7K5k/dl88elTxhqbYuZcZb6/4tqu8XOD6ZLtDwMFLowasVvwPc5oWt
	PLCzKH7C3PamHFbWw3KyHoJXHtyT2npvwwuTBxcz9dYK+YR/elfmxufrdFl4QTZXzswEg2fv
	Wr1XCSqxFGckGmoxFxUnAgBBI9P8iQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2014-02-03 at 17:00 +0530, Jenny Tc wrote:
> On Tue, Jan 28, 2014 at 01:18:40PM +0100, Krzysztof Kozlowski wrote:
> > -	/* Battery-Charger Constant Voltage (CV) Mode, from SM-V700: 4.35V */
> > +	/* Battery-Charger Constant Voltage (CV) Mode, set to: 4.35V */
> 
> Does this charger chip support only 4.35V batteries? If the CV is hard coded
> to 4.35V, it's not safe for 4.2V batteries.
> 
> > +	/* End-of-Charge Current, set to 50mA (max14577) / 7.5mA (max77836) */
> The End of charge current basically depend on battery and not on charger chip.
> 
> > -	/* Overvoltage-Protection Threshold, from SM-V700: 6.5V */
> > +	/* Overvoltage-Protection Threshold, set to 6.5V */
> 6.5V as over voltage for battery? A 4.35V battery would have exploded by
> that time!

Currently the max14577 driver has all these values hard-coded. This
patch doesn't change this, it only adds support for max77836. I agree
with you that hard-coding these values is not a proper way of doing
this.

I'll add another patch for parsing these values from DTS.

Best regards,
Krzysztof



