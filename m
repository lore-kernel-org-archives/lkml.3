Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab3HFWU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:20:28 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:51842 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab3HFWU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:20:26 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/4] mmc: dw_mmc: Add exynos resume_noirq callback to clear WAKEUP_INT
Date: Wed, 07 Aug 2013 00:20:19 +0200
Message-ID: <4664300.eCYx009QLm@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.4-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAD=FV=W3kxkwHGoWE5YsztW7NNOYQCy6yFwNJQDaTFx=58cgbA@mail.gmail.com>
References: <1373470926-19314-1-git-send-email-dianders@chromium.org> <19655139.gpQFe0oLNI@flatron> <CAD=FV=W3kxkwHGoWE5YsztW7NNOYQCy6yFwNJQDaTFx=58cgbA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 of August 2013 15:09:46 Doug Anderson wrote:
> Tomasz,
> 
> On Tue, Aug 6, 2013 at 2:58 PM, Tomasz Figa <tomasz.figa@gmail.com> 
wrote:
> >> +static int dw_mci_exynos_resume_noirq(struct device *dev)
> >> +{
> >> +     struct dw_mci *host = dev_get_drvdata(dev);
> >> +     u32 clksel;
> >> +
> >> +     clksel = mci_readl(host, CLKSEL);
> >> +     if (clksel & SDMMC_CLKSEL_WAKEUP_INT)
> >> +             mci_writel(host, CLKSEL, clksel);
> > 
> > What about clock gating? Will the clock used for clocking this
> > register be always enabled when this gets called?
> 
> Since this is just accessing and writing a register in the "Mobile
> Storage Host" block, I'd imagine that this should be the "biu" (bus
> interface unit) clock, right?  The dw_mmc code grabs the biu clock at
> probe time and never lets it go.  That means that we're OK as long as
> common clock framework has already restored clocks to normal operation
> by this time.
> 
> Do you think that common clock framework might not have put the clocks
> back into order by the time "noirq" callbacks are executed?

Ahh, so the dw_mmc driver doesn't do any clock gating? This is not very 
nice of it.

Well, in this case your patch is OK, but possibly some clock gating will 
have to be added to this driver at some point of time. Anyway:

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

