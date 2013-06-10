Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3FJMDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 08:03:24 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:43087 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab3FJMDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 08:03:23 -0400
MIME-Version: 1.0
In-Reply-To: <1370864113-17895-2-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
	<1370864113-17895-2-git-send-email-tushar.behera@linaro.org>
Date: Mon, 10 Jun 2013 17:33:22 +0530
Message-ID: <CAK9yfHyndkfDV6K4brkk06BHQAW=v-gpDw5w+dRqGrKhQ0yuFA@mail.gmail.com>
Subject: Re: [PATCH 01/15] sparc,leon: Convert to use devm_ioremap_resource
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        sparclinux@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 June 2013 17:04, Tushar Behera <tushar.behera@linaro.org> wrote:
> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and deprecated the use of
> devm_request_and_ioremap().
>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> CC: sparclinux@vger.kernel.org
> CC: "David S. Miller" <davem@davemloft.net>
> ---
> * Not compile tested.
>  arch/sparc/kernel/leon_pci_grpci1.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/sparc/kernel/leon_pci_grpci1.c b/arch/sparc/kernel/leon_pci_grpci1.c
> index 7739a54..23497f4 100644
> --- a/arch/sparc/kernel/leon_pci_grpci1.c
> +++ b/arch/sparc/kernel/leon_pci_grpci1.c
> @@ -536,10 +536,10 @@ static int grpci1_of_probe(struct platform_device *ofdev)
>
>         /* find device register base address */
>         res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
> -       regs = devm_request_and_ioremap(&ofdev->dev, res);
> -       if (!regs) {
> +       regs = devm_ioremap_resource(&ofdev->dev, res);
> +       if (IS_ERR(regs)) {
>                 dev_err(&ofdev->dev, "io-regs mapping failed\n");

You may remove the above error message as devm_ioremap_resource prints
its own error messages.

> -               return -EADDRNOTAVAIL;
> +               return PTR_ERR(regs);
>         }
>
>         /*
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With warm regards,
Sachin
