Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab3EXRZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 13:25:25 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:42448 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab3EXRZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 13:25:16 -0400
Message-ID: <519FA277.3010802@gmail.com>
Date: Fri, 24 May 2013 19:25:11 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH 2/2] net: mv643xx_eth: proper initialization for Kirkwood
 SoCs
References: <1369253042-15082-2-git-send-email-sebastian.hesselbarth@gmail.com> <20130522201607.GA18823@obsidianresearch.com> <20130523160111.GP31290@titan.lakedaemon.net> <20130523171112.GB31281@obsidianresearch.com> <20130523172339.GQ31290@titan.lakedaemon.net> <20130523175357.GB2821@obsidianresearch.com> <20130523184028.GU31290@titan.lakedaemon.net> <519E9ADA.3040204@gmail.com> <CACRpkdbsicPkPAiaQCOg2mQF2Ce2dg_K=BKqqx=FCdAH7Y+QBg@mail.gmail.com> <20130524170125.GX31290@titan.lakedaemon.net> <20130524171300.GD18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130524171300.GD18614@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 07:13 PM, Russell King - ARM Linux wrote:
> Do you really want that on ARM?  Given the fiasco with the location of
> the registers, are you sure you want to place more trust in that
> direction?  Does it give you a warm fuzzy feeling to know that you
> might have to work out some way to patch vendor supplied bytecode?

Don't get me wrong. I want mv643xx_eth DT or even platform_data to
evolve to a fully self configured driver not depending on proper u-boot
setup at all.

But I don't want to go that road now and I wonder if it might be safer
for us (and PPC guys) if we start mv643xx_eth over from scratch one day.

For this patch set, I want a basic DT binding that works. Patching the
driver to play with kirkwood loosing the MAC and other important
registers is not my main concern here. If clearing that one bit doesn't
help for all kirkwood boards, I'd rather leave the non-gating
workaround.

mv643xx_eth not knowing DT for ARM is stalling last important bits for
Orion SoCs. I want this to go in first as with David another maintainer
is involved.

Sebastian
