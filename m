Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaJANXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:23:55 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:54258 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaJANXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:23:54 -0400
Date: Wed, 1 Oct 2014 15:23:44 +0200 (CEST)
From: Stefan Wahren <stefan.wahren@i2se.com>
Reply-To: Stefan Wahren <stefan.wahren@i2se.com>
To: Mark Brown <broonie@kernel.org>
Cc: kernel@pengutronix.de, pawel.moll@arm.com, lgirdwood@gmail.com,
        robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org, festevam@gmail.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Message-ID: <2002781663.91096.1412169824110.JavaMail.open-xchange@oxbaltgw04.schlund.de>
In-Reply-To: <20140929171314.GW16977@sirena.org.uk>
References: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com> <1411779588-22031-3-git-send-email-stefan.wahren@i2se.com> <20140928101650.GL27755@sirena.org.uk> <5428FE7B.8060700@i2se.com> <20140929171314.GW16977@sirena.org.uk>
Subject: Re: [PATCH 2/2] regulator: add mxs regulator driver
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.6.0-Rev19
X-Originating-Client: com.openexchange.ox.gui.dhtml
X-Provags-ID: V02:K0:mRWfa/2a/CaKGk6frR2nM0K7sV/32iR7z8iLhCvL4HT
 FqF5VJ/19jGo0Tysm3uwLaracESUmR1wE1RMV0Hc3yFHODO98v
 xKRDoqtyQgCJEDgg/aMKHRGwwggmXSv/BGH5c3WRuVP5NODRxE
 iVdYPVf53PbYCGbgaqYfiYffxi6uCgkDjKOUzLv9sg535XDu4J
 jz7QtPyV26+TLud3HcOxiTi/nbCSSS5UGb2X/OrDCcJfLljf7j
 6rAyAthPJCg8fwTHXQ6WAbfD39hAgC4GWVF364xt2o4SgWUEUr
 OlxFNoEREfhHa7ZQS2cS23aQrZ1GOo4WbqlK1OeHTrcXD3XLMJ
 nSc81KCV6kFOzsbv01jGGtjLnCBxd6tm4ASo+BmJ0ijPw1g2cN
 DXjo4d45CL3DVyDpUOhhKV9iEteLndh6SehAHTrKBFSVVtJwth
 KKlKhaOx6Po1sldGejI+Eglv0Uw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> Mark Brown <broonie@kernel.org> hat am 29. September 2014 um 19:13
> geschrieben:
>
> > > This really needs a comment to explain what on earth is going on here -
> > > the whole thing with writing the same thing twice with two delays is
> > > more than a little odd. It looks like the driver is trying to busy wait
> > > in cases where the change happens quickly but the comments about "fast"
> > > and "normal" mode make this unclear.
>
> > The regulator driver polls for the DC_OK bit in the power status register.
>
> > Quote for reference manual (p. 935): "High when switching DC-DC
> > converter control loop has stabilized after a voltage target change."
>
> > The two loops comes from the different regulator modes
> > (REGULATOR_MODE_FAST, REGULATOR_MODE_NORMAL).
>
> > In REGULATOR_MODE_FAST the voltage steping is disabled and changing
> > voltage should be fast. In REGULATOR_MODE_NORMAL voltage steping is
> > enabled and it's take a while for reaching the target voltage.
>
> I don't think you've fully understood what the different modes mean
> here, that's not normally how a buck convertor works. The different
> modes would typically control the ability of the regulator to respond
> quickly to changes in load without drifting off regulation, fast mode
> makes the regulator less efficient but more responsive to load changes
> (probably marginally with modern regulators). It should have relatively
> little to do with the ability to ramp the voltage and certainly not on
> the scale there.
>

thanks for your explanation.

Is it better to let the core handles the ramp delay instead of set_voltage_sel
with a busy wait?

I've found that polling DC_OK is only reliable for increasing voltages. So i
think about defining ramp delay in the regulator description.

Stefan
