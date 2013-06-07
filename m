Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3FGSKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:10:18 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:25031 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab3FGSKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:10:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+uid34UTcu32BOEd4Qm3c0PQod3WCsxVY=
Date: Fri, 7 Jun 2013 14:09:41 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: mvebu: Add the i2c-bridge capability to
 the mv64xxx-i2c
Message-ID: <20130607180941.GW23859@titan.lakedaemon.net>
References: <1370619743-15245-1-git-send-email-gregory.clement@free-electrons.com>
 <1370619743-15245-3-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370619743-15245-3-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 05:42:23PM +0200, Gregory CLEMENT wrote:
> The mv64xxx-i2c embedded in the Armada XP have a new feature called
> i2c-bridge. This commit split the i2c information into armada-370.dtsi
> and armada-xp.dtsi. Most of the data remains the same and stay in the
> common file Armada-370-xp.dtsi. With this new feature the size of the
> registers are bigger for Armada XP and for this SoCs we add a new flag
> for the i2c-bridge capability.
> 
> The Device Tree binding documentation is updated accordingly.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt |  6 ++++++
>  arch/arm/boot/dts/armada-370-xp.dtsi                  |  2 --
>  arch/arm/boot/dts/armada-370.dtsi                     |  8 ++++++++
>  arch/arm/boot/dts/armada-xp.dtsi                      | 10 ++++++++++
>  4 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt b/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt
> index f46d928..8ede3e7 100644
> --- a/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt
> +++ b/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt
> @@ -8,6 +8,12 @@ Required properties :
>   - interrupts      : The interrupt number
>   - clock-frequency : Desired I2C bus clock frequency in Hz.
>  
> +Optional  properties :
> +
> +- i2c,i2c-bridge : This flag indicate that the i2c controller have the
> +  Transaction Generator support and we want to use it. Not all the
> +  mv64xxx controller have this feature.

Do you have a list of which controllers definitely do, or definitely
don't?  That would be helpful for folks adding new boards.


> +
>  Examples:

nit. should the example be updated?

thx,

Jason.
