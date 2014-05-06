Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbaEFQpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:45:17 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:61427 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaEFQpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:45:15 -0400
MIME-Version: 1.0
From: Brian Lilly <brian@crystalfontz.com>
Date: Tue, 6 May 2014 09:44:34 -0700
Message-ID: <CAOk88BLR=nwNGdT++39vLdOt=TwZmemF-trSQPY8AdMN9tKtKQ@mail.gmail.com>
Subject: i.MX28 based system losing eth0 on boot
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Jim Baxter <jim_baxter@mentor.com>, Frank Li <Frank.Li@freescale.com>,
        Fugang Duan <B38611@freescale.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe:

With commit a264b981f2c76e281ef27e7232774bf6c54ec865 we're having eth0
come up, then brought right back down with an MDIO rx timeout moments
after.  Adding back in the removed code keeps the interface alive and
it's working afterward without trouble.  I've tested the re-inserted
code in 3.12, 3.14 without issue on our boards.

Is there something else that can be done to prevent the MDIO timeouts?
We are using basically the same schematic for networking as the
imx28evk.

Any thoughts on how to resolve this?

Thanks,
Brian Lilly
