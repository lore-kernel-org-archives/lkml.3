Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaJPJaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:30:09 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.145]:10119 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966AbaJPJaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:30:06 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-6.tower-180.messagelabs.com!1413451793!37122309!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.12.2; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Thu, 16 Oct 2014 11:29:54 +0200
Date: Thu, 16 Oct 2014 12:21:27 +0200
From: Andreas Werner <andreas.werner@men.de>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Andreas Werner <andreas.werner@men.de>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <johannes.thumshirn@men.de>
Subject: Re: [PATCH 1/2] drivers/misc/eeprom/men_eeprod: Introduce MEN Board
 Information EEPROM driver
Message-ID: <20141016102126.GB23256@awelinux>
References: <cover.1413416105.git.andreas.werner@men.de>
 <d169930cfe45d4c05c79f7dd00471d732441529d.1413416105.git.andreas.werner@men.de>
 <20141016085835.GA1273@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141016085835.GA1273@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 10:58:35AM +0200, Wolfram Sang wrote:
> * PGP Signed by an unknown key
> 
> On Thu, Oct 16, 2014 at 10:15:08AM +0200, Andreas Werner wrote:
> > Added driver to support the MEN Board Information EEPROM.
> > The driver exports the production information as read only sysfs
> > entries, as well as a user section which is read/write accessible.
> > 
> > Tested on PPC QorIQ and Intel Atom E680.
> > 
> > Tested-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> > Signed-off-by: Andreas Werner <andreas.werner@men.de>
> 
> I guess this is just a standard EEPROM with a well defined layout?
> Why don't you want to use the standard driver then and parse the thing
> in userspace?
>

Yes it is a standard 256byte eeprom.
I do not want to parse the things in userspace because this EEPROM data
are related to the hardware and i want to give our customer the easiest way
to access the data without installing any tool.

The current state to read the eeprom data is, that customer needs to install a big
environment where the tool is integrated to have access to those kind of simple
data or they have to write their own code.

If our support department get some questions from the customer they always want
to have exact information about the board. Therefore I want to use this driver
and sysfs to get the informations as fast as possible without installing anything.
 
> Consider how bloated the sysfs-ABI might get if every vendor who uses an
> eeprom wants to expose the data this way?
> 

Yes and no. The possible sysfs entries gets bloated if every vendor will do it
like this way, but normally there is just one Board EEPROM on the board, therefore
only one driver gets loaded.

I mean its the same for every i2c device like a temperature sensor, I can also
read it from userspace without any special hwmon driver.

> > +struct eeprom_data {
> > +	uint8_t eeprod_id;
> > +
> > +	uint8_t revision[3];
> > +	uint32_t serialnr;
> > +	uint8_t board_model;
> > +	char hw_name[6];
> > +
> > +	uint8_t reserved;
> > +
> > +	__be16 prod_date;
> > +	__be16 rep_date;
> > +
> > +	uint8_t reserved2[4];
> > +};
> 
> And what if the compiler reorders?

Shit you are right, I will pack it.#

> 
> 
> * Unknown Key
> * 0x14A029B6

Regards
Andy
