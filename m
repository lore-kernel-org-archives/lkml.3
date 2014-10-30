Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbaJ3Nzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:55:35 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:39472 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758423AbaJ3Nzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:55:32 -0400
Message-ID: <1414677345.12674.1.camel@mm-sol.com>
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
Date: Thu, 30 Oct 2014 15:55:45 +0200
In-Reply-To: <1414596776.32383.2.camel@mm-sol.com>
References: <1412178817-20371-1-git-send-email-iivanov@mm-sol.com>
	 <20141027201602.GC6088@developer> <1414596776.32383.2.camel@mm-sol.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.6-fta3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2014-10-29 at 17:32 +0200, Ivan T. Ivanov wrote:
> 
+
> > > +       chip->tz_dev = thermal_zone_device_register(node->name, TRIP_NUM, 0,
> > > +       chip, &qpnp_tz_ops, NULL,
> > 
> > Have you considered using of-thermal instead of doing your own specific thermal
> > zone registration? Having a glance look in this driver, most of the
> > operation are covered by of-thermal. Ahy concerns using of-thermal in
> > your case?
> > 
> 
> I just followed implementation found in "armada_thermal", "db8500-thermal",
> "dove_thermal", "imx_thermal", "kirkwood_thermal"...
> 
> Will look at of-thermal.
> 

Hm, the 15 drivers, which register its own thermal zone, against 4, which 
use of-thermal registration and one of them is OMAP, which have fallback
to its own zone registration :-). Anyway. I am afraid that if I use just
thermal_zone_of_sensor_register(), driver will lost ability to switch off 
hardware controlled shutdown sequence, which make it useless IMHO.

I don't see how driver can benefits from nice things provided by of-thermal.
There is no colling device associated with PMIC chip, pooling delays are of
no use, device uses interrupt, trip pints are predefined in hardware...

Please advice.

Regards,
Ivan
