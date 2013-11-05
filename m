Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab3KEWWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 17:22:41 -0500
Received: from mic92-1-81-57-185-249.fbx.proxad.net ([81.57.185.249]:52499
	"EHLO smtp.natisbad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab3KEWWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 17:22:39 -0500
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Nov 2013 17:22:38 EST
From: arno@natisbad.org (Arnaud Ebalard)
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] net: mv643xx_eth: Add missing phy_addr_set in DT mode
References: <1383611239-14556-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-PGP-Key-URL: http://natisbad.org/arno@natisbad.org.asc
X-Fingerprint: D3A5 B68A 839B 38A5 815A 781B B77C 0748 A7AE 341B
X-Hashcash: 1:20:131105:benh@kernel.crashing.org::agJrN8QihE+CoSm9:00000000000000000000000000000000000000MWR
X-Hashcash: 1:20:131105:buytenh@wantstofly.org::ZokKdJrZpnhEXFFO:0000000000000000000000000000000000000000GX6
X-Hashcash: 1:20:131105:andrew@lunn.ch::z6ZU++zYsesjvI9e:0000vTT
X-Hashcash: 1:20:131105:jason@lakedaemon.net::/eflLfEJw7F2vw/U:0000000000000000000000000000000000000000019iU
X-Hashcash: 1:20:131105:linux-kernel@vger.kernel.org::HAKJfDNr2vv/fwQp:0000000000000000000000000000000002ONP
X-Hashcash: 1:20:131105:netdev@vger.kernel.org::vH65ISStbch+TQSE:0000000000000000000000000000000000000002vyr
X-Hashcash: 1:20:131105:linux-arm-kernel@lists.infradead.org::mTY852NkYla9PqOy:000000000000000000000000023EI
X-Hashcash: 1:20:131105:sebastian.hesselbarth@gmail.com::dA76kZCK9kPigF0Z:0000000000000000000000000000002H6t
X-Hashcash: 1:20:131105:linuxppc-dev@lists.ozlabs.org::VQ8UeDyew4fPT6ay:000000000000000000000000000000005BfB
X-Hashcash: 1:20:131105:davem@davemloft.net::HnL8HGptVxujCSwe:0000000000000000000000000000000000000000004KOm
X-Hashcash: 1:20:131105:jgunthorpe@obsidianresearch.com::fZt2IEub2jrKt5RB:0000000000000000000000000000003qkx
Date: Tue, 05 Nov 2013 23:12:00 +0100
In-Reply-To: <1383611239-14556-1-git-send-email-jgunthorpe@obsidianresearch.com>
	(Jason Gunthorpe's message of "Mon, 4 Nov 2013 17:27:19 -0700")
Message-ID: <87sivacxcf.fsf@natisbad.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

Jason Gunthorpe <jgunthorpe@obsidianresearch.com> writes:

> Commit cc9d4598 'net: mv643xx_eth: use of_phy_connect if phy_node
> present' made the call to phy_scan optional, if the DT has a link to
> the phy node.
>
> However phy_scan has the side effect of calling phy_addr_set, which
> writes the phy MDIO address to the ethernet controller. If phy_addr_set
> is not called, and the bootloader has not set the correct address then
> the driver will fail to function.

Thanks *a lot* for fixing this one! I had the issue on my ReadyNAS 102
(Armada 370 based) which I had put on a todo list and temporarily
workarounded by including a 'ping whatever' call in my u-boot env in
order to force it to do the init. Without it, I was unable to properly
use the interface. With your fix, after multiple reboots to test it,
everything works as expected. So, FWIW: 

Tested-by: Arnaud Ebalard <arno@natisbad.org>

Cheers,

a+
