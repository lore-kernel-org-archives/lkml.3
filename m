Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3LFJBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:01:42 -0500
Received: from top.free-electrons.com ([176.31.233.9]:51670 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752727Ab3LFJBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:01:40 -0500
Date: Fri, 6 Dec 2013 10:01:17 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Tejun Heo <tj@kernel.org>
Cc: Olliver Schinagl <oliver+list@schinagl.nl>,
        Oliver Schinagl <oliver@schinagl.nl>, grant.likely@linaro.org,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dev@linux-sunxi.org,
        maxime.ripard@free-electrons.com, ijc@hellion.org.uk,
        hdegoede@redhat.com, Richard Zhu <r65037@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 2/3] ARM: sunxi: Add an ahci-platform compatible AHCI
 driver for the Allwinner SUNXi series of SoCs
Message-ID: <20131206100117.59609a8a@skate>
In-Reply-To: <20131204132312.GH3158@htj.dyndns.org>
References: <1386159055-10264-1-git-send-email-oliver@schinagl.nl>
	<1386159055-10264-3-git-send-email-oliver@schinagl.nl>
	<20131204123708.GD3158@htj.dyndns.org>
	<529F2677.3070208@schinagl.nl>
	<20131204131402.GG3158@htj.dyndns.org>
	<529F2B41.8090009@schinagl.nl>
	<20131204132312.GH3158@htj.dyndns.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Tejun Heo,

On Wed, 4 Dec 2013 08:23:12 -0500, Tejun Heo wrote:

> > But again, point me (for dummies ;) in the right direction and I'll
> > work on it with some help.
> 
> Richard and Shawn recently worked on ahci_imx.  Can you guys please
> talk with each other and figure out what can be done to share as much
> as possible among these new platform-specific drivers?  I'd really
> like to see the common things factored out as much as possible with
> only the actual hardware differences described for each device.

Also, please Cc me on such discussions. I have a pending AHCI platform
driver for another ARM SoC family. It is very similar to ahci_platform,
but needs to do a few more things that are SoC specific (map an
additional register area, and do some SoC-specific stuff with them).

For the moment, we're left with two approaches:

 * Do what Oliver did, where the ahci_<foo> driver will do its own
   SoC-specific stuff, and then will register an additional
   platform_device to trigger the ->probe() of the generic
   ahci_platform driver. I must say I don't really like this solution,
   since it involves having two platform_device registered for the same
   piece of hardware (one platform_device to trigger the ->probe of
   ahci_<foo>, and another one to trigger the ->probe of ahci_platform).

 * Duplicate in ahci_<foo> the (relatively small) amount of code that
   is present in ahci_platform.

>From my point of view, ahci_platform should be turned into a small
"library", that provides an API for ahci_<foo> drivers to 1/ do their
own custom stuff and 2/ do the common ahci_platform stuff.

This way we avoid the registration of two platform_device for the same
piece of hardware, and we avoid the duplication of code.

Want me to propose a RFC for this idea?

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
