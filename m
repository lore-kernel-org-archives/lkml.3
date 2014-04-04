Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaDDLsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 07:48:51 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:50735 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbaDDLsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 07:48:50 -0400
Date: Fri, 4 Apr 2014 13:48:48 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Inconsistent lock state introduced by ipv6/addrconf change
Message-ID: <20140404114848.GD13354@order.stressinduktion.org>
Mail-Followup-To: Shawn Guo <shawn.guo@freescale.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	"David S. Miller" <davem@davemloft.net>
References: <20140404073455.GB29778@dragon>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140404073455.GB29778@dragon>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Fri, Apr 04, 2014 at 03:34:56PM +0800, Shawn Guo wrote:
> I'm running into an inconsistent lock state warning on the final v3.14
> kernel (-rc8 is good) on Freescale i.MX6 platform with fec driver
> (drivers/net/ethernet/freescale/fec_main.c).  The git bisect points
> the finger to commit c15b1cc (ipv6: move DAD and addrconf_verify
> processing to workqueue).  Reverting the commit does fix the problem
> for me.  The image is built from arch/arm/configs/imx_v6_v7_defconfig.
> 
> The interesting part is the same warning shows up on mainline tree until
> net-next gets merged with commit cd6362b.  That's why Olof's autobooter
> keeps reporting failure on hummingboard and wandboard (both i.MX6 based)
> since v3.14 release [1], but reports success after commit cd6362b.
> 
> We're less concerned by the mainline tree, since the problem disappeared
> now (nice to know why though).  But we do still want to fix it for 3.14
> stable kernel.

The patch which fixes this is already queued up for -stable:

http://patchwork.ozlabs.org/patch/335536/

Sorry for the inconvenience,

  Hannes


