Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab3JRKPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 06:15:48 -0400
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:36600 "HELO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752744Ab3JRKPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 06:15:46 -0400
MIME-Version: 1.0
In-Reply-To: <1382090789-18177-1-git-send-email-vkale@apm.com>
References: <1382090789-18177-1-git-send-email-vkale@apm.com>
Date: Fri, 18 Oct 2013 15:39:08 +0530
Message-ID: <CAPrCYke1_RjUgH79vZW99pwdExo4BspCaVi7zL-8hapKb0=gwQ@mail.gmail.com>
Subject: Re: [PATCH] genirq: error reporting for non-percpu interrupt in request_percpu_irq()
From: Vinayak Kale <vkale@apm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: tglx <tglx@linutronix.de>, Will Deacon <will.deacon@arm.com>,
        Vinayak Kale <vkale@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need for this patch is discussed in mail-thread [1].

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/204414.html

Thanks
-Vinayak

On Fri, Oct 18, 2013 at 3:36 PM, Vinayak Kale <vkale@apm.com> wrote:
> Return a separate error code when a non-percpu interrupt is passed to
> request_percpu_irq().
>
> Suggested-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Vinayak Kale <vkale@apm.com>
> ---
>  kernel/irq/manage.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 514bcfd..c2713ae 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -1671,10 +1671,12 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
>                 return -EINVAL;
>
>         desc = irq_to_desc(irq);
> -       if (!desc || !irq_settings_can_request(desc) ||
> -           !irq_settings_is_per_cpu_devid(desc))
> +       if (!desc || !irq_settings_can_request(desc))
>                 return -EINVAL;
>
> +       if (!irq_settings_is_per_cpu_devid(desc))
> +               return -EPERM;
> +
>         action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
>         if (!action)
>                 return -ENOMEM;
> --
> 1.7.9.5
>
