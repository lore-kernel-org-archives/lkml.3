Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab3KIBE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 20:04:26 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57989 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab3KIBEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 20:04:25 -0500
Message-ID: <527D8A17.9020208@codeaurora.org>
Date: Fri, 08 Nov 2013 17:04:23 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vinayak Kale <vkale@apm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: patches@apm.com, tglx@linutronix.de, will.deacon@arm.com, jcm@redhat.com
Subject: Re: [PATCH 0/2] genirq: arm64: perf: support for percpu pmu interrupt
References: <1383739658-10036-1-git-send-email-vkale@apm.com>
In-Reply-To: <1383739658-10036-1-git-send-email-vkale@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/13 04:07, Vinayak Kale wrote:
> This patch series adds support to handle interrupt registration/deregistration
> in arm64 pmu driver when pmu interrupt type is percpu.
>
> Patches in this patch series were previously sent out as separate patches [1].
> This patch series incorporates comments/fixes suggested for original patches.
>
> [1] 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/205888.html
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/204414.html 
>
> Vinayak Kale (2):
>   genirq: error reporting in request_percpu_irq() and
>     request_threaded_irq()
>   arm64: perf: add support for percpu pmu interrupt
>
>  arch/arm64/kernel/perf_event.c |  109 +++++++++++++++++++++++++++++-----------
>  kernel/irq/manage.c            |   12 +++--
>  2 files changed, 89 insertions(+), 32 deletions(-)
>

What ever happened to the approach here[1]? It doesn't look very nice to
have to request the irq first as a per-cpu interrupt and then try as a
non-percpu interrupt when genirq already knows if its per-cpu or not.

[1] http://lkml.indiana.edu/hypermail/linux/kernel/1207.3/02955.html

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

