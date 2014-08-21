Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaHUXgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 19:36:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44062 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbaHUXgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 19:36:13 -0400
Date: Thu, 21 Aug 2014 16:36:12 -0700 (PDT)
Message-Id: <20140821.163612.282672926741753926.davem@davemloft.net>
To: santosh.shilimkar@ti.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        grant.likely@linaro.org, devicetree@vger.kernel.org, sandeep_n@ti.com
Subject: Re: [PATCH v2 0/3] net: Add Keystone NetCP ethernet driver support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1408115562-22487-1-git-send-email-santosh.shilimkar@ti.com>
References: <1408115562-22487-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Aug 2014 16:36:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Fri, 15 Aug 2014 11:12:39 -0400

> Update version after incorporating David Miller's comment from earlier
> posting [1]. I would like to get these merged for upcoming 3.18 merge
> window if there are no concerns on this version.
> 
> The network coprocessor (NetCP) is a hardware accelerator that processes
> Ethernet packets. NetCP has a gigabit Ethernet (GbE) subsystem with a ethernet
> switch sub-module to send and receive packets. NetCP also includes a packet
> accelerator (PA) module to perform packet classification operations such as
> header matching, and packet modification operations such as checksum
> generation. NetCP can also optionally include a Security Accelerator(SA)
> capable of performing IPSec operations on ingress/egress packets.
>     
> Keystone SoC's also have a 10 Gigabit Ethernet Subsystem (XGbE) which
> includes a 3-port Ethernet switch sub-module capable of 10Gb/s and
> 1Gb/s rates per Ethernet port.
>     
> NetCP driver has a plug-in module architecture where each of the NetCP
> sub-modules exist as a loadable kernel module which plug in to the netcp
> core. These sub-modules are represented as "netcp-devices" in the dts
> bindings. It is mandatory to have the ethernet switch sub-module for
> the ethernet interface to be operational. Any other sub-module like the
> PA is optional.
> 
> Both GBE and XGBE network processors supported using common driver. It
> is also designed to handle future variants of NetCP.

I don't want to see an offload driver that doesn't plug into the existing
generic frameworks for configuration et al.

If no existing facility exists to support what you need, you must work
with the upstream maintainers to design and create one.

It is absolutely no reasonable for every "switch on a chip" driver to
export it's own configuration knob, we need a standard interface all
such drivers will plug into and provide.
