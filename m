Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790AbaJ2Pcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:32:45 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:48715 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933329AbaJ2Pcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:32:43 -0400
Message-ID: <1414596776.32383.2.camel@mm-sol.com>
Subject: Re: [PATCH v3] thermal: Add QPNP PMIC temperature alarm driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Collins <collinsd@codeaurora.org>
Date: Wed, 29 Oct 2014 17:32:56 +0200
In-Reply-To: <20141027201602.GC6088@developer>
References: <1412178817-20371-1-git-send-email-iivanov@mm-sol.com>
	 <20141027201602.GC6088@developer>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.6-fta3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Eduardo, 

On Mon, 2014-10-27 at 16:16 -0400, Eduardo Valentin wrote:
> Hello Ivan
> 
> 


<snip>

> > 
> > +
> > +static int qpnp_tz_set_mode(struct thermal_zone_device *thermal,
> > +       enum thermal_device_mode mode)
> > +{
> > +       struct qpnp_tm_chip *chip = thermal->devdata;
> > +       int ret;
> > +
> > +       if (mode == chip->mode)
> > +       return 0;
> > +
> > +       if (mode == THERMAL_DEVICE_ENABLED)
> > +       ret = qpnp_tm_shutdown_override(chip, true);
> > +       else
> > +       ret = qpnp_tm_shutdown_override(chip, false);
> 
> 
> Can you please elaborate a little more why you need to switch these when
> mode changes?

My understanding is that PMIC hardware have predefined shutdown sequence in case 
of overheat. In non override mode, hardware itself will take care for shunting
down PMIC, which directly will shutdown also and main CPU's, while when override
is enabled software running on main CPU's, will take care for system shutdown.

> 
> > +
> > +       chip->mode = mode;
> > +
> > +       return ret;
> > +}
> > +
> > 

<snip>

> > +
> > +static int qpnp_tm_probe(struct platform_device *pdev)
> > +{
> > +       struct qpnp_tm_chip *chip;
> > +       struct device_node *node;
> > +       u8 type, subtype;
> > +       int ret, irq, res[2];
> > +
> > 

<snip>

> > +
> > +       chip->tz_dev = thermal_zone_device_register(node->name, TRIP_NUM, 0,
> > +       chip, &qpnp_tz_ops, NULL,
> 
> Have you considered using of-thermal instead of doing your own specific thermal
> zone registration? Having a glance look in this driver, most of the
> operation are covered by of-thermal. Ahy concerns using of-thermal in
> your case?
> 

I just followed implementation found in "armada_thermal", "db8500-thermal", 
"dove_thermal", "imx_thermal", "kirkwood_thermal"...

Will look at of-thermal.

Thank you,
Ivan


