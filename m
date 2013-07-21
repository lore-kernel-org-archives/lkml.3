Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab3GUC7B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 22:59:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3GUC67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 22:58:59 -0400
Date: Sat, 20 Jul 2013 19:59:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, kyungmin.park@samsung.com,
        balbi@ti.com, jg1.han@samsung.com, s.nawrocki@samsung.com,
        kgene.kim@samsung.com, grant.likely@linaro.org, tony@atomide.com,
        arnd@arndb.de, swarren@nvidia.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
Message-ID: <20130721025910.GA23043@kroah.com>
References: <20130720220006.GA7977@kroah.com>
 <Pine.LNX.4.44L0.1307202223430.8250-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1307202223430.8250-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 10:32:26PM -0400, Alan Stern wrote:
> On Sat, 20 Jul 2013, Greg KH wrote:
> 
> > > >>That should be passed using platform data.
> > > >
> > > >Ick, don't pass strings around, pass pointers.  If you have platform
> > > >data you can get to, then put the pointer there, don't use a "name".
> > > 
> > > I don't think I understood you here :-s We wont have phy pointer
> > > when we create the device for the controller no?(it'll be done in
> > > board file). Probably I'm missing something.
> > 
> > Why will you not have that pointer?  You can't rely on the "name" as the
> > device id will not match up, so you should be able to rely on the
> > pointer being in the structure that the board sets up, right?
> > 
> > Don't use names, especially as ids can, and will, change, that is going
> > to cause big problems.  Use pointers, this is C, we are supposed to be
> > doing that :)
> 
> Kishon, I think what Greg means is this:  The name you are using must
> be stored somewhere in a data structure constructed by the board file,
> right?  Or at least, associated with some data structure somehow.  
> Otherwise the platform code wouldn't know which PHY hardware
> corresponded to a particular name.
> 
> Greg's suggestion is that you store the address of that data structure 
> in the platform data instead of storing the name string.  Have the 
> consumer pass the data structure's address when it calls phy_create, 
> instead of passing the name.  Then you don't have to worry about two 
> PHYs accidentally ending up with the same name or any other similar 
> problems.

Close, but the issue is that whatever returns from phy_create() should
then be used, no need to call any "find" functions, as you can just use
the pointer that phy_create() returns.  Much like all other class api
functions in the kernel work.

thanks,

greg k-h
