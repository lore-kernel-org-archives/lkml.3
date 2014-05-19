Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbaESOpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:45:03 -0400
Received: from mail.southpole.se ([37.247.8.11]:36942 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbaESOpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:45:00 -0400
Message-ID: <537A18E9.4010301@southpole.se>
Date: Mon, 19 May 2014 16:44:57 +0200
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        linux-kernel@vger.kernel.org, linux@openrisc.net
Subject: Re: [PATCH] openrisc: irq: use irqchip framework
References: <1400502328-23974-1-git-send-email-stefan.kristiansson@saunalahti.fi>
In-Reply-To: <1400502328-23974-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.4.1(14097) on assp.southpole.se
X-Assp-ID: assp.southpole.se 10697-03828
X-Assp-Session: 7FF5271B28D8 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

This looks good.  Let's complete the the cleanup of this driver while
we're at it:

i) Move this file to drivers/irqchip/
ii) Put a Depends on CONFIG_ARCH_OPENRISC in the Kconfig
iii) Provide documentation for the binding at
Documentation/devicetree/bindings/interrupt-controller/

Copy final result to Thomas Gleixner who maintains the irqchip bits.

Thanks,
Jonas

On 05/19/2014 02:25 PM, Stefan Kristiansson wrote:
> In addition to consolidating the or1k-pic initialization with
> how other interrupt controllers are initialized, this makes
> OpenRISC less tied to its on-cpu interrupt controller.
> 
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> ---
>  arch/openrisc/kernel/irq.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/openrisc/kernel/irq.c b/arch/openrisc/kernel/irq.c
> index 8ec77bc..f6f4683 100644
> --- a/arch/openrisc/kernel/irq.c
> +++ b/arch/openrisc/kernel/irq.c
> @@ -19,10 +19,13 @@
>  #include <linux/of.h>
>  #include <linux/ftrace.h>

Do we really need to pull in ftrace.h?

<snip>

This last bit (below) stays in the arch/openrisc directory.

>  void __init init_IRQ(void)
>  {
> -	or1k_irq_init();
> +	irqchip_init();
>  }
>  
>  void __irq_entry do_IRQ(struct pt_regs *regs)
> 
