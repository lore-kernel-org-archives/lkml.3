Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaIIRsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 13:48:24 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:61118 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaIIRsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 13:48:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com, sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH v2 3/8] Documentation: bindings: net: add the Marvell PXA168 Ethernet controller
Date: Tue, 09 Sep 2014 19:47:35 +0200
Message-ID: <2897714.QyEFFDa5hL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140909160136.GA26051@kwain>
References: <1410273848-24663-1-git-send-email-antoine.tenart@free-electrons.com> <3827594.chb831jyvc@wuerfel> <20140909160136.GA26051@kwain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:18ijGtlxyWOmZYoi67QweOj1/OdqVL95+stU7jg50wd
 Oa/oladz7meYO2dHs7QctLeod0zb+X64/b3QHqnVVCcpqG/MWS
 SVZdaDsq2PU62Xr/JlLsUtd2/vFBmtiD+veb6/dy1c05VxzuzU
 fkxcsSXMUWZqx4AgH9pWsjy0R/AKcw5CwCAa93Lu4nrMW7xsq6
 aPykdTYx5/u8x9BNr0wvOSXl8bp1yL5YELXmzkja08iCJ6VYcV
 w55kAPtH/bnyKR9BtZeY0vkK1k2EuFMcFv4xFYT/7jO8zA78Ay
 uHVBU8cfmGGkjgTISf6iWJcSGmR9Q1nn7iQ/3wDAs460KLOXcH
 IN7PsyfVV+37M8/wWhx8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2014 18:01:36 Antoine Tenart wrote:
> 
> On Tue, Sep 09, 2014 at 05:58:12PM +0200, Arnd Bergmann wrote:
> > On Tuesday 09 September 2014 16:44:03 Antoine Tenart wrote:
> > > +- clocks: pointer to the clock for the device.
> > > +- clock-names: should be "MFUCLK".
> > 
> > Clock names are normally not capitalized. Are you able to change
> > that name when providing a binding or make it an anoymous clock?
> > What does MFU stand for anyway?
> 
> Sure. I could have make it an anonymous clock but the name "MFUCLK" was
> already used by the pxa168 Ethernet driver so I didn't wanted to change
> that.

I believe you can just ask for an anonymous clock anyway and get the
first one even if it has a name, but I didn't check.

In any case, we should not just take a clock name in a DT binding
because it happened to be used by platform code. It's easy fix the
platform code when someone makes a mistake there, but very hard to
fix DT strings once there are users relying on a particular convention.

	Arnd
