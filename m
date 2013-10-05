Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab3JEOVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 10:21:30 -0400
Received: from imap.thunk.org ([74.207.234.97]:42395 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab3JEOV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 10:21:28 -0400
Date: Sat, 5 Oct 2013 10:21:21 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Cc: Greg KH <greg@kroah.com>, Peng Tao <tao.peng@emc.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: lustre: why does cfs_get_random_bytes() exist?
Message-ID: <20131005142121.GA22773@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"Dilger, Andreas" <andreas.dilger@intel.com>,
	Greg KH <greg@kroah.com>, Peng Tao <tao.peng@emc.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20131003234545.GA19796@thunk.org>
 <CE750681.752DF%andreas.dilger@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE750681.752DF%andreas.dilger@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 06:10:54AM +0000, Dilger, Andreas wrote:
> >With modern kernels, the /dev/random driver has the
> >add_device_randomness() interface which is used to mix in
> >personalization information, which includes the network MAC address.
> >So that particular concern should be covered without the hack of
> >mixing in cfs_rand().
> 
> I think that depends on the network driver.  The Cray systems have some
> very strange networking hardware that is beyond our control - definitely
> not ethernet or Infiniband.

add_device_randomness() is called from __dev_open() and
dev_set_mac_address() in net/core/dev.c.  This is above the ethernet
and infiniband level.  So as long as it looks like a Linux network
device, and they are setting the hardware media access address in the
standard place (dev->dev_addr), it should work fine.

If they don't then they should fix their drivers to call
add_device_randomness(); the answer shouldn't be to make every single
users of the Linux random number generation infrastructure work around
the problem at the subsystem or file system level!

						- Ted
