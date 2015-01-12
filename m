Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbbALNy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:54:59 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:34729 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbbALNy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:54:58 -0500
Message-ID: <1421070898.28652.13.camel@mm-sol.com>
Subject: Re: [PATCH] iio: Simplify IIO provider access locking mechanism
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Jan 2015 15:54:58 +0200
In-Reply-To: <54AFFEF9.5080408@metafoo.de>
References: <1420817893-5858-1-git-send-email-iivanov@mm-sol.com>
			 <54AFF6C4.9020306@metafoo.de> <1420818639.28652.5.camel@mm-sol.com>
		 <54AFF9D3.7000007@metafoo.de> <1420820083.28652.7.camel@mm-sol.com>
	 <54AFFEF9.5080408@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.7-fta1.2~trusty 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2015-01-09 at 17:16 +0100, Lars-Peter Clausen wrote:
> On 01/09/2015 05:14 PM, Ivan T. Ivanov wrote:
> > On Fri, 2015-01-09 at 16:54 +0100, Lars-Peter Clausen wrote:
> > > On 01/09/2015 04:50 PM, Ivan T. Ivanov wrote:
> > > > On Fri, 2015-01-09 at 16:41 +0100, Lars-Peter Clausen wrote:
> > > > > On 01/09/2015 04:38 PM, Ivan T. Ivanov wrote:
> > > > > > Instead of checking whether provider module is still
> > > > > > loaded on every access to device just lock module to
> > > > > > memory when client get reference to provider device.
> > > > > > 
> > > > > 
> > > > > This has nothing to do with the module, it's about the device. In the Linux
> > > > > device driver model as device can be unbound at any time and the IIO
> > > > > framework needs to handle this.
> > > > > 
> > > > 
> > > > Hm. Probably i am missing something here, but is this
> > > > still true if we have reference to device structure?
> > > 
> > > Yes, that only prevents the memory of device from being freed. But the
> > > device can still be unbound from the driver.
> > > 
> > > Think of e.g. a USB device that is pulled from the USB connector. Nothing
> > > you can do in software about having the device disappear.
> > > 
> > 
> > Agree, but I think that the patch is still valid. Module
> > have to be pinned in memory as long as there are device
> > driver users.
> 
> No, the idea of the Linux driver model is that you can remove the module of
> a driver at any time, which will unbind the device from the driver. Once you
> reinsert the module the device will be re-bound to the driver.

I will say that device can be unbind at any time and not that module be can
unload at any time. But yes, and I'm not saying the opposite. There are a
lot of examples in kernel, where you can not unload driver if it is used by
another driver. See kernel-haking.tmpl. 

Probably I am still missing something :-)

Ivan

