Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaKCQup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:50:45 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:46278 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbaKCQul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:50:41 -0500
Date: Mon, 3 Nov 2014 16:50:35 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd: db8500-prcmu: Provide sane error path values
Message-ID: <20141103165035.GB12011@x1>
References: <1415031356-11664-1-git-send-email-lee.jones@linaro.org>
 <CAOMZO5C2sB1GNuNE-Bi5jqMO4DqBcDW2C1O+asYkbW=8fXA7TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5C2sB1GNuNE-Bi5jqMO4DqBcDW2C1O+asYkbW=8fXA7TA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2014, Fabio Estevam wrote:

> On Mon, Nov 3, 2014 at 2:15 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> >         /* Clean up the mailbox interrupts after pre-kernel code. */
> > @@ -3179,15 +3179,14 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
> >         irq = platform_get_irq(pdev, 0);
> >         if (irq <= 0) {
> 
> Shouldn't this be if (irq < 0) then?

Perhaps Linus can answer that.

Linus,

  Is 0 a valid IRQ on the u8500 platform or not?

> >                 dev_err(&pdev->dev, "no prcmu irq provided\n");
> > -               return -ENOENT;
> > +               return irq;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
