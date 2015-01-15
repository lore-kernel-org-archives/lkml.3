Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbbAOPTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:19:03 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:45008 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbbAOPTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:19:00 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH] e100: Don't enable WoL by default on Toshiba devices
Date: Thu, 15 Jan 2015 16:18:07 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: David Miller <davem@davemloft.net>, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1415832445-9524-1-git-send-email-linux@rainbow-software.org> <201501151440.32159.linux@rainbow-software.org> <1421333621.2632.19.camel@jtkirshe-mobl>
In-Reply-To: <1421333621.2632.19.camel@jtkirshe-mobl>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201501151618.07434.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2015, Jeff Kirsher wrote:
> On Thu, 2015-01-15 at 14:40 +0100, Ondrej Zary wrote:
> > On Thursday 13 November 2014, Jeff Kirsher wrote:
> > > On Wed, 2014-11-12 at 18:18 -0500, David Miller wrote:
> > > > From: Ondrej Zary <linux@rainbow-software.org>
> > > > Date: Wed, 12 Nov 2014 23:47:25 +0100
> > > >
> > > > > Enabling WoL on some Toshiba laptops (such as Portege R100)
> >
> > causes
> >
> > > > > battery drain after shutdown (WoL is active even on battery).
> >
> > These
> >
> > > > > laptops have the WoL bit set in EEPROM ID, causing e100 driver
> >
> > to
> >
> > > > > enable WoL by default.
> > > > >
> > > > > Check subsystem vendor ID and if it's Toshiba, don't enable WoL
> >
> > by
> >
> > > > > default from EEPROM settings.
> > > > >
> > > > > Fixes
> >
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/110784
> >
> > > > > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > > >
> > > > Jeff, are you gonna pick this up?
> > >
> > > Yes, sorry I did not catch it earlier.
> >
> > What happened to this patch? I don't see it in net.git or
> > net-next.git
> > (checked both davem's and jkirsher's)
>
> Sorry, I thought I had replied with a NAK on this patch after further
> review of the changes.
>
> We don't fix BIOS issues in the driver especially regarding feature
> enablement like WoL.  We would end up with dozens of these kinds of fixes
> if we to allow this.
>
> You should go back to the OEM and ask for a BIOS update to resolve this or
> configure udev so that ethtool disables WoL.

This is not a BIOS bug. When the machine is powered off in BIOS (or GRUB), 
everything is OK.

The bug is that e100 driver enables WoL based on some bit in EEPROM that 
happens to be set on at least some Toshiba laptops and user has no way to 
change it. Windows driver does not do this. Other Linux ethernet drivers 
don't do this. When user wants WoL, (s)he enables it in BIOS and OS. Maybe 
this (mis)feature should be removed from the driver.

-- 
Ondrej Zary
