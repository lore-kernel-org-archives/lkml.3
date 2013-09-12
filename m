Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab3ILGF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:05:58 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:34275 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab3ILGF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:05:56 -0400
MIME-Version: 1.0
In-Reply-To: <1378959624-4123-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1378959624-4123-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Wed, 11 Sep 2013 23:05:56 -0700
Message-ID: <CAP6odjg63+g1gLMS9F+O1fQXwFZud10L11P5irJWdQsuDuNXaA@mail.gmail.com>
Subject: Re: [PATCH] net: tulip: remove deprecated IRQF_DISABLED
From: Grant Grundler <grantgrundler@gmail.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
        "open list:TULIP NETWORK DRI..." <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 9:20 PM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> This patch proposes to remove the IRQF_DISABLED flag from
> drivers/net/ethernet/dec/tulip/de4x5.c
>
> It's a NOOP since 2.6.35 and it will be removed one day.

yup - that was easy to confirm.

> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Acked-by: Grant Grundler <grundler@parisc-linux.org>

thanks,
grant

> ---
>  drivers/net/ethernet/dec/tulip/de4x5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
> index 2db6c57..263b92c 100644
> --- a/drivers/net/ethernet/dec/tulip/de4x5.c
> +++ b/drivers/net/ethernet/dec/tulip/de4x5.c
> @@ -1321,7 +1321,7 @@ de4x5_open(struct net_device *dev)
>      if (request_irq(dev->irq, de4x5_interrupt, IRQF_SHARED,
>                                                      lp->adapter_name, dev)) {
>         printk("de4x5_open(): Requested IRQ%d is busy - attemping FAST/SHARE...", dev->irq);
> -       if (request_irq(dev->irq, de4x5_interrupt, IRQF_DISABLED | IRQF_SHARED,
> +       if (request_irq(dev->irq, de4x5_interrupt, IRQF_SHARED,
>                                                      lp->adapter_name, dev)) {
>             printk("\n              Cannot get IRQ- reconfigure your hardware.\n");
>             disable_ast(dev);
> --
> 1.8.1.2
>
