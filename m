Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbaIZP2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:28:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38019 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbaIZP2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:28:38 -0400
Date: Fri, 26 Sep 2014 08:28:35 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 02/13] PM / Domains: Add DT bindings for power-on/off
 latencies
Message-ID: <20140926152835.GK10233@codeaurora.org>
References: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
 <1411662520-22795-3-git-send-email-geert+renesas@glider.be>
 <CAPDyKFrAv9oyBzX764+CWkOxfN1kN_MddB3ks1q69+TnmnHXuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFrAv9oyBzX764+CWkOxfN1kN_MddB3ks1q69+TnmnHXuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 25 September 2014 18:28, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> > +Optional properties:
> > + - power-on-latency: Power-on latency of the PM domain, in ns,
> > + - power-off-latency: Power-off latency of the PM domain, in ns.
> > +
> >  Example:
> >
> >         power: power-controller@12340000 {
> >                 compatible = "foo,power-controller";
> >                 reg = <0x12340000 0x1000>;
> >                 #power-domain-cells = <1>;
> > +               power-on-latency = <250000>;
> > +               power-off-latency = <250000>;

This assumes every power domain within a power controller has the
same latencies? That isn't always true. This should be an array
of values corresponding to the number of power domains if
#power-domain-cells is 1, or just one value if the cell count is
0.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
