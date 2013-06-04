Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab3FDRSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:18:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59492 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab3FDRSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:18:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "alexandre.belloni" <alexandre.belloni@free-electrons.com>,
        kernel <kernel@pengutronix.de>, "shawn.guo" <shawn.guo@linaro.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCHv2 1/3] net: phy: prevent linking breakage
Date: Tue, 04 Jun 2013 19:17:59 +0200
Message-ID: <10306449.AbS8Q0UukT@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <CAGVrzcZcVB5+NqLop+ALrX4Jx_SyNatczLt4oNzXr7bjgKMXhg@mail.gmail.com>
References: <1369741403-25315-2-git-send-email-alexandre.belloni@free-electrons.com> <1394174.ONngHnHYKL@wuerfel> <CAGVrzcZcVB5+NqLop+ALrX4Jx_SyNatczLt4oNzXr7bjgKMXhg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:25YlME2cP+DEMIHgnpV3Jv+s1OiSo0wbChZzj4kCIp7
 729cQ2aDdpx5x1Eh5tbCWTF8J1ffYZz37P9tBR5azo3J7JiYHS
 o7MApKXZFUKUR36C4ZAAulHZa4HadnAsqBrn208IE3CXndurH6
 2friQ5Vz3rdwoGtNj+aX+hH5C0C/Jrb9dY0RoskoT93MyXtZVd
 q/cjo1kBpWbt/K8ktUXNuty4CQX2GHfE0ozXp197qi41qUP6J6
 OJMoDM5RYQ9OGb0+ehDP2a/BEQ9yiB2xBUZAacxCqItJSWztiB
 gb2P0H2BxTityh8utICdqw4jan3Bx2psPolv7Q8K69Ltb2FaDn
 g0IF75XY2L29mAKdmQT0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013 17:09:26 Florian Fainelli wrote:
> You would just need to define a stub for your arch_foo_phy_fixup()
> which has a different definition depending on whether CONFIG_PHYLIB is
> defined or not.

Yes, same thing. For a function that is called in only one place,
I would always prefer if(IS_ENABLED()) over a stub though.

> This would be just one function, instead of the whole bunch of stubs
> needed for phylib. Right now its probably 1 vs 3, so it does not make
> that much of a difference but who knows, if we had more phylib stubs
> and forget to update the stubs? (which tends to happen pretty often).
> 
> The size savings are exactly the same in both approaches anyway.

So should we just stick to the current method then and use
if (IS_ENABLED(CONFIG_NET)) for calling the function?

	Arnd
