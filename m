Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3A2Pcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:32:52 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:35183 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab3A2Pcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:32:50 -0500
Date: Tue, 29 Jan 2013 16:32:42 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: davem@davemloft.net, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] net: mvmdio: unmap base register address at driver
 removal
Message-ID: <20130129163242.1df2caf5@skate>
In-Reply-To: <1359473048-26551-2-git-send-email-florian@openwrt.org>
References: <1359473048-26551-1-git-send-email-florian@openwrt.org>
	<1359473048-26551-2-git-send-email-florian@openwrt.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Florian Fainelli,

On Tue, 29 Jan 2013 16:24:04 +0100, Florian Fainelli wrote:
> Fix the driver remove callback to unmap the base register address and
> not leak this mapping after the driver has been removed.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>

What about using devm_request_and_ioremap() instead, in order to get
automatic unmap on error and in the ->remove() path?

But maybe it won't work because this memory range is claimed both by
the MDIO driver and the Ethernet driver itself. In that case, you could
use devm_ioremap().

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
