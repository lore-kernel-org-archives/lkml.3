Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbaBRIMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 03:12:16 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26292 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbaBRIMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 03:12:14 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-10-530315dbf0b2
Message-id: <1392711129.14646.9.camel@AMDC1943>
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
Date: Tue, 18 Feb 2014 09:12:09 +0100
In-reply-to: <20140218003555.GJ2669@sirena.org.uk>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-12-git-send-email-k.kozlowski@samsung.com>
 <CAKew6eWcwVm1EAUAdFu48y_O5puu+eGvGW3k6923MdXfMa3UAw@mail.gmail.com>
 <1392383156.12506.20.camel@AMDC1943> <20140214210502.GX4451@sirena.org.uk>
 <1392624454.3755.12.camel@AMDC1943> <20140218003555.GJ2669@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t/xy7q3RZmDDXb/krDYOGM9q8XUh0/Y
	LK5/ec5qcbbpDbvF/a9HGS2+Xelgsri8aw6bxYzz+5gs1h65y25xupvV4uKKL0wW62e8ZrGY
	+7uR1YHXY+esu+wem1Z1snncubaHzWPeyUCPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyrjy
	O7dgB3vFvI0T2RoYf7F2MXJySAiYSDTvPsMIYYtJXLi3nq2LkYtDSGApo0T737nMEM5nRomn
	E/eDVfEK6Eu8bN4NZgsLhEpcWveDBcRmEzCW2Lx8CRuILSKgLHH1+14WkGZmgW4Wic9/roE1
	sAioSizf9wFsNaeAkUTvgwlQG54xSZzZfg+sm1lAXWLSvEXMEDcpSexu72SHiMtLbF7zlhni
	CkGJH5PvsUxgFJiFpGUWkrJZSMoWMDKvYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJla87
	GJceszrEKMDBqMTD+0GZKViINbGsuDL3EKMEB7OSCO+d+0Ah3pTEyqrUovz4otKc1OJDjEwc
	nFINjLF5+b//sb+uW3vsbfsTNYGvat6O+uXzDgSptWhmBkfyxe2dfizQK2nBJ6vEM1np140K
	LT9cZfts6+ab7S699e3VGb2roncm5oj8DrHQWdLy/WL2qexFs39Wsrw6nLLE8RGLjEVa7RJx
	4/XJy5MabGtuxEwT1XK5OnHHLSOhfJXWV68UmGelKrEUZyQaajEXFScCAHXgebJzAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 09:35 +0900, Mark Brown wrote:
> On Mon, Feb 17, 2014 at 09:07:34AM +0100, Krzysztof Kozlowski wrote:
> 
> > The low power maps to REGULATOR_MODE_IDLE or REGULATOR_MODE_STANDBY
> > (depending on the understanding of "more efficient" and "most efficient"
> > for light loads). However the suspend mode of S5M8767/S2MPS14 is more
> > like automatic regulator disable by SoC.
> 
> I don't understand the above?  Are you saying that suspend mode actually
> turns off the regulator or something else? If it's a separate setting
> for suspend mode then it should be using the core suspend mode stuff.

No, it is similar to external control (by GPIO) except that regulator is
controlled by PWREN pin. The PMIC's PWREN is not a GPIO, but instead it
is directly connected to AP (for Exynos 4212: XPWRRGTON). In AP's normal
mode the XPWRRGTON/PWREN is high. In sleep mode *AP* sets it low.

Best regards,
Krzysztof



