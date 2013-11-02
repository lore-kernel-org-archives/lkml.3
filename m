Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab3KBUk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 16:40:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab3KBUkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 16:40:23 -0400
Date: Sat, 2 Nov 2013 13:40:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: NeilBrown <neilb@suse.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Strange location and name for platform  devices when device-tree
 is used.
Message-ID: <20131102204021.GA13994@kroah.com>
References: <20131101145925.66e22f73@notabene.brown>
 <1383279744.28909.26.camel@pasglop>
 <1383280054.28909.30.camel@pasglop>
 <20131101160329.37f3707b@notabene.brown>
 <1383282516.28909.36.camel@pasglop>
 <20131101204749.GA19662@kroah.com>
 <1383347399.28909.46.camel@pasglop>
 <20131102155824.GG23938@kroah.com>
 <1383423730.4776.16.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383423730.4776.16.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03, 2013 at 07:22:10AM +1100, Benjamin Herrenschmidt wrote:
> On Sat, 2013-11-02 at 08:58 -0700, Greg Kroah-Hartman wrote:
> > Just loop through all the platform devices before registering it to
> > determine if you need to do this, the platform code can do this just
> > fine.  If you try to register a duplicate name with the driver core,
> > odds are it will complain loudly, so don't do that.
> 
> But that loop + registration is racy ... oh well, we might do something
> better with Neil's idea of labels instead.

How is it racy?  Only one platform device should be allowed to be
registered at a time, there is a per-bus lock that should be used to
enforce this, right?

thanks,

greg k-h
