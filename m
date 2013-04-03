Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762735Ab3DCO4C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:56:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60173 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760603Ab3DCOz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:55:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: balbi@ti.com
Subject: Re: [PATCH v5 2/6] usb: phy: omap-usb2: use the new generic PHY framework
Date: Wed, 3 Apr 2013 14:55:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Kishon Vijay Abraham I <kishon@ti.com>, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, swarren@wwwdotorg.org,
        sylvester.nawrocki@gmail.com, rob@landley.net, netdev@vger.kernel.org,
        davem@davemloft.net, cesarb@cesarb.net, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        b-cousson@ti.com, linux@arm.linux.org.uk, eballetbo@gmail.com,
        javier@dowhile0.org, mchehab@redhat.com, santosh.shilimkar@ti.com,
        broonie@opensource.wolfsonmicro.com, swarren@nvidia.com,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
References: <1364993634-6378-1-git-send-email-kishon@ti.com> <1364993634-6378-3-git-send-email-kishon@ti.com> <20130403134827.GF14680@arwen.pp.htv.fi>
In-Reply-To: <20130403134827.GF14680@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304031455.47864.arnd@arndb.de>
X-Provags-ID: V02:K0:x9k12m/+8mPlo/8nbFSqf40fqn/79WcVMzpULHw7nx4
 hX2Yrjoh8V4BvJqpmnWzx/Zr+gEY0u2wS3w4Afg25BmCkK284x
 gMO5cHS3FBXchjbohkIZ0L0ICM8IYKXd4bhP57WzJ4Z4Rzc0cg
 9Dt7IwzNthvq/kANEWKLuII3mwctcPjPWSYYUgxihD1dTGuBQ+
 Ud4gnXdnz7p5uw+nV8+qHeBSl/h+TPJIS8xiis/xZGwre7dexu
 fC/rvAclUBy71hvVHxhv4KDucp5G+EiU5+Xj02IM3Oqng7NjPO
 yj83oivW+BsRKr0IOH36F+IDgYi++iO28RYEGriZwsKjvLk3RE
 PKcNrMhHdN0YpMNDfvlc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 April 2013, Felipe Balbi wrote:
> const ? Maybe provide a:
> 
> #define DEFINE_PHY_OPS(name)    \
> const struct phy_ops #name_phy_ops = {
> 
> macro ? This will force people to add the const keyword :-)

Forcing people to use const structures is good, but I think it would be
better without the macro, just by marking the argument in 
devm_phy_create() as const.

	Arnd
