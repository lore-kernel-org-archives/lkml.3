Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbaFWSYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:24:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60520 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848AbaFWSYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:24:45 -0400
X-Sasl-enc: BmVjHVKFR9PPBZCySryOT1EXTHhGBnoIZwLzIXmeNtU2 1403547884
Date: Mon, 23 Jun 2014 14:24:32 -0400
From: Greg KH <greg@kroah.com>
To: Janne Kanniainen <janne.kanniainen@gmail.com>
Cc: johan@kernel.org, jkosina@suse.cz, cooloney@gmail.com,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v10] leds: USB: HID: Add support for MSI GT683R led panels
Message-ID: <20140623182432.GB30831@kroah.com>
References: <20140623161723.GA20421@kroah.com>
 <1403543808-8228-1-git-send-email-janne.kanniainen@gmail.com>
 <20140623182324.GA30831@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623182324.GA30831@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 02:23:24PM -0400, Greg KH wrote:
> On Mon, Jun 23, 2014 at 08:16:48PM +0300, Janne Kanniainen wrote:
> > +	ret = sysfs_create_group(&led->hdev->dev.kobj, &gt683r_attribute_group);
> > +	if (ret) {
> > +		hid_err(hdev, "failed to create sysfs attributes\n");
> > +		goto fail;
> > +	}
> 
> No, you need to set the attribute group _before_ you call
> led_classdev_register, as that is where the device will be created in
> sysfs.  Surely the other led drivers already do this?  I'm almost afraid
> to go look...

Yes, they do it already, set .dev_attr_group and you should be fine.

thanks,

greg k-h
