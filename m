Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaGKKkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:40:33 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17444 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaGKKka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:40:30 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-8f-53bfbf1b0851
Message-id: <53BFBF18.3080704@samsung.com>
Date: Fri, 11 Jul 2014 12:40:24 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Tushar Behera <tushar.b@samsung.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        robh+dt@kernel.org, grant.likely@linaro.org, kgene.kim@samsung.com,
        mturquette@linaro.org, t.figa@samsung.com, trblinux@gmail.com
Subject: Re: [PATCH 2/2] clk: exynos-audss: Update as per existing framework
References: <1405071475-31946-1-git-send-email-tushar.b@samsung.com>
 <1405071475-31946-3-git-send-email-tushar.b@samsung.com>
In-reply-to: <1405071475-31946-3-git-send-email-tushar.b@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xy7rS+/cHG7zoNbKYf+Qcq8WBPzsY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZPF0wkU2i9a9R9gt1s94zWKxYfJudosb27+yOHB77Jx1
	l91j06pONo871/aweWxeUu/Rt2UVo8fnTXIBbFFcNimpOZllqUX6dglcGQ8a+Apu8FT8uHeZ
	vYFxKlcXIyeHhICJxOHlUxghbDGJC/fWs3UxcnEICSxllDh6+QELhPOJUeL3reusIFW8AloS
	05+8Y+5i5OBgEVCVmL5YDiTMJmAo0Xu0D2yQqECExIG+Z1DlghI/Jt9jAbFFBDQkri7YDzaT
	WaCPSaJ3dydYQljAR2LJx+tMILaQQL3EgpWdzCA2p4CrxO0te9lAbGYBHYn9rdOgbHmJzWve
	Mk9gFJiFZMcsJGWzkJQtYGRexSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESFV92MC4+ZnWI
	UYCDUYmHV6N2d7AQa2JZcWXuIUYJDmYlEd4n9fuDhXhTEiurUovy44tKc1KLDzEycXBKNTAG
	m26cmJZW5sHHJ1KpNv+Yzv1V0QpVi0wnmzczOs8O0mxzydnxy3r7k+cCpd53N+Vunb5nQeb8
	SwbKh2YsPFzp8P1YrPuWCdvOWj72OFQ/sz2jf6HLP1mVvVomTaL6RZ1Xlik+mF1uUst3bumy
	exVbOb1q2RcEsxrfnKp4xywybvvLyx3i+dVKLMUZiYZazEXFiQDhkfydaAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tushar,

On 11/07/14 11:37, Tushar Behera wrote:
> Change exynos-audss clock driver as per existing clock framework from
> the existing module driver framework.

Can you explain what's the actual issue you're trying to solve with that
patch ? What's the problem with this driver being a platform driver ?
It feels we're moving in circles here, see

commit b37a4224104568198b93fb9831224cfe7d83fff8
Author: Andrew Bresticker <abrestic@chromium.org>
Date:   Wed Sep 25 14:12:47 2013 -0700

    clk: exynos-audss: convert to platform device

    The Exynos AudioSS clock controller will later be modified to allow
    input clocks to be specified via device-tree in order to support
    multiple Exynos SoCs.  This will introduce a dependency on the core
    SoC clock controller being initialized first so that the AudioSS driver
    can look up its input clocks, but the order in which clock providers
    are probed in of_clk_init() is not guaranteed.  Since deferred probing
    is not supported in of_clk_init() and the AudioSS block is not the core
    controller, we can initialize it later as a platform device.

    Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
    Acked-by: Tomasz Figa <t.figa@samsung.com>
    Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Acked-by: Mike Turquette <mturquette@linaro.org>
    Acked-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Tomasz Figa <t.figa@samsung.com>

I realize of_clk_init() now handles better clock provider dependencies,
nevertheless do we really need all this churn ?

--
Thanks,
Sylwester
