Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3J2LmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:42:16 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:51357 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3J2LmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:42:13 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-a9-526f9f12b79a
From: Tomasz Figa <t.figa@samsung.com>
To: Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, rjw@sisk.pl, mark.rutland@arm.com,
        swarren@wwwdotorg.org, linux-doc@vger.kernel.org,
        viresh.kumar@linaro.org, s.nawrocki@samsung.com,
        m.szyprowski@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        thomas.abraham@linaro.org, b.zolnierkie@samsung.com,
        t.stanislaws@samsung.com, devicetree@vger.kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        rob.herring@calxeda.com, ben-linux@fluff.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, rob@landley.net
Subject: Re: [PATCH v5 0/3] ARM: S5PV210: move to common clk framework
Date: Tue, 29 Oct 2013 12:42:02 +0100
Message-id: <1823897.8rOixkM4PW@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-reply-to: <20131021121605.11944.74007@quantum>
References: <1380027009-2239-1-git-send-email-m.krawczuk@partner.samsung.com>
 <5264425E.4040301@samsung.com> <20131021121605.11944.74007@quantum>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA03SW0jTURzAcc7/touu/s4LBw3DkUVC1sCHU9kFAvlbUCGZpnaZOtTanO3f
	RHtxqEyRVkNT5zCd6CjnLbVMzbyjkWWa6QIvgWJ5ywenZaXWLi++fc+Pz/mdl8PFhV8Ib25S
	8j2pMlkiE1F8YmhncPyIsFwRdmzIdAA16htIlF/fjaH5zE0OKu8fJtHwUjVAWuM4hT5krnBQ
	09wEiSo0VQQaay+lkFXbD5D+YyeGJscEaKj2HY7q+qc5yGQZtS3RjVJIV1xHoEcVWgz1PbMt
	rl8sJlDfSg6Jlno0BCrLWSTRgL4KIHP7FkCNG8xZH6a2rBYw2VkPKMZo/cxhts0LONNmmOYw
	1U/XKWappoRkpiY6KKa5KoPpWe3AmIcvzICZrcwGjLXJl2l8En55TxQ/OF4qS0qVKo+evsVP
	nBpwT2n2TPvUVYCrwcDePMDjQjoIds1pgLO94MhMA5UH+FwhbQIwd6aVcB7yMDi9sYDZFUUf
	hFb1LGVvD/oiLFpX43aE0y0krPmhcyB3OgRmvdc4EEH7Q435N25vAX0Yjpb/cfRe+hBcbZl3
	eE+bL97sccx5tBg21zzmOF8uALCpcofjvOwGNwtmCHvj9H7Y2VVIOjsANrQNYjrgZtjFDLuY
	YRczAtwMPKWquBQ2NkEuDmQlclaVnBAYp5A3AedvWG8FlQMnegHNBSJXAaIUYUJSksqmy3sB
	5OIiDwGvxDYSxEvS70uViptKlUzK9gKMy/NWg7T85e25Rhevv91W4xWh/lRgKD0SHfr8kt/d
	b2OKra9XK7BfKkN14T75cfZlafjb0gA/Vca1ImWqtd1yRnE7OOHc5JvXUp+T4rW11diamPDv
	VsuNVzp+YmQa7wI/d+e8t0WVkxS5LLzTov034hoV4i/acvG9HmP6KYsIGo+OMESKCDZRIg7A
	lazkP74l8kPrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin, Mike,

On Monday 21 of October 2013 05:16:05 Mike Turquette wrote:
> Quoting Kukjin Kim (2013-10-20 13:51:42)
> > On 10/20/13 01:03, Tomasz Figa wrote:
> > > Hi Mike, Kukjin, Rafael,
> > >
> > > On Tuesday 24 of September 2013 14:50:06 Mateusz Krawczuk wrote:
> > >> This patch series is the new s5pv210 clock implementation
> > >> (using common clk framework).
> > >>
> > >> This implementation is compatible with device tree definition and board
> > >> files.
> > >>
> > >> This patch series is based on linux-next and has been tested on goni and
> > >> aquila
> > >> boards using board file.
> > >>
> > >> Since v4:
> > >> Corrected mux flags for finpll.
> > >>
> > >> Since v3:
> > >>
> > >> Replace s5pv210_clk_register_finpll, by creating mux finpll
> > >> with xusbxti and xxti as parrents.
> > >>
> > >>
> > >> Mateusz Krawczuk (3):
> > >>    clk: samsung: Add clock driver for s5pc110/s5pv210
> > >>    Cpufreq: s5pv210 cpufreq fixes for CCF
> > >>    ARM: s5pv210: Migrate clock handling to Common Clock Framework
> > >>
> > >>   .../bindings/clock/samsung,s5pv210-clock.txt       |  75 +++
> > >>   arch/arm/mach-s5pv210/Kconfig                      |   9 +
> > >>   arch/arm/mach-s5pv210/Makefile                     |   4 +-
> > >>   arch/arm/mach-s5pv210/common.c                     |  17 +
> > >>   arch/arm/mach-s5pv210/common.h                     |  10 +
> > >>   arch/arm/mach-s5pv210/mach-goni.c                  |   2 +-
> > >>   arch/arm/mach-s5pv210/mach-smdkv210.c              |   2 +-
> > >>   arch/arm/plat-samsung/Kconfig                      |   2 +-
> > >>   drivers/clk/samsung/Makefile                       |   3 +
> > >>   drivers/clk/samsung/clk-s5pv210.c                  | 673
> > >> +++++++++++++++++++++ drivers/cpufreq/s5pv210-cpufreq.c
> > >>   |   6 +-
> > >>   include/dt-bindings/clock/samsung,s5pv210-clock.h  | 224 +++++++
> > >>   12 files changed, 1019 insertions(+), 8 deletions(-)
> > >>   create mode 100644
> > >> Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
> > >> create mode 100644 drivers/clk/samsung/clk-s5pv210.c
> > >>   create mode 100644 include/dt-bindings/clock/samsung,s5pv210-clock.h
> > >
> > > I believe this series is reasonable to be applied. Could we agree on
> > > the tree it would go through and get all tne required acks?
> > >
> > > Best regards,
> > > Tomasz
> > 
> > I agree.
> > 
> > Mike, how do you think the common clk stuff for s5pv210?
> 
> Clock code looks good to me. Which tree do you want to take it through?

Seems like we just missed another kernel release. It's a bit sad that it's
happening so often for Samsung patches...

Best regards,
Tomasz

