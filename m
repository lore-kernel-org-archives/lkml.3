Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaBQIHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:07:41 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42902 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaBQIHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:07:39 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-ae-5301c3485361
Message-id: <1392624454.3755.12.camel@AMDC1943>
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
Date: Mon, 17 Feb 2014 09:07:34 +0100
In-reply-to: <20140214210502.GX4451@sirena.org.uk>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-12-git-send-email-k.kozlowski@samsung.com>
 <CAKew6eWcwVm1EAUAdFu48y_O5puu+eGvGW3k6923MdXfMa3UAw@mail.gmail.com>
 <1392383156.12506.20.camel@AMDC1943> <20140214210502.GX4451@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t/xK7oehxmDDTo38VtsnLGe1WLqwyds
	Fte/PGe1ONv0ht3i/tejjBbfrnQwWVzeNYfNYsb5fUwWa4/cZbc43c1qcXHFFyaL9TNes1jM
	/d3I6sDrsXPWXXaPTas62TzuXNvD5jHvZKBH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZbQ+
	nMtWsI+novegdAPjF84uRk4OCQETiW8rN7FC2GISF+6tZ+ti5OIQEljKKLHkdReU85lR4ujK
	J2wgVbwC+hLNG8+D2cICoRKX1v1gAbHZBIwlNi9fAhYXEVCWuPp9LwtIM7NAN4vE5z/XGLsY
	OThYBFQltj7IAqnhFDCS2DNvFtSCWUwSn89OAhvELKAuMWneImaIk5Qkdrd3skPE5SU2r3nL
	DHGEoMSPyfdYJjAKzELSMgtJ2SwkZQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihETK
	lx2Mi49ZHWIU4GBU4uE1qGYMFmJNLCuuzD3EKMHBrCTCa7sOKMSbklhZlVqUH19UmpNafIiR
	iYNTqoExdOn3WROPrmh3inW/qyexX5/zaSEXz9brZmpHXIM8O4qt7F/v5NFjlJgfs0HaSOhx
	hZ9xttBE4/VfyrsT9+k7OIXNf+3a1eXyLYT7Zv20TQIsl909n0prtWd1Tkvb0vEgVXOV/cPg
	0ruHPovVTVj2fH3zh0M7GwzXJf1Yv3G7QuAVj3pRjRQlluKMREMt5qLiRACy4Y/AcgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-14 at 21:05 +0000, Mark Brown wrote:
> On Fri, Feb 14, 2014 at 02:05:56PM +0100, Krzysztof Kozlowski wrote:
> > On Thu, 2014-02-13 at 17:46 +0530, Yadwinder Singh Brar wrote:
> 
> >  - low-power mode;
> >  - low-power mode controlled by PWREN;
> > Although not all are present for each regulator.
> 
> What exactly is low power mode and how does it interact with the enable?
> The name suggests it's a more efficient mode for use with low current
> drain, is that right?

Yes, it is (i.e. ground current on battery load typically reduced from
8mA to 1.5mA). In this mode for Buck5 and LDO-s the regulator is enabled
but output current is limited to 5 mA.

> 
> > A generic solution for operating mode of regulators (not only s2mps11
> > and s5m8767) could cover all of these above or just a subset, for
> > example regulator bindings could look like:
> >  - regulator-mode-suspend; /* PWR controls: on/off or low-power mode */
> >  - regulator-mode-low-power; /* Low power mode */
> 
> Those properties have awfully generic names and part of what I was
> wondering above is if the low power mode maps onto the idle or standby
> modes that the API defines?  We don't cover those in the bindings yet
> since they are unfortunately fuzzy but perhaps we need to do so.

The low power maps to REGULATOR_MODE_IDLE or REGULATOR_MODE_STANDBY
(depending on the understanding of "more efficient" and "most efficient"
for light loads). However the suspend mode of S5M8767/S2MPS14 is more
like automatic regulator disable by SoC.

Best regards,
Krzysztof


