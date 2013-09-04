Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761675Ab3IDBOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:14:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab3IDBOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:14:04 -0400
Date: Tue, 3 Sep 2013 18:16:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Graeme Gregory <gg@slimlogic.co.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 3/3] extcon: Simplify extcon_dev_register() prototype by
 removing unnecessary parameter
Message-ID: <20130904011640.GA24275@kroah.com>
References: <1378081208-20274-1-git-send-email-cw00.choi@samsung.com>
 <1378081208-20274-4-git-send-email-cw00.choi@samsung.com>
 <20130902004024.GB10709@kroah.com>
 <5223E648.7020207@samsung.com>
 <20130903155744.GA21846@kroah.com>
 <52267BFE.3030106@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52267BFE.3030106@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 09:17:02AM +0900, Chanwoo Choi wrote:
> On 09/04/2013 12:57 AM, Greg KH wrote:
> > On Mon, Sep 02, 2013 at 10:13:44AM +0900, Chanwoo Choi wrote:
> >> Hi Greg,
> >>
> >> On 09/02/2013 09:40 AM, Greg KH wrote:
> >>> On Mon, Sep 02, 2013 at 09:20:08AM +0900, Chanwoo Choi wrote:
> >>>> This patch remove extcon_dev_register()'s second parameter which means
> >>>> the pointer of parent device to simplify prototype of this function.
> >>>
> >>> No, please don't.  You want the parent to be passed in, as the core
> >>> needs it when it is registered with the system, otherwise it will not
> >>> show up in sysfs properly (i.e. you can't set it afterwards.)
> >>
> >> Currently, each extcon driver have allocated memory for extcon device
> >> by using devm_kzalloc() in each extcon device driver.
> > 
> > That seems backwards, the extcon core should be the one doing the
> > allocation, and ownership of the device, like all other subsystem cores
> > do.  That makes the driver logic much simpler, and the lifetime
> > ownership correct (i.e. what happens when a device is unbound from a
> > driver by userspace?  The driver can't control the device memory
> > anymore...)
> > 
> 
> OK,
> The extcon core will control memory allocation instead of extcon device driver
> as following.
> - devm_extcon_allocate_device(struct device *dev)

Huh?  Why do you need a devm allocator?  This is a "real" child device,
just create it with a "extcon_create_device()" or some such call, like
all other busses do?

thanks,

greg k-h
