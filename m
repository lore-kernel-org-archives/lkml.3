Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965674Ab3HHOBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:01:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54257 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965327Ab3HHOBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 10:01:52 -0400
Message-ID: <1375970318.4276.52.camel@weser.hi.pengutronix.de>
Subject: Re: [PATCH 2/6] ARM: Tegra: Add CPU's OPPs for using cpufreq-cpu0
 driver
From: Lucas Stach <l.stach@pengutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linaro-kernel@lists.linaro.org, swarren@nvidia.com,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>, linux-pm@vger.kernel.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, rjw@sisk.pl,
        Rob Herring <rob.herring@calxeda.com>, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 08 Aug 2013 15:58:38 +0200
In-Reply-To: <52029811.9080704@wwwdotorg.org>
References: <cover.1375886595.git.viresh.kumar@linaro.org>
	 <d4cd498d9b63d761039b025216e65278dc8e0e37.1375886595.git.viresh.kumar@linaro.org>
	 <52028719.8070908@wwwdotorg.org>
	 <CAKohpo=MpOyMGFTGeZWmoCRwmZ7+nQtP_yCGokPanEVYL0xbMw@mail.gmail.com>
	 <52029811.9080704@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 07.08.2013, 12:55 -0600 schrieb Stephen Warren:
> On 08/07/2013 12:06 PM, Viresh Kumar wrote:
> > On 7 August 2013 23:12, Stephen Warren <swarren@wwwdotorg.org> wrote:
> >> On 08/07/2013 08:46 AM, Viresh Kumar wrote:
> >>> cpufreq-cpu0 driver needs OPPs to be present in DT which can be probed by it to
> >>> get frequency table. This patch adds OPPs and clock-latency to tegra cpu0 node
> >>> for multiple SoCs.
> >>>
> >>> Voltage levels aren't used until now for tegra and so a flat value which would
> >>> eventually be ignored is used to represent voltage.
> >>
> >> This patch is problematic w.r.t. DT being an ABI.
> > 
> > :(
> > 
> >> We can certainly add new optional properties to a DT binding that enable
> >> new features. However, a new version of a binding can't require new
> >> properties to exist that didn't before, since that means that old DTs
> >> won't work with new kernels that require the new properties.
> > 
> > To be honest I didn't get it completely. You meant operating-points
> > wasn't present before? Its here:
> > 
> > Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> > Documentation/devicetree/bindings/power/opp.txt
> > 
> > Or you meant, Tegra never required voltage levels and we are getting
> > them in here.
> 
> The current Tegra *.dts files do not contain this property. The current
> Tegra *.dts files must continue to work without modification in future
> kernels.
> 
> >> As such, I believe we do need some Tegra-specific piece of code that
> >> defines these OPP tables in the kernel, so that the operating-points
> >> property is not needed.
> > 
> > Generic cpufreq driver depends on OPP library and so somebody has
> > to provide them. Now you can do it by calling opp_add() for each OPP
> > you have or otherwise.
> 
> Sure. That's what the Tegra-specific cpufreq driver should do. It should
> be the top-level cpufreq driver. If parts of the code can be implemented
> by library functions or a core parameterizable driver, then presumably
> the Tegra driver would simply exist to provide those parameters and/or
> callback functions to the generic driver.
> 
> > Btw, you must have some specific voltage level for each freq, we can
> > get them here..
> 
> Yes, I'm sure we do, but I have no idea what they are:-( It may even be
> board-specific or SoC-SKU-specific. I think we should defer this aspect
> for now.

>From what I learned those voltage levels are dependent on both the
Speedo and the process ID of the specific Tegra processor. So you really
get a two dimensional mapping table instead of a single OPP.
Also you can not scale the CPU voltage on it's own, but have to make
sure the core voltage isn't too far away from. Then core voltage also
depends on the operating states of engines like GR2D or even display.

Regards,
Lucas
-- 
Pengutronix e.K.                           | Lucas Stach                 |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

