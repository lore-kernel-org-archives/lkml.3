Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab3LFJTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:19:20 -0500
Received: from top.free-electrons.com ([176.31.233.9]:51823 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752727Ab3LFJTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:19:12 -0500
Date: Fri, 6 Dec 2013 10:18:56 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Oliver Schinagl <oliver@schinagl.nl>
Cc: Tejun Heo <tj@kernel.org>, Olliver Schinagl <oliver+list@schinagl.nl>,
        grant.likely@linaro.org,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dev@linux-sunxi.org,
        maxime.ripard@free-electrons.com, ijc@hellion.org.uk,
        hdegoede@redhat.com, Richard Zhu <r65037@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 2/3] ARM: sunxi: Add an ahci-platform compatible AHCI
 driver for the Allwinner SUNXi series of SoCs
Message-ID: <20131206101856.1864849d@skate>
In-Reply-To: <52A19502.1090409@schinagl.nl>
References: <1386159055-10264-1-git-send-email-oliver@schinagl.nl>
	<1386159055-10264-3-git-send-email-oliver@schinagl.nl>
	<20131204123708.GD3158@htj.dyndns.org>
	<529F2677.3070208@schinagl.nl>
	<20131204131402.GG3158@htj.dyndns.org>
	<529F2B41.8090009@schinagl.nl>
	<20131204132312.GH3158@htj.dyndns.org>
	<20131206100117.59609a8a@skate>
	<52A19502.1090409@schinagl.nl>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Oliver Schinagl,

On Fri, 06 Dec 2013 10:12:34 +0100, Oliver Schinagl wrote:

> >  From my point of view, ahci_platform should be turned into a small
> > "library", that provides an API for ahci_<foo> drivers to 1/ do their
> > own custom stuff and 2/ do the common ahci_platform stuff.
> >
> > This way we avoid the registration of two platform_device for the same
> > piece of hardware, and we avoid the duplication of code.
> >
> > Want me to propose a RFC for this idea?
> I've started to do what sdhci does with their pltfrm driver, assuming 
> that's the right approach. Since i'm only dabbling and not always 100% 
> sure what should or shouldn't be done, it may take a little while, but 
> looks promising from my end ;)

Yes, the approach of shdci_pltfrm is exactly the one I was proposing
here, so it definitely looks like the right direction to me (though my
opinion is not authoritative at all in this area, obviously).

> So is the sdhci-pltfrm approach the correct one? We still have ahci_* 
> drivers, but ahci_platform.c won't be a driver in the sense that it is 
> now anymore.

Yes, seems good. We will still need ahci_<foo> for the various SoC
families, because depending on the SoC, you have different things to do
(take various clocks, or do other SoC-specific configuration). As an
example, the main thing I have to do on the SoC I'm working with is
configuring some memory windows that allow the SATA controller to do
DMA to the DRAM. This configuration is inherently completely specific
to this SoC family, and it wouldn't make sense to have that in an
ahci_platform driver shared by all platforms.

Oliver, can you Cc me on your future patches about this topic, so that
I can test them in the context of the SoC I'm working on?

Thanks!

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
