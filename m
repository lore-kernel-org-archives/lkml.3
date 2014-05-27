Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaE0WC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:02:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaE0WC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:02:56 -0400
Date: Tue, 27 May 2014 15:06:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>
Subject: Re: [char-misc-next 3/3] mei: add WPT second mei interface
Message-ID: <20140527220630.GA7924@kroah.com>
References: <1399969321-6512-1-git-send-email-tomas.winkler@intel.com>
 <1399969321-6512-4-git-send-email-tomas.winkler@intel.com>
 <20140527212207.GB26089@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFFBCDC@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AFFBCDC@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 09:42:19PM +0000, Winkler, Tomas wrote:
> > > +/* PCH devices MEI 2 interface */
> > > +const struct mei_cfg mei_me_pch_2_cfg = {
> > > +	MEI_CFG_PCH_HFS,
> > > +	.mei_id = 1
> > 
> > That's going to be a recipe for disaster.  Have the MEI core allocate
> > the id numbers as things are registered, don't have the individual
> > drivers create their id.
> 
> I'm don't think can ensure the enumeration order.

You should not be relying on the order to get anything right.

> This is per device not per driver configuration structure.
> Each pci device is actually just  another head to one MEI device but heads are not equal the name/id matters
> Yes I assume it looks odd at the first glance, anyhow we are open to any reasonable suggestions 

Just dynamically allocate the numbers like all other subsystems do?

Then userspace can open the device nodes it cares about, it should be
able to somehow tell what device is what somehow, right?  If not, you
are doing something wrong with the interface as you can't rely on minor
numbers.

thanks,

greg k-h
