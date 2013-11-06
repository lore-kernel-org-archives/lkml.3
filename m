Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab3KFVR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:17:59 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52387 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab3KFVR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:17:57 -0500
Date: Wed, 6 Nov 2013 13:17:54 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Andrzej Siewior <bigeasy@breakpoint.cc>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 - V2] Introducing Device Tree Overlays
Message-ID: <20131106211754.GA29300@roeck-us.net>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
 <20131106190152.GA8662@breakpoint.cc>
 <20131106193041.GA26796@roeck-us.net>
 <20131106203821.GC8662@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106203821.GC8662@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 09:38:21PM +0100, Sebastian Andrzej Siewior wrote:
> On 06.11.13, Guenter Roeck wrote:
> > At least that is our use case. u-boot doesn't know which cards are going to be
> > inserted at runtime. Even PCIe hotplug itself is insufficient, as the PCIe
> > configuration differs per card, and the cards support a variety of i2c devices
> > as well as other card specific devices such LEDs and multi-function FPGAs.
> 
> So you have your FPGA behind PCIe and you use the DT to describe the
> chips behind i2c? And then you update your FPGA and want update the
> devices in DT without reboot?
> 
No.

We have a variety of boards with different functionality. Some of it is PCIe,
some of it isn't. Those boards can be inserted and removed at runtime.
The connector to those boards includes PCIe interfaces, i2c interfaces,
and other functionality such as power control/status pins and (proprietary)
serdes links.

Functionality on the boards include, but is not limited to, various i2c devices
(eg power sequencers, temperature sensors, ideeproms, other eeproms, SFP/SFP+),
ASICs, FPGAs, PCIe switches, or 10/40/100GE controllers. Not each board has
the same configuration. Some of the i2c devices may be connected directly
to the i2c bus on the connector, some may be connected through an FPGA
on the board. Sometimes PCIe devices are connected directly (if there is only
one), sometimes there is a PCIe switch on the board with devices behind it.
FPGA configuration is not likely to change at runtime, though it would
technically be possible. If there is an FPGA on a board, it is typically
a multi-function FPGA providing such functionality as GPIO pins, LED control,
and i2c master controllers.

We use DT overlays to describe the hardware on those boards and, if necessary,
its configuration. For example, if there is a PCIe switch, the overlay would
describe its memory and bus number configuration.

Guenter
