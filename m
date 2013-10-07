Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab3JGRHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:07:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48193 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3JGRHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:07:14 -0400
Message-ID: <5252EA3F.9090101@wwwdotorg.org>
Date: Mon, 07 Oct 2013 11:07:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        Laxman Dewangan <ldewangan@nvidia.com>
CC: linux-serial@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: tegra: remove deprecated IRQF_DISABLED
References: <1381041017-12806-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1381041017-12806-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2013 12:30 AM, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.

Laxman, care to comment? I'm not sure why the code explicitly specifies
IRQF_DISABLED if it's already a no-op. Perhaps the code expects
IRQF_DISABLED to do something, and hence there's some bug that needs to
be fixed because of it doesn't?

> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  drivers/tty/serial/serial-tegra.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
> index 0489a2b..dfe79cc 100644
> --- a/drivers/tty/serial/serial-tegra.c
> +++ b/drivers/tty/serial/serial-tegra.c
> @@ -1018,7 +1018,7 @@ static int tegra_uart_startup(struct uart_port *u)
>  		goto fail_hw_init;
>  	}
>  
> -	ret = request_irq(u->irq, tegra_uart_isr, IRQF_DISABLED,
> +	ret = request_irq(u->irq, tegra_uart_isr, 0,
>  				dev_name(u->dev), tup);
>  	if (ret < 0) {
>  		dev_err(u->dev, "Failed to register ISR for IRQ %d\n", u->irq);
> 

