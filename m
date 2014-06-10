Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaFJXfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:35:48 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:58354 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbaFJXfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:35:47 -0400
Message-ID: <5397963F.30109@gmail.com>
Date: Wed, 11 Jun 2014 01:35:27 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, linux@arm.linux.org.uk,
        kgene.kim@samsung.com, t.figa@samsung.com
CC: kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] ARM: EXYNOS: Fix the sequence of secondary CPU
 boot for Exynos3250
References: <1402442827-2321-1-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1402442827-2321-1-git-send-email-cw00.choi@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 11.06.2014 01:27, Chanwoo Choi wrote:
> This patch set AUTOWAKEUP_EN bit to ARM_CORE_CONFIGURATION register
> because Exynos3250 removes WFE in secure mode so that turn on automatically
> after setting CORE_LOCAL_PWR_EN. Also, This patch use dbs_sev() macro
> to guarantee the data synchronization of command instead of IPI_WAKEUP
> because Exynos3250 don't have WFE mode in secue mode.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-exynos/platsmp.c  | 9 ++++++++-
>  arch/arm/mach-exynos/pm.c       | 8 ++++++--
>  arch/arm/mach-exynos/regs-pmu.h | 4 ++++
>  3 files changed, 18 insertions(+), 3 deletions(-)
> 

This patch seems to be unneeded with Krzysztof's patch send a while ago
[1]. As reported by Krzysztof, that patch apparently fixes SMP support
on Exynos3250 and is much smaller and less invasive.

[1] - http://thread.gmane.org/gmane.linux.kernel.samsung-soc/32809

Best regards,
Tomasz
