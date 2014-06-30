Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaF3Nt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:49:29 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27625 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaF3Nt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:49:27 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-98-53b16ae417ad
Message-id: <53B16AC9.7090509@samsung.com>
Date: Mon, 30 Jun 2014 15:48:57 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: olof@lixom.net, javier.martinez@collabora.co.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rahul.sharma@samsung.com, shaik.ameer@samsung.com, arun.kk@samsung.com,
        alim.akhtar@samsung.com, a.hajda@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3] clk: exynos5420: Remove aclk66_peric from the clock
 tree description
References: <1401467562-5585-1-git-send-email-dianders@chromium.org>
 <1402000514-30752-1-git-send-email-dianders@chromium.org>
In-reply-to: <1402000514-30752-1-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t/xq7pPsjYGG7QulLO4te4cq8WDedvY
	LD6eus1qMf8IkHt22UE2i/43C1ktzr1ayWhx9HeBRe+Cq2wWmx5fY7W4vGsOm8WM8/uYLJZe
	v8hk8XTCRTaLU9c/s1lMmL6WxWLKosOsFq17j7BbHHm4m91B2GPNvDWMHrMbLrJ4XO7rZfL4
	+/w6i8fK5V/YPDat6mTzuHNtD5vH5iX1HldONLF69G1ZxejxeZNcAHcUl01Kak5mWWqRvl0C
	V0br9jXMBX+5KtbOes7awHiLo4uRk0NCwESir+MrK4QtJnHh3nq2LkYuDiGBpYwS/f8vQjmf
	GSVOvTnNDFLFK6AlseTIXjYQm0VAVWLjm9ksIDabgJrE54ZHYHF+oJo1TdeB4hwcogIREo8v
	CEG0Ckr8mHwPrFxEoFxi8oqbjCDzmQVWMktsnXIFLCEsECdxdsFqJojFDYwSb16uZQRJcAq4
	SXTdX8wOYjML6Ejsb53GBmHLS2xe85Z5AqPgLCRLZiEpm4WkbAEj8ypG0dTS5ILipPRcQ73i
	xNzi0rx0veT83E2MkIj9soNx8TGrQ4wCHIxKPLyNKzYEC7EmlhVX5h5ilOBgVhLhvemzMViI
	NyWxsiq1KD++qDQntfgQIxMHp1QD48K3pgyqDwXbHvJteF/CrnzP7fl/2SkHTHdxuM/82PJT
	hXd/9EZp4aMpGQs3ONst289Sl6a9Z8ETLYk723yirxUema3xQ+JunermZT9cJyt/U94k25h0
	qZPJTS/SL2vhxNu20UkGXybKmixTcjaJ9pSoC0jPSReOdWs5vOeZzqKCSUdyvDP5lViKMxIN
	tZiLihMBdq40q7YCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2014 22:35, Doug Anderson wrote:
> The "aclk66_peric" clock is a gate clock with a whole bunch of gates
> underneath it.  This big gate isn't very useful to include in our
> clock tree.  If any of the children need to be turned on then the big
> gate will need to be on anyway.  ...and there are plenty of other "big
> gates" that aren't described in our clock tree, some of which shut off
> collections of clocks that have no relationship in the hierarchy so
> are hard to model.
> 
> "aclk66_peric" is causing earlyprintk problems since it gets disabled
> as part of the boot process, so let's just remove it.
> 
> Strangely (and for no good reason) this clock is exported as part of
> the common clock bindings.  Remove it since there are no in-kernel
> device trees using it and no reason anyone out of tree should refer to
> it either.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v3:
> - Now just remove aclk66_peric from the tree as suggested by Tomasz.
> 
> Changes in v2:
> - Use GATE_A and clk_get().  Save the clock for putting later.
> - Return 0 from exynos5420_clk_late_init().
> 
>  drivers/clk/samsung/clk-exynos5420.c   | 85 ++++++++++++++++++++++------------
>  include/dt-bindings/clock/exynos5420.h |  1 -
>  2 files changed, 55 insertions(+), 31 deletions(-)

Applied as a fix for 3.16.

Best regards,
Tomasz
