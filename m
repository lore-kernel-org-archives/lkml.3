Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab3G2WiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:38:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab3G2WiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:38:06 -0400
Date: Mon, 29 Jul 2013 15:38:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ovsyanikov, Natalia" <natalia.ovsyanikov@intel.com>
Subject: Re: [char-misc-next 2/3] mei: adding sysfs fw_status attribute
Message-ID: <20130729223805.GA9677@kroah.com>
References: <1374680517-30894-1-git-send-email-tomas.winkler@intel.com>
 <1374680517-30894-3-git-send-email-tomas.winkler@intel.com>
 <20130724160008.GA17083@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE738C0@HASMSX106.ger.corp.intel.com>
 <20130724162605.GA9700@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE73993@HASMSX106.ger.corp.intel.com>
 <20130724202957.GA14913@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE76B1B@HASMSX106.ger.corp.intel.com>
 <20130728153155.GA6781@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE77A4E@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AE77A4E@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 10:27:06PM +0000, Winkler, Tomas wrote:
> 
> > 
> > > > >
> > > > >
> > > > > > >
> > > > > > > Just to make sure, is this what you're suggesting ?
> > > > > > >
> > > > > > > device->groups = mei_attr_groups
> > > > > > > mei_misc_device.parent = device; ret =
> > > > > > > misc_register(&mei_misc_device);
> > > > > >
> > > > > > Yes, that should work.  If not, please let me know, the code
> > > > > > underwent some changes in 3.11-rc2.
> > > > >
> > > > > I don' t see the file being created.
> > > > > Not sure if the  misc_register setup the parent sysfs as well.
> > > >
> > > > Oops, wait, the parent is already registered, that's not going to
> > > > work, you want to create the files for the device itself that you
> > > > are creating, so set the -
> > > > >groups field for that device.
> > > >
> > > > sorry about that.
> > >
> > > So is this okay to go as  is?
> > 
> > What is "this"?
> 
> The intentions was to create the sysfs  on a  parent pci device, and
> these are already created .

You can't create attributes on a device you do not "own", that will be
racy and prone to cause big problems (your callback will not with the
"right" device usually, as your parent might not "be" a pci device in
the future...)

> The only reason I wanted do it here as this is true for any parent pci
> device we support currently that registers with mei.
> 
> Either this code ode is still confusing because  I'm  doing something
> wrong here or  your mind Is set on fixing this particular user space
> race issue.

Probably both...

Either way, you can't create sysfs files in a racy way, I'm going
through the whole kernel tree to clean them all up, I'm not going to add
new race conditions today that I need to fix up tomorrow, my patch count
is high enough as it is :)

thanks,

greg k-h
