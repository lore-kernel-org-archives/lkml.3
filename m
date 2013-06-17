Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab3FQXDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:03:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3FQXDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:03:10 -0400
Date: Mon, 17 Jun 2013 16:03:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [GIT PULL] extcon for 3.11
Message-ID: <20130617230309.GB27053@kroah.com>
References: <51BB0EF1.5090203@samsung.com>
 <20130617230119.GA27053@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617230119.GA27053@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 04:01:19PM -0700, Greg KH wrote:
> On Fri, Jun 14, 2013 at 09:39:13PM +0900, Chanwoo Choi wrote:
> > Hi Greg,
> > 
> > First of all, I'm so sorry about previous wrong pull-request.
> > I will be careful and not to make same mistakes
> > 
> > This is extcon-next pull request for 3.11
> > Please pull extcon with following updates.
> > 
> > I combined the patch of small fix and new drivers becasue
> > 3.10-rc version is large.
> > 
> > Best Regards,
> > Chanwoo Choi
> > 
> > The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:
> > 
> >   Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-for-3.11
> > 
> > for you to fetch changes up to f7ae906806279e5b57bfd302b945e1bcdddce95b:
> > 
> >   extcon: Add an API to get extcon device from dt node (2013-06-14 18:36:34 +0900)
> > 
> > ----------------------------------------------------------------
> > Update extcon for 3.11
> > 
> > This patchset modify small fix of extcon core driver and add new extcon
> > driver for Palmas device which is USB tranceiver device. Also, support
> > OF helper API to get the name of extcon device(producer driver) on extcon
> > consumer driver.
> > 
> > Detailed description for patchset:
> > 1. Modify extcon-class driver
> > - Change permission 'state' sysfs entry(rw->r)
> > - Use EXPORT_SYMBOL_GPL for exported functions
> > - Fix bug null pointer when call extcon_unregister_interest
> > 
> > 2. Modify Kconfig of extcon
> > - Change the extcon config type to bool from module. If extcon
> > is built as module and then extcon consumer driver uses API of,
> > extcon, compiler happen "undefined reference to" build error.
> > 
> > 3. Add new extcon driver for Palmas device and OF helper API
> > - Add new extcon drvier for Palmas which is USB tranceiver device
> > - Add OF(Open Firmware) Helper API which is of_extcon_get_extcon_dev()
> >   This helper API get the extcon device name on extcon consumer device.
> > 
> > ----------------------------------------------------------------
> > Chanwoo Choi (1):
> >       extcon: Change permission 'state' sysfs entry (rw -> r)
> > 
> > Graeme Gregory (1):
> >       extcon: Palmas Extcon Driver
> > 
> > Jonghwa Lee (1):
> >       extcon: class: Add NULL pointer checking for removing notifier block.
> > 
> > Kishon Vijay Abraham I (3):
> >       extcon: Kconfig: Make extcon config type as bool
> 
> Why is this change made?  Why can't I have the extcon core as a module?
> What changed to prevent this?

And hint, I know why you did this, and it's not the correct way, please
fix it up properly...

thanks,

greg k-h
