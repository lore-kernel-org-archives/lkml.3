Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab3GXUaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:30:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab3GXU36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:29:58 -0400
Date: Wed, 24 Jul 2013 13:29:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ovsyanikov, Natalia" <natalia.ovsyanikov@intel.com>
Subject: Re: [char-misc-next 2/3] mei: adding sysfs fw_status attribute
Message-ID: <20130724202957.GA14913@kroah.com>
References: <1374680517-30894-1-git-send-email-tomas.winkler@intel.com>
 <1374680517-30894-3-git-send-email-tomas.winkler@intel.com>
 <20130724160008.GA17083@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE738C0@HASMSX106.ger.corp.intel.com>
 <20130724162605.GA9700@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE73993@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AE73993@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 06:04:33PM +0000, Winkler, Tomas wrote:
> 
> 
> > >
> > > Just to make sure, is this what you're suggesting ?
> > >
> > > device->groups = mei_attr_groups
> > > mei_misc_device.parent = device;
> > > ret = misc_register(&mei_misc_device);
> > 
> > Yes, that should work.  If not, please let me know, the code underwent some
> > changes in 3.11-rc2.
> 
> I don' t see the file being created.
> Not sure if the  misc_register setup the parent sysfs as well.

Oops, wait, the parent is already registered, that's not going to work,
you want to create the files for the device itself that you are
creating, so set the ->groups field for that device.

sorry about that.

greg k-h
