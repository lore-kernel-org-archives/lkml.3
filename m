Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaAIO6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:58:11 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:48847 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaAIO6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:58:00 -0500
X-Auth-Info: qY6akfapHSDLlqHTWjWqiN+psUex8/JglWw+wTkUf7Y=
Date: Thu, 9 Jan 2014 15:57:53 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Nicolin Chen <Guangyu.Chen@freescale.com>, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, rob@landley.net, mturquette@linaro.org
Subject: Re: [PATCH] ARM: imx6q: Add missing esai_ahb clock to current clock
 tree
Message-ID: <20140109145753.GV20094@book.gsilab.sittig.org>
References: <1389236699-10387-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140109075525.GO6750@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109075525.GO6750@pengutronix.de>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 08:55 +0100, Sascha Hauer wrote:
> 
> [ ... ]
> 
> We have the situation here that a single bit controls two clocks. As
> Shawn mentioned just using two gates on the same bit doesn't work
> properly. Do we need a new basic clock type or expand the common gate
> code somehow?
> This situation happens from time to time and I haven't seen a solution
> for this.

You may want to lookup the following message:

  Date: Tue, 23 Jul 2013 15:14:06 +0200
  From: Gerhard Sittig <gsi@denx.de>
  To: linuxppc-dev@lists.ozlabs.org, Anatolij Gustschin <agust@denx.de>,
	  Mike Turquette <mturquette@linaro.org>,
	  linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
  Cc: [ ... ]
  Subject: Re: [PATCH v3 17/31] clk: mpc512x: introduce COMMON_CLK for MPC512x

  http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/185687.html

The specific situation was for MS-CAN on PowerPC, but it inspired
my outlining an approach to "shared clock gates".  See an example
implementation towards the end of the message with both the
clk-gate.c extension, as well as rather generic example use.

My approach turned out to not be needed, but it might serve as a
starting point for you.  You'd have to add support for static
declaration though, but this should be straight forward.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
