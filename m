Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab3IZP7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:59:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3IZP7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:59:37 -0400
Date: Thu, 26 Sep 2013 08:59:35 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/13] hv: clean up dev_attr usage
Message-ID: <20130926155935.GA30834@kroah.com>
References: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
 <654a20fac822400798f991f33b699018@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <654a20fac822400798f991f33b699018@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 06:42:30PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> > Sent: Friday, September 13, 2013 11:33 AM
> > To: KY Srinivasan; Haiyang Zhang
> > Cc: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
> > Subject: [PATCH 00/13] hv: clean up dev_attr usage
> > 
> > Hi,
> > 
> > Here's a set of 13 patches to get rid of the dev_attrs use in the hv bus
> > code, as it will be going away soon.  It's _way_ bigger than all other
> > conversions I've had to do so far in the kernel, as you were using a
> > "multiplexor" function for all of these files.
> > 
> > So, I've broken it up into individual show/store sysfs functions, and
> > cleaned up a bunch of debug structures that aren't needed and shouldn't
> > be exported to the rest of the kernel.
> > 
> > I've also fixed up some void * usage in the hv core, in patch 07, to
> > make things simpler and not so "magic" when dealing with these pages.
> > If you could review that one closely to ensure I didn't mess anything
> > up, I would appreciate it.
> > 
> > Also, are all of these files really needed for sysfs?  They seem to be
> > all debugging stuff, shouldn't they go into debugfs if you really
> > need/use them anymore?
> > 
> > KY, could you test these out?  I don't have access to a hv system at the
> > moment.  I'll wait for your ack before applying them to any of my trees.
> 
> The patches look good and I tested them. The guest comes up and is functional.
> I did notice though that the pending state appears to be a signed entity now which was not the
> the case  before - I see a negative sign when I cat the client/server pending state.

Which exact file is that?  I didn't change the % modifiers for any of
the data types, or at least I sure shouldn't have, if so, that's a bug
on my side.

Thanks for testing, I'll queue these up, and if you can tell me which
sysfs file is different, I'll verify the code conversion again, but I
just reviewed it and can't seem to find anything.

thanks,

greg k-h
