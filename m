Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbaIHXcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:32:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43664 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbaIHXc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:32:29 -0400
Date: Mon, 8 Sep 2014 16:32:20 -0700
From: Darren Hart <dvhart@infradead.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eeepc-laptop: remove disp attribute show function
Message-ID: <20140908233219.GA5835@vmdeb7>
References: <1409784805-14190-1-git-send-email-fransklaver@gmail.com>
 <1409814488.5546.63.camel@x220>
 <20140906021757.GA9197@vmdeb7>
 <7288841.ayNsq2yeGO@vostro.rjw.lan>
 <1410210762-2487-1-git-send-email-fransklaver@gmail.com>
 <20140908211627.GA23619@kroah.com>
 <20140908212306.GA22145@gmail.com>
 <20140908214438.GB22145@gmail.com>
 <20140908215723.GA21556@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908215723.GA21556@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 02:57:23PM -0700, Greg Kroah-Hartman wrote:
> On Mon, Sep 08, 2014 at 11:44:38PM +0200, Frans Klaver wrote:
> > On Mon, Sep 08, 2014 at 11:23:06PM +0200, Frans Klaver wrote:
> > > On Mon, Sep 08, 2014 at 02:16:27PM -0700, Greg Kroah-Hartman wrote:
> > > > On Mon, Sep 08, 2014 at 11:12:42PM +0200, Frans Klaver wrote:
> > > > >
> > > > >  EEEPC_CREATE_DEVICE_ATTR(camera, 0644, CM_ASL_CAMERA);
> > > > >  EEEPC_CREATE_DEVICE_ATTR(cardr, 0644, CM_ASL_CARDREADER);
> > > > > -EEEPC_CREATE_DEVICE_ATTR(disp, 0200, CM_ASL_DISPLAYSWITCH);
> > > > > +
> > > > > +static ssize_t store_disp(struct device *dev,
> > > > > +			  struct device_attribute *attr,
> > > > > +			  const char *buf, size_t count)
> > > > > +{
> > > > > +	return store_sys_acpi(dev, CM_ASL_DISPLAYSWITCH, buf, count);
> > > > > +}
> > > > > +
> > > > > +static struct device_attribute dev_attr_disp = {
> > > > > +	.attr = {
> > > > > +		.name = "disp",
> > > > > +		.mode = 0200 },
> > > > > +	.store  = store_disp,
> > > > > +};
> > > > 
> > > > DEVICE_ATTR()?
> > > 
> > > That would make sense, wouldn't it? The only defense I have is that it
> > > isn't used in EEEPC_CREATE_DEVICE_ATTR() either.
> > 
> > I might as well fix that as well, and the fact that the octal
> > permissions are used instead of S_IRUGO and friends. Would you prefer
> > that in a separate patch?

If you're offering to fix it (thanks!), please do any necessary cleanup first
(like switching to S_IRUGO and friends), and then follow up with a DEVICE_ATTR
solution.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
