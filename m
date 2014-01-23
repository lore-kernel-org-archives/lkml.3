Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaAWVKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:10:13 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57315 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaAWVKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:10:10 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1401231502010.891-100000@iolanthe.rowland.org>
References: <CABdoFFeC=S6raty6d6+4sfm4zk7jiF-XnBKgxzTmEzmf6wX3CA@mail.gmail.com>
	<Pine.LNX.4.44L0.1401231502010.891-100000@iolanthe.rowland.org>
Date: Thu, 23 Jan 2014 23:10:09 +0200
Message-ID: <CABdoFFeo7+nwtNGYOQ9gqhQRLmNANCkBG0Ghxu1xFL2ZW0WzvQ@mail.gmail.com>
Subject: Re: [PATCH] staging: usbip: convert usbip-host driver to usb_device_driver
From: Valentina Manea <valentina.manea.m@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Anthony Foiani <anthony.foiani@gmail.com>, devel@driverdev.osuosl.org,
        navinp@cdac.in, linux-usb@vger.kernel.org, ly80toro@cip.cs.fau.de,
        josh@joshtriplett.org, linux-kernel@vger.kernel.org,
        "Linux Kernel Community @ ROSEdu" <firefly@lists.rosedu.org>,
        =?UTF-8?B?VMO8bGluIMSwemVy?= <tulinizer@gmail.com>,
        yacine.belkadi.1@gmail.com, ke42caxa@cip.cs.fau.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you don't bind the interfaces, they will naturally bind to their
> normal drivers on the host.  You probably don't want that to happen.
> (Although, at the moment, I don't see how you can prevent it.)
>

That's true but, the way I see USB/IP general use case, the drivers
from the host the device is physically attached to won't even be
actually used, since the host doesn't use the device. However, I can't
think of a way to enforce this.

> Also, in your patch, stub_probe() calls usb_choose_configuration().
> Shouldn't that be done by the client, since the client now has access
> to the entire device?

I think the normal user just wants things *to work*. Surely, for
advanced user an option for choosing the configuration could be added
but I, personally, don't see it as a necessity at this point.

Thanks,
Valentina
