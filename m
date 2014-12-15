Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750763AbaLOK11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:27:27 -0500
Received: from mout.web.de ([212.227.17.11]:61758 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaLOK1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:27:24 -0500
From: Alexander Stein <alexanders83@web.de>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
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
Subject: Re: [PATCH v3 05/11] memory: add Atmel EBI (External Bus Interface) driver
Date: Mon, 15 Dec 2014 11:29:14 +0100
Message-ID: <6356167.d2upusqxqj@ws-stein>
User-Agent: KMail/4.14.3 (Linux/3.16.5-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141215112230.6fca1d69@bbrezillon>
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com> <5455670.EDnhYEk7hP@kongar> <20141215112230.6fca1d69@bbrezillon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:herUWq/qTlJ4AjckS3IEjvSKCTCjJYm1iJM6wePk++q+wpZP3zQ
 LfEpBhC0QxCWYkcf/sf7lDLHFGMhr8lr7QMm9v3zP49wGwivQjZvQT17SqPP/jdglLKHv7o
 eUIK+v9CEzfyzz/Dj+RgbflmH9np6HquwRfpotQUZm369tdv8OJmF+xp2a3Al7sU/USz8WJ
 DjM+MJEdS9YFbq/252Snw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 December 2014 11:22:30, Boris Brezillon wrote:
> Hi Alexander,
> 
> On Tue, 09 Dec 2014 21:53:12 +0100
> Alexander Stein <alexanders83@web.de> wrote:
> 
> > Hi,
> > 
> > On Monday 01 December 2014, 11:27:21 wrote Boris Brezillon:
> > > +static int at91_ebi_probe(struct platform_device *pdev)
> > > +{
> > > +	const struct of_device_id *match;
> > > +	struct device_node *child;
> > > +	struct device_node *np;
> > > +	struct at91_ebi *ebi;
> > > +	struct clk *clk;
> > > +	int ret;
> > > +
> > > +	match = of_match_device(at91_ebi_id_table, &pdev->dev);
> > > +	if (!match || !match->data)
> > > +		return -EINVAL;
> > > +
> > > +	ebi = devm_kzalloc(&pdev->dev, sizeof(*ebi), GFP_KERNEL);
> > > +	if (!ebi)
> > > +		return -ENOMEM;
> > > +
> > > +	ebi->caps = match->data;
> > > +	ebi->dev = &pdev->dev;
> > > +
> > > +	clk = devm_clk_get(&pdev->dev, NULL);
> > > +	if (IS_ERR(clk))
> > > +		return PTR_ERR(clk);
> > > +
> > > +	ebi->clk = clk;
> > > +
> > > +	np = of_parse_phandle(pdev->dev.of_node, "atmel,smc", 0);
> > > +	if (!np)
> > > +		return -EINVAL;
> > > +
> > > +	ebi->smc = syscon_node_to_regmap(np);
> > > +	if (IS_ERR(ebi->smc))
> > > +		return PTR_ERR(ebi->smc);
> > > +
> > > +	/*
> > > +	 * The sama5d3 does not provide an EBICSA register and thus does need
> > > +	 * to access the matrix registers.
> > > +	 */
> > > +	if (ebi->caps->ebi_csa) {
> > > +		np = of_parse_phandle(pdev->dev.of_node, "atmel,matrix", 0);
> > > +		if (np)
> >          ^^^^^^^
> > Shouldn't this be if (!np)?
> 
> Absolutely, thanks for pointing this out.
> I'll test on other at91 platforms (I currently only test on sama5d3
> boards, which do not have this EBICSA register) before submitting a new
> version.

Oh, well. I've noticed you posted a v4 of this patch which changed this specific code. I didn't noticed this.
I'll replace the old v3 and retry. I'm using this code on 9263 so far configuring EBI1 for a PSRAM. Works so far.
Once I exchanged patch 05/11 with your v4 I'll send my DT changes for 9263 to support this feature.

Best regards,
Alexander

