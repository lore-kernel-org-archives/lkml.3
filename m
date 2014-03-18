Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbaCRPrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:47:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37026 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbaCRPro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:47:44 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-88-53286a9fb481
Message-id: <53286A9A.1040207@samsung.com>
Date: Tue, 18 Mar 2014 16:47:38 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 0/8] devfreq: exynos4: Support dt and use common ppmu
 driver
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
 <5323432E.5060005@samsung.com> <532656B1.2010907@samsung.com>
In-reply-to: <532656B1.2010907@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t/xq7rzszSCDU49FrTo6PnNYnH9y3NW
	i/lHzrFanHu1ktHibNMbdouFbUtYLC7vmsNm8bn3CKPFjPP7mCyWXr/IZHG7cQWbxZsfZ5ks
	Jkxfy2LxeMVbdotXB9tYHPg91sxbw+ixcvkXNo/Fe14yefxcvp3do2/LKkaP4ze2M3l83iTn
	sXFuaABHFJdNSmpOZllqkb5dAlfGzFUlBSelK65d2srawPhftIuRk0NCwETi8voFjBC2mMSF
	e+vZuhi5OIQEljJKfOvazgqSEBL4zCjx+Y4YiM0roCXR+XsCWJxFQFVi2qYD7CA2m4CaxOeG
	R2wgNj9QzZqm6ywgtqhAhMTciZvZIHoFJX5MvgcWFxHQkJj59wrYYmaBr0wSN+cxgdjCAiES
	tw4dgTqilVHiQftfsASngLbEloWHmSAarCVWTtoG1SwvsXnNW+YJjIKzkOyYhaRsFpKyBYzM
	qxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCIu3LDsbFx6wOMQpwMCrx8ErGagQLsSaWFVfm
	HmKU4GBWEuFd7Q4U4k1JrKxKLcqPLyrNSS0+xMjEwSnVwChRtquoOnzPjbyDd5a+d1rd+iD0
	1Oc9L4wfrKpxy2d40z/jscqLsKAHire2Cx+5/ip6QeT6Bed292hKFs7bapr5/fl/jyblpptX
	3R/d3h34Yt7VK2flqh58dhf40nPg2I4YVY6sr387AvI07966ajct9fRnwx6f69f7C9omy833
	E+c9YPLf6k2dEktxRqKhFnNRcSIAOrtXmpICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 17.03.2014 02:58, Chanwoo Choi wrote:
> Hi Tomasz,
>
> On 03/15/2014 02:58 AM, Tomasz Figa wrote:
>> Hi Chanwoo,
>>
>> On 13.03.2014 09:17, Chanwoo Choi wrote:
>>> This patchset support devicetree and use common ppmu driver instead of
>>> individual code of exynos4_bus.c to remove duplicate code. Also this patchset
>>> get the resources for busfreq from dt data by using DT helper function.
>>> - PPMU register address
>>> - PPMU clock
>>> - Regulator for INT/MIF block
>>>
>>> This patchset use SET_SYSTEM_SLEEP_PM_OPS macro intead of legacy method.
>>> To remove power-leakage in suspend state, before entering suspend state,
>>> disable ppmu clocks.
>>>
>>> Changes from v1:
>>> - Add exynos4_bus.txt documentation for devicetree guide
>>> - Fix probe failure if CONFIG_PM_OPP is disabled
>>> - Fix typo and resource leak(regulator/clock/memory) when happening probe failure
>>> - Add additionally comment for PPMU usage instead of previous PPC
>>> - Split separate patch to remove ambiguous of patch
>>>
>>> Chanwoo Choi (8):
>>>     devfreq: exynos4: Support devicetree to get device id of Exynos4 SoC
>>>     devfreq: exynos4: Use common ppmu driver and get ppmu address from dt data
>>>     devfreq: exynos4: Add ppmu's clock control and code clean about regulator control
>>>     devfreq: exynos4: Fix bug of resource leak and code clean on probe()
>>>     devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro
>>>     devfreq: exynos4: Fix power-leakage of clock on suspend state
>>>     devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix probe fail
>>>     devfreq: exynos4: Add busfreq driver for exynos4210/exynos4x12
>>>
>>>    .../devicetree/bindings/devfreq/exynos4_bus.txt    |  49 +++
>>>    drivers/devfreq/Kconfig                            |   1 +
>>>    drivers/devfreq/exynos/Makefile                    |   2 +-
>>>    drivers/devfreq/exynos/exynos4_bus.c               | 415 ++++++++++++++-------
>>>    4 files changed, 341 insertions(+), 126 deletions(-)
>>>    create mode 100644 Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
>>>
>>
>> I have reviewed this series and there are several comments that I'd like to ask you to address. Please see my replies to particular patches.
>
> OK, I'll fix it about your comment.
>
>>
>> However, this driver, even after applying your series, is still far from a state that would allow it to be enabled. The most important issue is direct access to CMU registers, based on static mapping, which is not allowed on multiplatform kernels and multiplatform-awareness for drivers is currently a must.
>>
>> To allow this driver to be enabled, it needs to be converted to use common clock framework functions to configure all clocks, e.g. clk_set_rate(), clk_set_parent(), etc., without accessing CMU registers directly.
>>
>> Of course as long as the driver is effectively unusable, to keep development, we can proceed with refactoring it step-by-step and your series would be basically the first step, after addressing the review comments.
>>
>
> I agree your opinion. When setting frequency of memory bus, this driver access
> directly to CMU registers. I know it should be modified by using common clk
> framework as your comment.
>
> I'll send patch set about using common clk framework instead of CMU register
> based on static mapping after finished the review and apply of this patch set as next step.

OK. I'm looking forward for patches sorting this out.

Best regards,
Tomasz
