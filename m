Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaBMMfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 07:35:30 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8888 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbaBMMf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:35:28 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-ef-52fcbc0dd27b
Message-id: <1392294923.14541.0.camel@AMDC1943>
Subject: Re: [PATCH v2 07/14] regulator: s2mps11: Copy supported regulators
 from initconst
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Date: Thu, 13 Feb 2014 13:35:23 +0100
In-reply-to: <CAKew6eUtuQEHJJ9G+g54LRoH8sXzqixDBUEjCjFyRDJTRP00Nw@mail.gmail.com>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-8-git-send-email-k.kozlowski@samsung.com>
 <CAKew6eUtuQEHJJ9G+g54LRoH8sXzqixDBUEjCjFyRDJTRP00Nw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t/xK7q8e/4EGbT1SltsnLGe1WLqwyds
	Fte/PGe1ONv0ht3i/tejjBbfrnQwWVzeNYfNYsb5fUwWa4/cZbc43c1qcXHFFyaLub8bWR14
	PHbOusvusWlVJ5vHnWt72DzmnQz06NuyitHj8ya5ALYoLpuU1JzMstQifbsErozz59YyFrzk
	rZg4+z17A+Mk7i5GTg4JAROJxiNL2CBsMYkL99YD2VwcQgJLGSVmrG2Dcj4zSpw7PoEZpIpX
	QF+iq+EmO4gtLBAjcf7FLFYQm03AWGLzcohJIgIGEhOXzAOLMwvcYpZYe9msi5GDg0VAVaJn
	nwpImFMgWOLJ/03MEPPPMEocvHaZEaJeXWLSvEXMEBcpSexu72SHiMtLbF7zFuoGQYkfk++x
	TGAUmIWkZRaSsllIyhYwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECImPLzsYFx+zOsQo
	wMGoxMNrsex3kBBrYllxZe4hRgkOZiUR3sZtf4KEeFMSK6tSi/Lji0pzUosPMTJxcEo1MFbJ
	HE4T6z/dfuTB6rx3yqbSgTveH/mWMLm0eG1IwOpZJROmcWXOOP/X66SbjRs7q/T2zoi4XVM7
	nGw51JcUBFj51D1R4pFX+qhx7YlPtzJr6ob7O/zWrTCM09yyItXuaLF81JNFDBpB0S82eq/c
	pMeZNuF7wq+d12+ryhkX9b72Oip643NHshJLcUaioRZzUXEiABopp09tAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-13 at 17:51 +0530, Yadwinder Singh Brar wrote:
> Hi,
> 
> On Thu, Feb 13, 2014 at 2:44 PM, Krzysztof Kozlowski
> <k.kozlowski@samsung.com> wrote:
> > Add __initconst to 'regulator_desc' array with supported regulators.
> > During probe choose how many and which regulators will be supported
> > according to device ID. Then copy the 'regulator_desc' array to
> > allocated memory so the regulator core can use it.
> >
> > Additionally allocate array of of_regulator_match() dynamically (based
> > on number of regulators) instead of allocation on the stack.
> >
> > This is needed for supporting different devices in s2mps11
> > driver and actually prepares the regulator driver for supporting the
> > S2MPS14 device.
> >
> > Code for supporting the S2MPS14 device will add its own array of
> > 'regulator_desc' (also marked as __initconst). This way memory footprint
> > of the driver will be reduced (approximately 'regulators_desc' array for
> > S2MPS11 occupies 5 kB on 32-bit ARM, for S2MPS14 will occupy 3 kB).
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> > Cc: Mark Brown <broonie@kernel.org>
> > Cc: Liam Girdwood <lgirdwood@gmail.com>
> > Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>
> > ---
> 
> Just observed one trivial thing that in this patch, spacing is not
> provided before and after multiplication binary operator ( _ * _ ),
> which is recommended by linux spacing convention.
> 
> Other than that it looks fine to me, pls feel free to add
> 
> Reviewed-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> 

Thanks for review. I'll send a patch with proper spacing around '*'.

Best regards,
Krzysztof



