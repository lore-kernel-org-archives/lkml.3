Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbaGOJ2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:28:03 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:55474 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853AbaGOJ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:27:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH v2 12/29] nios2: Interrupt handling
Date: Tue, 15 Jul 2014 11:27:55 +0200
Message-ID: <5170097.X9RFbxSEnp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405413956-2772-13-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <1405413956-2772-13-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:atlpXh+mQY0Sg6rwF1kYcfEbxZB/FYMYaHnG/4OKPtm
 jk/aqd5TQMIlzkNi3jq6rqSNhd6VysMQPKihTMTu4us8TlQsFk
 /PuFxKvrBjGH8hCbUWlAukI4ApeQfHTQBlWsc0QkpFFUgZiK+a
 lTipriJexBhIMuFkebV+iTVKWnaWGfYYrq1+KLhNsVNYuqGuYN
 JfAhQCeEJZ/FXgNy+dB0zxL19McX53lB3tFWLD/Y3m951sEhMz
 OGm2N7RnGhmBogZ53TLdDCNHDpwMeegrrIdIczbALevVxiztoU
 lBuFX5EpIzBXTRxiybwcB/STD7OZAtBS6ysrsCciwoQlxwBOVI
 pYUS9uX8CqIrJiuVIwo4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2014 16:45:39 Ley Foon Tan wrote:
> +#ifndef _ASM_NIOS2_IRQ_H
> +#define _ASM_NIOS2_IRQ_H
> +
> +#define NIOS2_CPU_NR_IRQS	32
> +/* Reserve 32 additional interrupts for GPIO IRQs */
> +#define NR_IRQS			(NIOS2_CPU_NR_IRQS + 32)

Is this intentional? I would expect that you use SPARSE_IRQ
instead and not define NR_IRQS.

> +#ifndef NO_IRQ
> +#define NO_IRQ			(-1)
> +#endif

New architectures should no longer define NO_IRQ. Please fix all users
you encounter instead.

> diff --git a/arch/nios2/kernel/irq.c b/arch/nios2/kernel/irq.c
> new file mode 100644
> index 0000000..8770d50
> --- /dev/null
> +++ b/arch/nios2/kernel/irq.c
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/of.h>

Maybe move this into drivers/irqchip/? Probably doesn't matter either way,
your choice.

	Arnd
