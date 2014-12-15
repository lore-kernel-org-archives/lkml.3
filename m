Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbaLOKnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:43:45 -0500
Received: from down.free-electrons.com ([37.187.137.238]:53963 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751131AbaLOKnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:43:42 -0500
Date: Mon, 15 Dec 2014 11:43:38 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Alexander Stein <alexanders83@web.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH v3 05/11] memory: add Atmel EBI (External Bus Interface)
 driver
Message-ID: <20141215114338.401050ed@bbrezillon>
In-Reply-To: <6356167.d2upusqxqj@ws-stein>
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com>
	<5455670.EDnhYEk7hP@kongar>
	<20141215112230.6fca1d69@bbrezillon>
	<6356167.d2upusqxqj@ws-stein>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2014 11:29:14 +0100
Alexander Stein <alexanders83@web.de> wrote:

> On Monday 15 December 2014 11:22:30, Boris Brezillon wrote:
> > Hi Alexander,
> > 
> > On Tue, 09 Dec 2014 21:53:12 +0100
> > Alexander Stein <alexanders83@web.de> wrote:
> > 
> > > Hi,
> > > 
> > > On Monday 01 December 2014, 11:27:21 wrote Boris Brezillon:
> > > > +static int at91_ebi_probe(struct platform_device *pdev)
> > > > +{
> > > > +	const struct of_device_id *match;
> > > > +	struct device_node *child;
> > > > +	struct device_node *np;
> > > > +	struct at91_ebi *ebi;
> > > > +	struct clk *clk;
> > > > +	int ret;
> > > > +
> > > > +	match = of_match_device(at91_ebi_id_table, &pdev->dev);
> > > > +	if (!match || !match->data)
> > > > +		return -EINVAL;
> > > > +
> > > > +	ebi = devm_kzalloc(&pdev->dev, sizeof(*ebi), GFP_KERNEL);
> > > > +	if (!ebi)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	ebi->caps = match->data;
> > > > +	ebi->dev = &pdev->dev;
> > > > +
> > > > +	clk = devm_clk_get(&pdev->dev, NULL);
> > > > +	if (IS_ERR(clk))
> > > > +		return PTR_ERR(clk);
> > > > +
> > > > +	ebi->clk = clk;
> > > > +
> > > > +	np = of_parse_phandle(pdev->dev.of_node, "atmel,smc", 0);
> > > > +	if (!np)
> > > > +		return -EINVAL;
> > > > +
> > > > +	ebi->smc = syscon_node_to_regmap(np);
> > > > +	if (IS_ERR(ebi->smc))
> > > > +		return PTR_ERR(ebi->smc);
> > > > +
> > > > +	/*
> > > > +	 * The sama5d3 does not provide an EBICSA register and thus does need
> > > > +	 * to access the matrix registers.
> > > > +	 */
> > > > +	if (ebi->caps->ebi_csa) {
> > > > +		np = of_parse_phandle(pdev->dev.of_node, "atmel,matrix", 0);
> > > > +		if (np)
> > >          ^^^^^^^
> > > Shouldn't this be if (!np)?
> > 
> > Absolutely, thanks for pointing this out.
> > I'll test on other at91 platforms (I currently only test on sama5d3
> > boards, which do not have this EBICSA register) before submitting a new
> > version.
> 
> Oh, well. I've noticed you posted a v4 of this patch which changed this specific code. I didn't noticed this.

Indeed, calling syscon_regmap_lookup_by_phandle fixed the problem.

Actually there is a v5 [1], and you should use this version because the
DT binding has slightly changed).
I'll add you in Cc of my future versions ;-).

> I'll replace the old v3 and retry. I'm using this code on 9263 so far configuring EBI1 for a PSRAM. Works so far.
> Once I exchanged patch 05/11 with your v4 I'll send my DT changes for 9263 to support this feature.

Thanks for testing that part, I'm looking forward to your DT
patches :-).

Regards,

Boris

[1]https://lkml.org/lkml/2014/12/3/806

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
