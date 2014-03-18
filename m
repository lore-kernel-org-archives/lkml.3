Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbaCRReS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:34:18 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45450 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673AbaCRReQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:34:16 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-13-53288395ab92
Message-id: <1395164052.24909.11.camel@AMDC1943>
Subject: Re: [PATCH v2 0/3] regulator: s2mps11: Add support for S2MPS14
 regulators
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>
Date: Tue, 18 Mar 2014 18:34:12 +0100
In-reply-to: <1394187052-591-1-git-send-email-k.kozlowski@samsung.com>
References: <1394187052-591-1-git-send-email-k.kozlowski@samsung.com>
References: <1394187052-591-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1394187052-591-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xa7pTmzWCDc5/V7fYOGM9q8XUh0/Y
	LM42vWG3+Halg8ni8q45bBYzzu9jslh75C67xcUVX5gs1s94zWIxZ/o7Jgcuj52z7rJ7bFrV
	yebRt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGS/OHWcuWMRbcb6xl6mBcT5XFyMnh4SAicT2
	5lYmCFtM4sK99WxdjFwcQgJLGSVmNmxigXA+Azn/NoNV8QoYSGzaf4AZxBYWCJF4/LuJHcRm
	EzCW2Lx8CRuILSKgLHH1+16wZmaBb0wS135/B2tmEVCV2L1rLSOIzSngJvHo2F2wZiEBV4kN
	C14xobOR1TALqEtMmreIGeJUJYnd7Z1QcXmJzWveMkMcJyjxY/I9lgmMQrOQtMxCUjYLSdkC
	RuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCHR8nUH49JjVocYBTgYlXh4JWI1goVYE8uK
	K3MPMUpwMCuJ8K52BwrxpiRWVqUW5ccXleakFh9iZOLglGpgNF3zS/2bzVzblP//zqpFFXU4
	SH0Py3j+heltylcOxUnuH6Y4zlT21/I2aZuzuGNesWbTlQuLD+vwJgglf9pgHXtNXfNAj7zW
	qwqV7unK2lrvel8k6M7cwSAua52rwTdjMcMztUlVsYevC2fziZgE9+2sfRposM2f6YHq/QlR
	3bxpbvNX++9TYinOSDTUYi4qTgQAZ0kOGnQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Lee Jones in his pull request [1] put also my changes for S2MPS14
support in MFD sec-core driver. They are needed by this patchset for adding
suppt for regulators on S2MPS14.

Do you have time to look at these patches and apply them if they're OK (or ACK them)?

Best regards,
Krzysztof

[1] mfd: regulator: S2MPA01 device support IB for Mark Brown



On Fri, 2014-03-07 at 11:10 +0100, Krzysztof Kozlowski wrote:
> Hi,
> 
> This patchset adds support for the S2MPS14 device to the s2mps11 regulator
> driver. It's a subset of previously sent patches for S2MPS14 device:
> http://thread.gmane.org/gmane.linux.kernel.samsung-soc/27194/focus=1649217
> along with one new patch:
>  - PATCH 2/3: regulator: s2mps11: Add set_suspend_disable for S2MPS14
> which replaces previous "opmode" idea.
> 
> 
> These patches are rebased against linux-next tree (next-20140305) because
> they depend on changes in main MFD sec-core and s2mps11 regulator driver.
> 
> 
> Changes since v1
> ================
> 1. Patch 2/3: Store information that regulator was suspended.
> 
> 
> Best regards,
> Krzysztof
> 
> 
> Krzysztof Kozlowski (3):
>   regulator: s2mps11: Add support for S2MPS14 regulators
>   regulator: s2mps11: Add set_suspend_disable for S2MPS14
>   Documentation: mfd: s2mps11: Document support for S2MPS14
> 
>  Documentation/devicetree/bindings/mfd/s2mps11.txt |   12 +-
>  drivers/regulator/Kconfig                         |    9 +-
>  drivers/regulator/s2mps11.c                       |  301 ++++++++++++++++-----
>  include/linux/mfd/samsung/s2mps14.h               |    2 +
>  4 files changed, 255 insertions(+), 69 deletions(-)
> 


