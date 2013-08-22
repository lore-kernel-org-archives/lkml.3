Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab3HVP0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 11:26:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3HVP0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 11:26:04 -0400
Date: Thu, 22 Aug 2013 08:27:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: "David S. Miller" <davem@davemloft.net>, Mark Brown <broonie@kernel.org>,
        Nick Bowler <nbowler@elliptictech.com>,
        Grant Likely <grant.likely@secretlab.ca>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] phylib: mdio: handle register/unregister/register
 sequence
Message-ID: <20130822152757.GA23163@kroah.com>
References: <1377174836-10569-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377174836-10569-1-git-send-email-b.brezillon@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 02:33:56PM +0200, Boris BREZILLON wrote:
> Hello,
> 
> This patch is a proposal to support the register/unregister/register
> sequence on a given mdio bus.
> 
> I use the register/unregister/register sequence to add a fallback when the
> of_mdiobus_register (this function calls mdiobus_register with phy_mask
> set to ~0) does not register any phy device (because the device tree does
> not define any phy).
> In this case I call mdiobus_unregister and then call mdiobus_register with
> a phy_mask set to 0 to trigger a full mdio bus scan.
> 
> I'm not sure this is the right way to do it (this is why I added RFC in the
> subject).
> 
> Could someone help me figuring out what I should use to implement my fallback ?
> 
> 1) use the register/unregister/register sequence

That will not work.  Well, you might think it would work, but then
things randomly start breaking later on.  Try it with the
KOBJECT_DELAYED_DESTROY build option in linux-next, and watch things go
"boom" :)

The rule is, you should never register a kobject/struct device that you
have previously unregistered before, as you really don't know if
unregistering has finished or not.

sorry,

greg k-h
