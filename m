Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaI3WYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:24:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaI3WYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:24:19 -0400
Date: Tue, 30 Sep 2014 15:24:18 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <groeck@juniper.net>
Cc: Wolfram Sang <wsa@the-dreams.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Rajat Jain <rajatxjain@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>
Subject: Re: [PATCH 0/4] Driver for talking to PLX PEX8xxx PCIe switch over
 I2C
Message-ID: <20140930222418.GA8199@kroah.com>
References: <542A3593.4020108@gmail.com>
 <CAErSpo7BkXDHOZwHzwEu2BN3=39xFwQOyrjgVo6afWKMsnYT=A@mail.gmail.com>
 <20140930211339.GA1264@katana>
 <20140930213306.GA29008@svl-evodev-groeck.juniper.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930213306.GA29008@svl-evodev-groeck.juniper.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 02:35:51PM -0700, Guenter Roeck wrote:
> On Tue, Sep 30, 2014 at 11:13:39PM +0200, Wolfram Sang wrote:
> > 
> > > > Since this is a driver for a PCIe switch, I currently put it under /driver/pci/.
> > > > I'm very open to suggestions for moving this around (Does introducing
> > > > drivers/pci/switch/ seem any better?). Especially I can see that the
> > > > drivers/pci/Kconfig appears under "Bus Options" in the main menu which does not
> > > > look like the right place for this driver. I am looking for suggestions here.
> > > 
> > > Definitely interesting work.  I have no idea where to put it.  It
> > > doesn't have anything to do with PCI core services or structures, so
> > > drivers/pci doesn't seem like the ideal place for it, but I don't have
> > > any better ideas.  If it did end up under drivers/pci, I agree that a
> > > drivers/pci/switch or something similar would probably be better than
> > > having it directly in drivers/pci.
> > > 
> > > Maybe Wolfram or other I2C folks will have an idea.
> > 
> > Hmm, is this a common interface for those switches? Then a directory
> > like drivers/pci/switch could make sense. Otherwise I'd suggest
> > drivers/misc?
> > 
> We had discussed drivers/misc internally, but it didn't seem to be the right
> location to me. After all, it is not a misc driver, but a driver to configure
> a PCIe switch. Not that I have a better idea, though.

drivers/misc is fine with me, I think we already have something like
this for I2C USB devices somewhere in the tree in that location.

thanks,

greg k-h
