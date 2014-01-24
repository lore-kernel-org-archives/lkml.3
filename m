Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaAXP05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:26:57 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39520 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaAXP0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:26:55 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-3e-52e2863d039c
Message-id: <52E2862E.9020402@samsung.com>
Date: Fri, 24 Jan 2014 16:26:38 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 5/8 v4] clk: samsung: exynos5250/5420: Add gate clock for
 SSS module
References: <1389354229-31936-1-git-send-email-ch.naveen@samsung.com>
 <1389777366-15147-1-git-send-email-ch.naveen@samsung.com>
In-reply-to: <1389777366-15147-1-git-send-email-ch.naveen@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t/xq7q2bY+CDK71S1vcfX6Y0eLlIU2L
	7lcyFr0LrrJZ3L/3k8ni8q45bBYzzu9jsli07T+zxapdfxgtzs45xOTA5bFz1l12j20HVD36
	tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr43nPdcaCY9wVG46eYmxg3MbZxcjOISFgIjEnr4uR
	E8gSk7hwbz1bFyMXh5DAUkaJG9Mfs0A4nxkllv28yA5SxSugJfFiz102EJtFQFVi17aNYDab
	gJrE54ZHYLaoQITE33nrGSHqBSV+TL7HAmKLCJRL/LuxBmwDs8ABRol100+BNQgLREn0vF4N
	tbqRUWL12k9MXYwcHJwCbhLdSyxBapgFrCVWTtrGCGHLS2xe85Z5AqPALCQ7ZiEpm4WkbAEj
	8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkJD/uoNx6TGrQ4wCHIxKPLwfgh8GCbEmlhVX
	5h5ilOBgVhLhlap+FCTEm5JYWZValB9fVJqTWnyIkYmDU6qBUWKB2NdbPXsM2IxO9e7RWvGa
	d2V82SLxIG7xNMsT/+Lbff00DgSY255M3Cbf7PTzaN3pP3mp8mpWV2q1Za784Vrh+nJvc03g
	jKBteWaMK/4XKe1Mi/8VUSD//n+l6fvzC9vcpuyX1z719nZj89qTBxsiSvI+174subLdyFzb
	V0271OpqUsdhJZbijERDLeai4kQA1WbtiFcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

Exynos5250 specific part looks good, but I have a little doubt in case 
of Exynos5420.

On 15.01.2014 10:16, Naveen Krishna Chatradhi wrote:
> This patch adds gating clock for SSS(Security SubSystem)
> module on Exynos5250/5420.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> TO: <linux-samsung-soc@vger.kernel.org>
> TO: Tomasz Figa <t.figa@samsung.com>
> CC: Kukjin Kim <kgene.kim@samsung.com>
> CC: <linux-crypto@vger.kernel.org>
> ---
> Changes since v3:
> 1. Rebased on to https://git.kernel.org/pub/scm/linux/kernel/git/tfiga/samsung-clk.git
> 2. Added new ID for SSS clock on Exynos5250, with Documentation and
> 3. Added gate clocks definitions for SSS on Exynos5420 and Exynos5250
[snip]
> --- a/drivers/clk/samsung/clk-exynos5420.c
> +++ b/drivers/clk/samsung/clk-exynos5420.c
> @@ -26,6 +26,7 @@
>   #define DIV_CPU1		0x504
>   #define GATE_BUS_CPU		0x700
>   #define GATE_SCLK_CPU		0x800
> +#define GATE_BUS_G2D		0x8700
>   #define CPLL_LOCK		0x10020
>   #define DPLL_LOCK		0x10030
>   #define EPLL_LOCK		0x10040
> @@ -702,6 +703,9 @@ static struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
>   		0),
>   	GATE(CLK_SMMU_MIXER, "smmu_mixer", "aclk200_disp1", GATE_IP_DISP1, 9, 0,
>   		0),
> +
> +	/* SSS */
> +	GATE(CLK_SSS, "sss", "aclk266_g2d", GATE_BUS_G2D, 2, 0, 0),

Isn't there a combined gate for all SSS clocks in one of GATE_IP_* 
registers?

Best regards,
Tomasz
