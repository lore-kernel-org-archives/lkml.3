Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab3GYV6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:58:14 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38104 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab3GYV6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:58:11 -0400
MIME-Version: 1.0
In-Reply-To: <1326313337-24603-12-git-send-email-grant.likely@secretlab.ca>
References: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
	<1326313337-24603-12-git-send-email-grant.likely@secretlab.ca>
Date: Thu, 25 Jul 2013 23:58:10 +0200
X-Google-Sender-Auth: NlcstzrcOzR-eZNRyUmQ0CUf7mk
Message-ID: <CAMuHMdV=pSG+CtvGqr1c9nDKeHCU0cVQcFkfAo5iMMna2HOvZg@mail.gmail.com>
Subject: Re: [RFC 11/14] powerpc: Eliminate NO_IRQ usage
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 9:22 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> NO_IRQ is evil.  Stop using it in arch/powerpc and powerpc device drivers

> diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
> index 3e06696..55c6ff9 100644
> --- a/sound/soc/fsl/fsl_ssi.c
> +++ b/sound/soc/fsl/fsl_ssi.c
> @@ -666,7 +666,7 @@ static int __devinit fsl_ssi_probe(struct platform_device *pdev)
>         ssi_private->ssi_phys = res.start;
>
>         ssi_private->irq = irq_of_parse_and_map(np, 0);
> -       if (ssi_private->irq == NO_IRQ) {
> +       if (!ssi_private->irq) {
>                 dev_err(&pdev->dev, "no irq for node %s\n", np->full_name);
>                 ret = -ENXIO;
>                 goto error_iomap;

What's the plan with this patch?

This is now failing on xtensa, as it's one of the architectures that doesn't
define NO_IRQ. Only arm, c6x, mn10300, openrisc, parisc, powerpc, and sparc
define it.

sound/soc/fsl/fsl_ssi.c:705:26: error: 'NO_IRQ' undeclared (first use
in this function)
make[4]: *** [sound/soc/fsl/fsl_ssi.o] Error 1

http://kisskb.ellerman.id.au/kisskb/buildresult/9187959/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
