Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab3EVVEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:04:00 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51735 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3EVVD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:03:58 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/rgjdbrOuaq3/UnEle/HolG+vfwCQgAqU=
Date: Wed, 22 May 2013 17:02:57 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Simon Baatz <gmbnomis@gmail.com>, David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 11/12] ARM: kirkwood: remove redundant DT board files
Message-ID: <20130522210257.GM31290@titan.lakedaemon.net>
References: <1367854420-8006-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369154510-4927-12-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130522203633.GA28394@schnuecks.de>
 <519D30CF.9040904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519D30CF.9040904@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 10:55:43PM +0200, Sebastian Hesselbarth wrote:
> On 05/22/2013 10:36 PM, Simon Baatz wrote:
> >Hi Sebastian,
> >
> >On Tue, May 21, 2013 at 06:41:49PM +0200, Sebastian Hesselbarth wrote:
> >>With DT support for mv643xx_eth, board specific init for some boards now
> >>is unneccessary. Remove those board files, Kconfig entries, and
> >>corresponding entries in kirkwood_defconfig.
> >>
> >>Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
> >>---
> >>Note: board-km_kirkwood.c is also removed, as Valentin Longchamp confirmed
> >>the lock-up is not caused by accessing clock gating registers but rather
> >>non-existent device registers. This will be addressed by dtsi separation
> >>for kirkwood and bobcat SoC variants.
> >>
> >>Changelog:
> >>v3->v4:
> >>- remove more boards that don't require board specific setup
> >>
> ...
> >We still have:
> >
> >static const char * const kirkwood_dt_board_compat[] = {
> >	"globalscale,dreamplug",
> >	"globalscale,guruplug",
> >	"dlink,dns-320",
> >	"dlink,dns-325",
> >	"iom,iconnect",
> >	"raidsonic,ib-nas62x0",
> >	"qnap,ts219",
> >	"seagate,dockstar",
> >	"seagate,goflexnet",
> >	"buffalo,lsxl",
> >	"iom,ix2-200",
> >	"keymile,km_kirkwood",
> >	"lacie,cloudbox",
> >	"lacie,inetspace_v2",
> >	"lacie,netspace_lite_v2",
> >	"lacie,netspace_max_v2",
> >	"lacie,netspace_mini_v2",
> >	"lacie,netspace_v2",
> >	"mpl,cec4",
> >	"netgear,readynas-duo-v2",
> >	"plathome,openblocks-a6",
> >	"usi,topkick",
> >	"zyxel,nsa310",
> >	NULL
> >};
> >
> >in that file. I think it does not make sense that we need to list
> >boards here that can be described fully by DT. When adding such a
> >board in the future, you will still need to adapt board-dt.c.
> 
> True, will remove the redundant compatible strings for v5.
> Actually, if I am not missing something, all compatible strings except
> "marvell,kirkwood" are redundant as long as board.dts append it
> correctly.
> 
> >Should we remove the boards that you removed above here as well and
> >add
> >
> >	"marvell,kirkwood-88f6192",
> >	"marvell,kirkwood-88f6281",
> >	"marvell,kirkwood-88f6282",
> >	"marvell,kirkwood-88f6283",
> >	"marvell,kirkwood-88f6702",
> >	"marvell,kirkwood-98DX4122",
> >
> >or even just state "marvell,kirkwood"?
> 
> I would stick with "marvell,kirkwood" only. This is SoC init code and
> we do not distinguish variants here at all.

Agreed, nice catch Simon.

thx,

Jason.
