Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3FGKDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:03:25 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:44829 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab3FGKDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:03:23 -0400
Date: Fri, 7 Jun 2013 10:03:22 +0000 (UTC)
From: Paul Walmsley <pwalmsley@nvidia.com>
To: Mark Brown <broonie@kernel.org>
cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Andrew Chew <achew@nvidia.com>,
        Matthew Longnecker <mlongnecker@nvidia.com>
Subject: Re: [PATCH] regulator: core: add regulator_get_linear_step()
In-Reply-To: <20130607095936.GK31367@sirena.org.uk>
Message-ID: <alpine.DEB.2.02.1306071000330.32163@utopia.booyaka.com>
References: <alpine.DEB.2.02.1306070753420.32163@utopia.booyaka.com> <20130607090923.GH31367@sirena.org.uk> <alpine.DEB.2.02.1306070920010.32163@utopia.booyaka.com> <20130607095936.GK31367@sirena.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, 7 Jun 2013, Mark Brown wrote:

> On Fri, Jun 07, 2013 at 09:38:10AM +0000, Paul Walmsley wrote:
> 
> > +static int get_cvb_voltage(struct platform_device *pdev, int c0, int c1,
> > +			   int c2)
> > +{
> > +	struct tegra_dfll *td = dev_get_drvdata(&pdev->dev);
> > +	/* apply only speedo scale: output mv = cvb_mv * v_scale */
> > +	int mv;
> > +
> > +	/* combined: apply voltage scale and round to cvb alignment step */
> > +	mv = DIV_ROUND_CLOSEST(c2 * td->speedo_value, td->cvb_speedo_scale);
> > +	mv = DIV_ROUND_CLOSEST((mv + c1) * td->speedo_value,
> > +			       td->cvb_speedo_scale) + c0;
> > +
> > +	/* XXX Bring back cvb_alignment_uv; put it in the board dfll DT */
> > +	return DIV_ROUND_UP(mv * 1000,
> > +			    td->cvb_voltage_scale * td->vdd_step) *
> > +		td->vdd_step / 1000;
> > +}
> 
> Hrm, right.  So I guess for this the question is why you need the steps
> at all - can't the driver just ask for the voltage it wants with
> whatever tolerance is appropriate (or just specify the maximum tolerable
> voltage if that's better)?  I'm not sure what cvb_voltage_scale is.
> 
> I guess the problem here is that you have to hit some fairly tight
> tolerances on the voltage?

The IP block has an I2C controller embedded in it that autonomously sends 
set-voltage commands (across a range of voltages) to the PMIC.  To enable 
that, the driver must first initialize the IP block with a 
voltage-to-selector table.


- Paul
