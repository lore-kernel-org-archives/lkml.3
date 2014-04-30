Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965114AbaD3Tow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:44:52 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:48897 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932186AbaD3Tou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:44:50 -0400
Date: Wed, 30 Apr 2014 13:44:37 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/15] ARM: dts: kirkwood: consolidate common pinctrl
 settings
Message-ID: <20140430194437.GB17365@obsidianresearch.com>
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1398862602-29595-8-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140430164236.GC12944@obsidianresearch.com>
 <5361517D.8000106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5361517D.8000106@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 09:39:41PM +0200, Sebastian Hesselbarth wrote:
> On 04/30/2014 06:42 PM, Jason Gunthorpe wrote:
> > On Wed, Apr 30, 2014 at 02:56:34PM +0200, Sebastian Hesselbarth wrote:
> >> All SoCs have the same pinctrl setting for NAND, UART0/1, SPI, TWSI0,
> >> and GBE1. Move it to the common pinctrl node that we now have.

> Yes, there are already some boards (e.g. t5325 with spi0) overwriting
> pinctrl settings instead of overwriting the pinctrl-0 property. I
> thought, I keep this behavior and note it above each pinctrl node in
> some of the following patches.

That all makes sense, I think the commit message just seemed to say
something else.

Maybe more like:

NAND and TWSI0 have only one valid pin control choice on Kirkwood,
move those definitions into the common dtsi.

For UART0/1 and SPI, which have two choices, move the definition that
is used in the majority of the board files into the common dtsi.
Board files that are different will override.

Regards,
Jason
