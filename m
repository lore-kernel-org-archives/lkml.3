Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbaFWTcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:32:12 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:38669 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbaFWTcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:32:09 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 23 Jun 2014 21:31:34 +0200
From: Johan Hovold <johan@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Janne Kanniainen <janne.kanniainen@gmail.com>, johan@kernel.org,
        jkosina@suse.cz, cooloney@gmail.com, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v10] leds: USB: HID: Add support for MSI GT683R led panels
Message-ID: <20140623193134.GA15945@localhost>
References: <20140623161723.GA20421@kroah.com>
 <1403543808-8228-1-git-send-email-janne.kanniainen@gmail.com>
 <20140623182324.GA30831@kroah.com>
 <20140623182432.GB30831@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623182432.GB30831@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 02:24:32PM -0400, Greg KH wrote:
> On Mon, Jun 23, 2014 at 02:23:24PM -0400, Greg KH wrote:
> > On Mon, Jun 23, 2014 at 08:16:48PM +0300, Janne Kanniainen wrote:
> > > +	ret = sysfs_create_group(&led->hdev->dev.kobj, &gt683r_attribute_group);
> > > +	if (ret) {
> > > +		hid_err(hdev, "failed to create sysfs attributes\n");
> > > +		goto fail;
> > > +	}
> > 
> > No, you need to set the attribute group _before_ you call
> > led_classdev_register, as that is where the device will be created in
> > sysfs.  Surely the other led drivers already do this?  I'm almost afraid
> > to go look...
> 
> Yes, they do it already, set .dev_attr_group and you should be fine.

But this isn't an attribute of the LEDs but rather of the parent HID
device that is being probed (the led_mode is common to all three LEDs
and thus belongs in the parent device, right?).

Johan
