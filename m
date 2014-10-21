Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbaJUKOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:14:42 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44435 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbaJUKOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:14:40 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-40-5446320e8dd7
Message-id: <1413886476.26980.16.camel@AMDC1943>
Subject: Re: [PATCH 2/2] ARM: dts: exynos4412-trats: Add suspend configuration
 for max77686 regulators
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Date: Tue, 21 Oct 2014 12:14:36 +0200
In-reply-to: <54462EB2.2070302@collabora.co.uk>
References: <1413879912-26606-1-git-send-email-k.kozlowski@samsung.com>
 <1413879912-26606-3-git-send-email-k.kozlowski@samsung.com>
 <54461FC0.9020904@samsung.com> <1413883424.26980.7.camel@AMDC1943>
 <54462EB2.2070302@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t/xq7p8Rm4hBhf3C1hsnLGe1WLSugNM
	FlMfPmGzuP7lOavF0d8FFr0LrrJZnG16w27x7UoHk8Wmx9dYLS7vmsNmMeP8PiaL25d5LdYe
	uctusWrXH0YHPo+W5h42j7/Pr7N4/F31gtlj56y77B6bVnWyeWxeUu/Rt2UVo8fnTXIBHFFc
	NimpOZllqUX6dglcGa3bX7MW/OGuuHlFt4FxGWcXIyeHhICJxN3naxkhbDGJC/fWs3UxcnEI
	CSxllGh9tIQVJCEk8JlRYt7c+C5GDg5eAQOJjptKIKawQIZE32stkAo2AWOJzcuXsIHYIgJ2
	EjdWP2QGGcMs0MQi0XTzCQtIgkVAVeL0qjawkZwC+hLbvm5igdj1nlFiVv96dpAEs4C6xKR5
	i5hBFkgIKEs09ruBhHkFBCV+TL7HAlEiL7F5zVvmCYwCs5B0zEJSNgtJ2QJG5lWMoqmlyQXF
	Sem5RnrFibnFpXnpesn5uZsYIfHzdQfj0mNWhxgFOBiVeHgjlriGCLEmlhVX5h5ilOBgVhLh
	zRV2CxHiTUmsrEotyo8vKs1JLT7EyMTBKdXAGK2eNX0h/4FPi8/Nmv+IU1SG5//L9RoC6yTv
	ZDU8WmfDuaTt/mrHhq1ti778mvvo/7ME2aTpwU9uhpb+tPpsZxC3ZsOHJ2/7dBk3mXAH7FxR
	n7NmTfP9XKv9B9/wTW+Nfne69dDaGyyRUuKSDJyS+os+84i6S5ktse5LFQ9ZIpT63W/Nt8Co
	BCWW4oxEQy3mouJEAP0VJSp9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-10-21 at 12:00 +0200, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 10/21/2014 11:23 AM, Krzysztof Kozlowski wrote:
> >> >  
> >> >  				ldo9_reg: ldo9 {
> >> > @@ -295,7 +311,9 @@
> >> >  					regulator-name = "CAM_ISP_MIPI_1.2V";
> >> >  					regulator-min-microvolt = <1200000>;
> >> >  					regulator-max-microvolt = <1200000>;
> >> > -					regulator-mem-idle;
> >> > +					regulator-state-mem {
> >> > +						regulator-on-in-suspend;
> >> 
> >> CAM_ISP_MIPI_1.2V is used for camera, I think this regulator should turn off in suspend state
> >> because camear could not be used in suspend state.
> > 
> > LDO9 does not support off in suspend mode controlled by PWRREQ. It
> > supports only switching to low power mode if PWRREQ level goes low.
> > 
> > Thus the driver does not provide set_suspend_enable or
> > set_suspend_disable for LDO0. Do you want to add such function to the
> > max77686 driver which will explicitly disable the regulator (write 0x0
> > to control reg)?
> > 
> > 
> 
> I think for those regulators you can just use regulator_disable_regmap()
> as the .set_suspend_disable function handler?

Sure... but this does not solve the philosophical problem - this is not
a special suspend configuration. It is disabling the regulator manually,
from regulator core code. Instead probably the camera driver should
disable the regulator in suspend callback.

Another point - I think none of other regulators do this way.

Best regards,
Krzysztof


