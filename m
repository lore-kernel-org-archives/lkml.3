Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaKCQfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:35:52 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:59220 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaKCQfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:35:51 -0500
MIME-Version: 1.0
In-Reply-To: <1415031356-11664-1-git-send-email-lee.jones@linaro.org>
References: <1415031356-11664-1-git-send-email-lee.jones@linaro.org>
Date: Mon, 3 Nov 2014 14:35:50 -0200
Message-ID: <CAOMZO5C2sB1GNuNE-Bi5jqMO4DqBcDW2C1O+asYkbW=8fXA7TA@mail.gmail.com>
Subject: Re: [PATCH] mfd: db8500-prcmu: Provide sane error path values
From: Fabio Estevam <festevam@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 2:15 PM, Lee Jones <lee.jones@linaro.org> wrote:

>         /* Clean up the mailbox interrupts after pre-kernel code. */
> @@ -3179,15 +3179,14 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
>         irq = platform_get_irq(pdev, 0);
>         if (irq <= 0) {

Shouldn't this be if (irq < 0) then?

>                 dev_err(&pdev->dev, "no prcmu irq provided\n");
> -               return -ENOENT;
> +               return irq;
