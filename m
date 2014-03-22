Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbaCVOwn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 10:52:43 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:56951 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaCVOwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 10:52:39 -0400
Message-ID: <532DA3BB.5090000@gmail.com>
Date: Sat, 22 Mar 2014 15:52:43 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
CC: rafael.j.wysocki@intel.com, Tomasz Figa <t.figa@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCHv4 0/5] devfreq: exynos: Fix minor issue and code clean
 to remove legacy method
References: <1395284353-22458-1-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1395284353-22458-1-git-send-email-cw00.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[fixing mistyped addresses of me and Bartlomiej]

On 20.03.2014 03:59, Chanwoo Choi wrote:
> This patchset use SIMPLE_DEV_PM_OPS macro intead of legacy method and fix
> probe fail if CONFIG_PM_OPP is disabled. Also, this patchset fix minor issue.
>
> Changes from v3:
> - Discard patches related to DT support because DT support patch of patchset
>    don't satisfy the basic of dt concept. So, I'm going to implement DT support
>    patch regardless this patchset separately.
> - Use SIMPLE_DEV_PM_OPS macro instead of SET_SYSTEM_SLEEP_PM_OPS macro
> - Delete devfreq->profile->exit callback to improve readability when failure
>    happen in probe().
> - Add exynos5 patch to clean code
>
> Changes from v2:
> - Add detailed description to Documentation/devicetree/bindings/exynos4_bus.txt
>    and change patch description of patch#8
> - Change the sequence of patchset in patch #1 ~ #4
> - Fix minor issue
>
> Changes from v1:
> - Add exynos4_bus.txt documentation for devicetree guide
> - Fix probe failure if CONFIG_PM_OPP is disabled
> - Fix typo and resource leak(regulator/clock/memory) when happening probe failure
> - Add additionally comment for PPMU usage instead of previous PPC
> - Split separate patch to remove ambiguous of patch
>
> Chanwoo Choi (5):
>    devfreq: exynos4: Fix bug of resource leak and code clean on probe()
>    devfreq: exynos4: Use SIMPLE_DEV_PM_OPS macro
>    devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix probe fail
>    devfreq: exynos5: Use SIMPLE_DEV_PM_OPS macro
>    devfreq: exynos5: Add CONFIG_PM_OPP dependency to fix probe fail
>
>   drivers/devfreq/Kconfig              |  2 ++
>   drivers/devfreq/exynos/exynos4_bus.c | 43 ++++++++++++++++++++++--------------
>   drivers/devfreq/exynos/exynos5_bus.c |  7 ++++--
>   3 files changed, 34 insertions(+), 18 deletions(-)
>

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
