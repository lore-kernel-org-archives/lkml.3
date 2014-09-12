Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbaILNtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:49:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:46662 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbaILNto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:49:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,513,1406617200"; 
   d="scan'208";a="598630414"
Date: Fri, 12 Sep 2014 16:49:11 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 6/6] usb: dwc3: host: convey the PHYs to xhci
Message-ID: <20140912134911.GA30816@xps8300>
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1408620803-10464-7-git-send-email-heikki.krogerus@linux.intel.com>
 <5411B93F.3030405@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5411B93F.3030405@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 08:31:19PM +0530, Kishon Vijay Abraham I wrote:
> > @@ -60,22 +59,33 @@ int dwc3_host_init(struct dwc3 *dwc)
> >  		goto err1;
> >  	}
> >  
> > +	phy_create_lookup(dwc->usb2_generic_phy, "usb2-phy",
> > +			  dev_name(&xhci->dev));
> > +	phy_create_lookup(dwc->usb3_generic_phy, "usb3-phy",
> > +			  dev_name(&xhci->dev));
> > +
> 
> I don't think create lookup should be in host init. If it's dt boot, the
> binding should be in dt data or for other boot modes the bindig should be done
> in the board file. This just seems hacky to me.

So are you now suggesting that instead of using platform independent
solution of sharing the PHYs here, you would have us add platform
specific quirks? That would be totally wrong!

And please don't even consider use of board files especially if there
is an option. They are the one thing that we are meant to avoid if
possible! No?


Cheers,

-- 
heikki
