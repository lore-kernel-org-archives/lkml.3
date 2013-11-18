Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab3KRN5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:57:41 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43074 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab3KRN5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:57:31 -0500
Date: Mon, 18 Nov 2013 13:56:39 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Sekhar Nori <nsekhar@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 3/7] gpio: davinci: use irqdomain
Message-ID: <20131118135639.GD16735@n2100.arm.linux.org.uk>
References: <1383905510-31760-1-git-send-email-prabhakar.csengg@gmail.com> <1383905510-31760-4-git-send-email-prabhakar.csengg@gmail.com> <CACRpkdaJg4wqtD5xhPVrHJHxFoVwau6jidbOuQ9xFSK_6drxPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaJg4wqtD5xhPVrHJHxFoVwau6jidbOuQ9xFSK_6drxPQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 02:11:32PM +0100, Linus Walleij wrote:
> On Fri, Nov 8, 2013 at 11:11 AM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
> 
> > From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> >
> > This patch converts the davinci gpio driver to use irqdomain
> > support.
> >
> > Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> (...)
> > @@ -282,8 +283,7 @@ gpio_irq_handler(unsigned irq, struct irq_desc *desc)
> >         desc->irq_data.chip->irq_ack(&desc->irq_data);
> >         while (1) {
> >                 u32             status;
> > -               int             n;
> > -               int             res;
> > +               int             bit;
> 
> Why is this an int? I think u8 would suffice.

For local variables, it's better to use "int" or even "unsigned" here
rather than u8.  u8 tells the compiler that you want the variable to be
8-bit, which seems fine, except the compiler is then at liberty to keep
on masking the register back down to 8-bit.
