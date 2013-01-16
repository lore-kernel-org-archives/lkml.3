Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab3APDBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:01:18 -0500
Received: from mail1.windriver.com ([147.11.146.13]:44775 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab3APDBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:01:16 -0500
Message-ID: <50F617E4.4070109@windriver.com>
Date: Wed, 16 Jan 2013 11:00:52 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: <benh@kernel.crashing.org>, <galak@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][v0][PATCH 1/1] ppc64: ignore interrupts while offline
References: <1358245860-6546-1-git-send-email-tiejun.chen@windriver.com>
In-Reply-To: <1358245860-6546-1-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [147.11.178.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this to check next version.

Tiejun

On 01/15/2013 06:31 PM, Tiejun Chen wrote:
> With lazy interrupt, some implementations of hotplug will
> get some interrupts even while offline, just ignore these.
>
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>   arch/powerpc/kernel/irq.c |    6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> index 4f97fe3..dbca574 100644
> --- a/arch/powerpc/kernel/irq.c
> +++ b/arch/powerpc/kernel/irq.c
> @@ -144,6 +144,12 @@ notrace unsigned int __check_irq_replay(void)
>   	 */
>   	unsigned char happened = local_paca->irq_happened;
>
> +	/* Some implementations of hotplug will get some interrupts while
> +	 * offline, just ignore these.
> +	 */
> +	if (cpu_is_offline(smp_processor_id()))
> +		return 0;
> +
>   	/* Clear bit 0 which we wouldn't clear otherwise */
>   	local_paca->irq_happened &= ~PACA_IRQ_HARD_DIS;
>
>

