Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3JWH3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:29:09 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.150]:18907 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870Ab3JWH3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:29:07 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-16.tower-178.messagelabs.com!1382513343!24450265!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 23 Oct 2013 09:29:04 +0200
Date: Wed, 23 Oct 2013 09:29:01 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Guenter Roeck <linux@roeck-us.net>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Michael Buesch <m@bues.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Driver Design Question
Message-ID: <20131023072901.GB24193@jtlinux>
References: <20131022070256.GA5527@jtlinux>
 <52673E08.4070707@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52673E08.4070707@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 23 Oct 2013 07:29:02.0508 (UTC) FILETIME=[8C04B6C0:01CECFC1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 08:10:00PM -0700, Guenter Roeck wrote:
> On 10/22/2013 12:02 AM, Johannes Thumshirn wrote:
> >Hi List,
> >
> >I have a design question concerning a device driver. The device in question is
> >somewhere in between drivers/mfd/timberdale and drivers/ssb. It is mapped
> >connected via PCI and on PCI Bar 0 there is a table describing which
> >"sub-devices" are contained in the FPGA as well as where their Memory and IRQ
> >resources are.
> >
> >Unlike the timberdale driver, there is no static configuration of the FPGA's
> >sub-devices, but their number and kind is variable. But luckily we have unique
> >device-ids for every sub-device, so it is possible to do a PCI/USB like
> >enumeration.
> >
> >In my understanding the MFD API, which timberdale uses, isn't tailored to this
> >Plug'n'Play like behavior. Whereas the I think (virtual) bus concept used by
>
> Not sure if that is true. There is no requirement to declare mfd cells
> statically. As long as the devices don't change after mfd probe, an mfd based
> solution would at least be implementable.

Yes it would be implementable, but would it be a good idea to do so?

>
> However, adding support for new sub-devices might be an issue, as you would
> have to update the mfd driver to add support for each new device (to create its
> mfd cell and platform data), in addition to writing the actual driver.
>

Adding sub-devices could probably be done without changing th mfd driver, as I
have a device-id, which is part o the article number, so I could generate the
string for the modalias in a generic way.

> >SSB is much more suited for this kind of devices. But would it be wise to add a
> >bus only suited to devices manufactured by one vendor, when there is already a
> >API for such kinds of multi function devices?
> >
> Assuming you refer to mfd, isn't that a contradiction ? You just stated that mfd
> doesn't exactly meet your requirements. There is also an API for adding a new bus,
> and it is used quite widely.

Well my requirements probably can be met using the mfd framework, but I'm not
shure if it would be a good design decission then. Or maybe adding a bus would
be a better decission. The thing is, I don't want to make me a maintainence
hell, but have something I ideally don't need to touch a 2nd time once it is
done right.

>
> Question for me would be if the additional overhead for adding a bus outweighs its
> benefits.
>
> >Long story short, which would be the preferred way to implement such a driver? At
> >the point I currently reached I could go in both directions.
> >
> >I'd appreciate any advice I can get on this topic.
> >
>
> I'm adding Greg KH to the thread. Maybe he has some useful advice as the driver core
> maintainer. I have struggled with the question if to add a bus myself, so maybe I can
> get something useful out of it ;).

This really would be great. If you can get an answer as well, we'd have a win
win situation ;).

Thanks a lot for your comments.

       Johannes
