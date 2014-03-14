Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbaCNR6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:58:14 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45266 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaCNR6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:58:10 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-39-532343309bb1
Message-id: <5323432E.5060005@samsung.com>
Date: Fri, 14 Mar 2014 18:58:06 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 0/8] devfreq: exynos4: Support dt and use common ppmu
 driver
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e/4VV0DZ+Vgg3cN7BYdPb9ZLK5/ec5q
	Mf/IOVaLc69WMlqcbXrDbrGwbQmLxeVdc9gsPvceYbSYcX4fk8XS6xeZLG43rmCzePPjLJPF
	hOlrWSwer3jLbvHqYBuLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4MqY1HGKsWCFWMWWB1dZGxhvCHYxcnJICJhINN2azgxhi0lc
	uLeerYuRi0NIYCmjxO/735ghnM+MErd/TAGr4hXQkrh58xsjiM0ioCqxqe0/C4jNJqAm8bnh
	ERuIzQ9Us6bpOlhcVCBCYu7EzWwQvYISPybfA4pzcIgIxEtc/CQIMp9ZYB+TxJcZv9lBaoQF
	QiRuHToCVi8k4CpxoRViL6eAm8TNu9OYQGxmAWuJlZO2MULY8hKb17xlnsAoOAvJillIymYh
	KVvAyLyKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyTWvuxgXHzM6hCjAAejEg/vBSXlYCHW
	xLLiytxDjBIczEoivPuNgUK8KYmVValF+fFFpTmpxYcYmTg4pRoYeTOvnkupKBO80r6z1y+6
	6VzTyfB79lctLzTsf3KMN+b4c/5A65RKv8+hzzYqPerZIrrLdK7jFb45NcVcUrqsaZKXNT3W
	mdasrM05bdt0beeJ/YveGVxz2bPi7bFzrQnu7Vv61niwSqT8zNopPdtDaNHCVq8dZprBzeWi
	Act4BRLLCmR/SScosRRnJBpqMRcVJwIAq6MXYJMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 13.03.2014 09:17, Chanwoo Choi wrote:
> This patchset support devicetree and use common ppmu driver instead of
> individual code of exynos4_bus.c to remove duplicate code. Also this patchset
> get the resources for busfreq from dt data by using DT helper function.
> - PPMU register address
> - PPMU clock
> - Regulator for INT/MIF block
>
> This patchset use SET_SYSTEM_SLEEP_PM_OPS macro intead of legacy method.
> To remove power-leakage in suspend state, before entering suspend state,
> disable ppmu clocks.
>
> Changes from v1:
> - Add exynos4_bus.txt documentation for devicetree guide
> - Fix probe failure if CONFIG_PM_OPP is disabled
> - Fix typo and resource leak(regulator/clock/memory) when happening probe failure
> - Add additionally comment for PPMU usage instead of previous PPC
> - Split separate patch to remove ambiguous of patch
>
> Chanwoo Choi (8):
>    devfreq: exynos4: Support devicetree to get device id of Exynos4 SoC
>    devfreq: exynos4: Use common ppmu driver and get ppmu address from dt data
>    devfreq: exynos4: Add ppmu's clock control and code clean about regulator control
>    devfreq: exynos4: Fix bug of resource leak and code clean on probe()
>    devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro
>    devfreq: exynos4: Fix power-leakage of clock on suspend state
>    devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix probe fail
>    devfreq: exynos4: Add busfreq driver for exynos4210/exynos4x12
>
>   .../devicetree/bindings/devfreq/exynos4_bus.txt    |  49 +++
>   drivers/devfreq/Kconfig                            |   1 +
>   drivers/devfreq/exynos/Makefile                    |   2 +-
>   drivers/devfreq/exynos/exynos4_bus.c               | 415 ++++++++++++++-------
>   4 files changed, 341 insertions(+), 126 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
>

I have reviewed this series and there are several comments that I'd like 
to ask you to address. Please see my replies to particular patches.

However, this driver, even after applying your series, is still far from 
a state that would allow it to be enabled. The most important issue is 
direct access to CMU registers, based on static mapping, which is not 
allowed on multiplatform kernels and multiplatform-awareness for drivers 
is currently a must.

To allow this driver to be enabled, it needs to be converted to use 
common clock framework functions to configure all clocks, e.g. 
clk_set_rate(), clk_set_parent(), etc., without accessing CMU registers 
directly.

Of course as long as the driver is effectively unusable, to keep 
development, we can proceed with refactoring it step-by-step and your 
series would be basically the first step, after addressing the review 
comments.

Best regards,
Tomasz
