Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3JEPv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 11:51:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57115 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3JEPv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 11:51:57 -0400
Date: Sat, 5 Oct 2013 08:51:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
        "Dilger, Andreas" <andreas.dilger@intel.com>, Greg KH <greg@kroah.com>,
        Peng Tao <tao.peng@emc.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: lustre: why does cfs_get_random_bytes() exist?
Message-ID: <20131005155148.GA20741@infradead.org>
References: <20131003234545.GA19796@thunk.org>
 <CE750681.752DF%andreas.dilger@intel.com>
 <20131005142121.GA22773@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131005142121.GA22773@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 10:21:21AM -0400, Theodore Ts'o wrote:
> add_device_randomness() is called from __dev_open() and
> dev_set_mac_address() in net/core/dev.c.  This is above the ethernet
> and infiniband level.  So as long as it looks like a Linux network
> device, and they are setting the hardware media access address in the
> standard place (dev->dev_addr), it should work fine.
> 
> If they don't then they should fix their drivers to call
> add_device_randomness(); the answer shouldn't be to make every single
> users of the Linux random number generation infrastructure work around
> the problem at the subsystem or file system level!

Besides these points a filesystem isn't the place to work around entropy
pool issues on some obscure platform.  Even if they can't fix it this
way for some reason the workaround still should be in the interaction
of the arch code and the Linux prng infrastructure and not in Lustre.

