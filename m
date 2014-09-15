Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaIOMIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:08:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:61154 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbaIOMIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:08:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,527,1406617200"; 
   d="scan'208";a="573271893"
Date: Mon, 15 Sep 2014 15:06:54 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 6/6] usb: dwc3: host: convey the PHYs to xhci
Message-ID: <20140915120654.GA31453@xps8300>
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1408620803-10464-7-git-send-email-heikki.krogerus@linux.intel.com>
 <5411B93F.3030405@ti.com>
 <20140912134911.GA30816@xps8300>
 <5412FF2C.5020600@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5412FF2C.5020600@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 07:41:56PM +0530, Kishon Vijay Abraham I wrote:
> >> I don't think create lookup should be in host init. If it's dt boot, the
> >> binding should be in dt data or for other boot modes the bindig should be done
> >> in the board file. This just seems hacky to me.
> > 
> > So are you now suggesting that instead of using platform independent
> > solution of sharing the PHYs here, you would have us add platform
> > specific quirks? That would be totally wrong!
> 
> No. The binding between the controller and the PHY is done in hardware design
> and it would be wrong to create such a binding in drivers/* IMO.

And kernel of course always knows the hardware design when it's being
booted, wrong!

Firstly, don't assume this kind of controllers are always part of some
SoC or chip set. They could easily be on a PCI card for example.
Secondly, don't assume we could tell all the details about the board
based on some identifiers. Fox example, at least with our SoCs we
won't be able to differentiate the boards. And it's not like every
board using the same SoC uses the same USB2 PHY for example. That kind
of things are up to the manufacturers.

By default we have to rely on hardware descriptions like DT and ACPI
tables or being able to runtime detect (ULPI). If those things don't
work, we live without PHY in this case. We add board specific quirks
_only_ in case of exceptions, where we simply have no other way. If
it's possible to avoid them, especially with something as simple as
this, we avoid them!

> > And please don't even consider use of board files especially if there
> > is an option. They are the one thing that we are meant to avoid if
> > possible! No?
> 
> For dt yes, I'm not sure about other modes.
> 
> So in the case of dt boot, I'd prefer giving the binding in dt file than
> anywhere else.

I don't know how dt works, but at least in case of ACPI we still need
to deliver the PHY to xHCI here, even when dwc3 is provided bindings
to a PHY(s).


-- 
heikki
