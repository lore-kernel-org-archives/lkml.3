Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaJTJM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:12:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbaJTJMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:12:54 -0400
Date: Mon, 20 Oct 2014 17:11:41 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreas Werner <andreas.werner@men.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, johannes.thumshirn@men.de
Subject: Re: [PATCH 1/2] drivers/misc/eeprom/men_eeprod: Introduce MEN Board
 Information EEPROM driver
Message-ID: <20141020091141.GA15332@kroah.com>
References: <cover.1413416105.git.andreas.werner@men.de>
 <d169930cfe45d4c05c79f7dd00471d732441529d.1413416105.git.andreas.werner@men.de>
 <20141016085835.GA1273@katana>
 <20141016102126.GB23256@awelinux>
 <20141016095910.GC1273@katana>
 <20141016114401.GA22506@awelinux>
 <20141020083344.GA523@awelinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020083344.GA523@awelinux>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:33:45AM +0200, Andreas Werner wrote:
> On Thu, Oct 16, 2014 at 01:44:02PM +0200, Andreas Werner wrote:
> > On Thu, Oct 16, 2014 at 11:59:10AM +0200, Wolfram Sang wrote:
> > > * PGP Signed by an unknown key
> > > 
> > > 
> > > > I do not want to parse the things in userspace because this EEPROM data
> > > > are related to the hardware and i want to give our customer the easiest way
> > > > to access the data without installing any tool.
> > > 
> > > I understand that point of view. From an upstream point of view, things
> > > may look different, though.
> > > 
> > 
> > I also understand your point of view :-).
> > Most customers wants just to have a running system without installing anything.
> > And for me an EEPROM is so simple and should not need a complicated way
> > to access it.
> > 
> > > > The current state to read the eeprom data is, that customer needs to install a big
> > > > environment where the tool is integrated to have access to those kind of simple
> > > > data or they have to write their own code.
> > > 
> > > i2cget from i2c-tools? You could do a simple shell script to parse the
> > > data. Or do a board specific hook which reads the data and prints it to
> > > the logfiles...
> > > 
> > 
> > Yes of course there are a lot of possibilities. This was just an example
> > what we currently use and what was developed years ago.
> > 
> > With a driver like this you can also define read only attributes to prevent customer
> > to write or modify the data in the production section. With i2ctools you can just
> > write any data to it you want.
> > 
> > > > > Consider how bloated the sysfs-ABI might get if every vendor who uses an
> > > > > eeprom wants to expose the data this way?
> > > > > 
> > > > 
> > > > Yes and no. The possible sysfs entries gets bloated if every vendor will do it
> > > > like this way, but normally there is just one Board EEPROM on the board, therefore
> > > > only one driver gets loaded.
> > > 
> > > I am not talking about runtime here, I don't care about that. I am
> > > talking about the ABI we create and we have to maintain basically
> > > forever. And with vendor specific configuartion data I have doubts with
> > > that being stable.
> > > 
> > 
> > Ok, but i do not think that we can make a "general" ABI definition for those kind
> > of devices because every vendor will have its own data in the EEPROM which he want
> > to have.
> > 
> > > > I mean its the same for every i2c device like a temperature sensor, I can also
> > > > read it from userspace without any special hwmon driver.
> > > 
> > > These is a HUGE difference. If I read tempX_input, I don't need to care
> > > if the sensor is I2C or SPI or whatever. The kernel abstracts that away.
> > > The files you create are for your I2C EEPROM only. Data gets
> > > "reformatted" and access gets hidden, but nothing is abstracted away.
> > > It would be different if we had a generic convention for "serial_id" or
> > > stuff like that. But as configuration data is highly specific I don't
> > > see this coming.
> > > 
> > 
> > For a standard sysfs interface it is a huge difference yes. At the point
> > of few from the EEPROM device it is a device like a temp sensor which
> > could be different from vendor to vendor.
> > 
> > Regards
> > Andy
> >
> 
> Greg what do you think about that driver as a Maintainer of the sysfs?

I maintain the sysfs core that drivers use, I don't dictate the policy
that those drivers create and send to userspace, that is up to the
maintainer of the subsystem.  There are some basic rules of sysfs (one
value per file), but other than that, please work with the maintainer to
come up with an interface that will work for all types of this device,
not just a one-off interface which does not scale at all, as Wolfram has
pointed out.

> To we have other ways to get those kind of drivers in the mainline kernel?

Yes, work on a common interface that your driver can use, and it can be
accepted.  Why do you not want to do that?

thanks,

greg k-h
