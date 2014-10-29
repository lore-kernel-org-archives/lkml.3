Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbaJ2JUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:20:22 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46198 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbaJ2JUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:20:17 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-81-5450b14f1386
Message-id: <1414574413.18868.6.camel@AMDC1943>
Subject: Re: [PATCH v5 3/4] regulator: max77686: Add suspend disable for some
 LDOs
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Wed, 29 Oct 2014 10:20:13 +0100
In-reply-to: <20141028223121.GH18557@sirena.org.uk>
References: <1414411911-5539-1-git-send-email-k.kozlowski@samsung.com>
 <1414411911-5539-4-git-send-email-k.kozlowski@samsung.com>
 <20141028223121.GH18557@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xa7r+GwNCDKbvZ7bYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g0bvgKpvF2aY37BbfrnQwWWx6fI3V4vKuOWwWM87vY7K4
	fZnXYu2Ru+wOfB4tzT1sHn+fX2fx+LvqBbPHzll32T02repk89i8pN6jb8sqRo/Pm+QCOKK4
	bFJSczLLUov07RK4Mua9/cFYsJKjYvOhVywNjK/Zuhg5OSQETCSOn3zIDGGLSVy4tx4sLiSw
	lFHi0tzMLkYuIPszo8SLzQ/ZQRK8AvoSV9fsACsSFgiR+HbtABOIzSZgLLF5+RKwuIiAssTV
	73tZQJqZBaaxSCz4eIkRJMEioCrx8elksG2cQA2rps9kgdiwhlHi3szlYEXMAuoSk+YtAiri
	ADpJWaKx3w1isaDEj8n3WCBK5CU2r3nLPIFRYBaSjllIymYhKVvAyLyKUTS1NLmgOCk911Cv
	ODG3uDQvXS85P3cTIySKvuxgXHzM6hCjAAejEg+vxm7/ECHWxLLiytxDjBIczEoivDvMA0KE
	eFMSK6tSi/Lji0pzUosPMTJxcEo1MNqtWSL7TH3tBZefibPbXr5pnOD8bvaD9QsW/av4tG9b
	dun3e/flgssm77qk4P6N7/v0iOvzV3S8fsKT9Fb754O1/zfzKq17XZbe+Gu201bGc99TeMxF
	O7svnTtjotiXXt1qd+LJuptc/+csTUn8n/bsNd+H2fu3Br99G5fvGlc7yyrEmqMqYekrJZbi
	jERDLeai4kQA9duNWoACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-10-28 at 22:31 +0000, Mark Brown wrote:
> On Mon, Oct 27, 2014 at 01:11:49PM +0100, Krzysztof Kozlowski wrote:
> 
> > @@ -247,6 +250,8 @@ static struct regulator_ops max77686_ldo_ops = {
> >  	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
> >  	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
> >  	.set_suspend_mode	= max77686_ldo_set_suspend_mode,
> > +	.set_suspend_disable	= max77686_set_suspend_disable,
> > +	.set_suspend_enable	= max77686_enable,
> 
> This looks wrong, you're using the regular enable operation as suspend
> enable.  How does that work without disrupting the current runtime
> state?

Currently it shouldn't disrupt state of regulator because during runtime
it may only be only: on (0x3) or off (0x0). Suspend enable in max77686
writes 0x3 to the register which means - always on.

If regulator was disabled before suspend then it has to be enabled
during suspend_enable() call which is exactly what max77686_enable does.
If it was enabled then nothing happens.

Best regards,
Krzysztof

