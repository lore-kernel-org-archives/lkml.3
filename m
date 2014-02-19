Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaBSKJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:09:48 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27768 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaBSKJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:09:44 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-3f-530482e6abd0
Message-id: <1392804580.17652.8.camel@AMDC1943>
Subject: Re: [PATCH v2 11/14] regulator: s2mps11: Add opmode for S2MPS14
 regulators
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Date: Wed, 19 Feb 2014 11:09:40 +0100
In-reply-to: <20140219040818.GQ2669@sirena.org.uk>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-12-git-send-email-k.kozlowski@samsung.com>
 <CAKew6eWcwVm1EAUAdFu48y_O5puu+eGvGW3k6923MdXfMa3UAw@mail.gmail.com>
 <1392383156.12506.20.camel@AMDC1943> <20140214210502.GX4451@sirena.org.uk>
 <1392624454.3755.12.camel@AMDC1943> <20140218003555.GJ2669@sirena.org.uk>
 <1392711129.14646.9.camel@AMDC1943> <20140219040818.GQ2669@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xy7rPmliCDb795rDYOGM9q8XUh0/Y
	LK5/ec5qcbbpDbvF/a9HGS2+Xelgsri8aw6bxYzz+5gs1h65y25xupvV4uKKL0wW62e8ZrGY
	+7uR1YHXY+esu+wem1Z1snncubaHzWPeyUCPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyjh3
	oZe14DdHxfVbHcwNjJ3sXYycHBICJhJP5x5mhLDFJC7cW8/WxcjFISSwlFGidc5UJgjnM6PE
	u2tzWECqeAX0JZ5O2QdmCwuESlxa9wPMZhMwlti8fAkbiC0ioCxx9fteFpBmZoFuFonPf66B
	rWARUJV48amFGcTmFDCSONa+AWrDJmaJVQvOgt3ELKAuMWneImaIm5Qkdrd3QsXlJTavecsM
	cYWgxI/J91gmMArMQtIyC0nZLCRlCxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKERMvX
	HYxLj1kdYhTgYFTi4fV4wRwsxJpYVlyZe4hRgoNZSYT3ThxLsBBvSmJlVWpRfnxRaU5q8SFG
	Jg5OqQZG45tObco3L/XOFSgNyquTfrrm3frDv54rRq6ft/T0ztD/b1gjr1UEHfmT0zdh/dQT
	n7p+qB5z2n3x/m41+yP5jSdWZ5+9/fadxF0HpTzXbRe77KdKx+4MNFjvHzRJ1VWqh/uhkk/X
	osuK263cFocze1qtOdWVLu/CqrIl2nNefV+qzucr7eteKbEUZyQaajEXFScCAMbr7Cp0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-19 at 13:08 +0900, Mark Brown wrote:
> On Tue, Feb 18, 2014 at 09:12:09AM +0100, Krzysztof Kozlowski wrote:
> > On Tue, 2014-02-18 at 09:35 +0900, Mark Brown wrote:
> 
> > > I don't understand the above?  Are you saying that suspend mode actually
> > > turns off the regulator or something else? If it's a separate setting
> > > for suspend mode then it should be using the core suspend mode stuff.
> 
> > No, it is similar to external control (by GPIO) except that regulator is
> > controlled by PWREN pin. The PMIC's PWREN is not a GPIO, but instead it
> > is directly connected to AP (for Exynos 4212: XPWRRGTON). In AP's normal
> > mode the XPWRRGTON/PWREN is high. In sleep mode *AP* sets it low.
> 
> How is that different to suspend mode then?

Now I see... there is no difference. It seems that the whole idea of
opmode can be replaced with suspend modes and regulator modes.

I can't only find a way to set this from DTS. There are no bindings for
regulation_constraints->state_{disk,mem,standby}.

Should the driver set manually after obtaining init_data from DTS?

Best regards,
Krzysztof



