Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbaITLY0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 07:24:26 -0400
Received: from mout.gmx.net ([212.227.15.19]:60235 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbaITLYY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 07:24:24 -0400
Date: Sat, 20 Sep 2014 13:23:50 +0200
From: Andreas Werner <wernerandy@gmx.de>
To: kavitha bk <bk.kavitha1@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: eeprom Board Information EEPROM
Message-ID: <20140920112350.GA1720@awedesk.fritz.box>
References: <20140829205639.GA584@awedesk.fritz.box>
 <CACx5bVzvJ-x7EdnGX+AraNBwKaxKNwRVvBwN1-0DNY3O155U5Q@mail.gmail.com>
 <20140902095253.GA693@awedesk.fritz.box>
 <CACx5bVwUaHXOD0NxOiGzEMVQ0HYF2eLXVBL3nu1s=xAemYP9LQ@mail.gmail.com>
 <20140903143415.GA3684@awedesk.fritz.box>
 <CACx5bVxpGW=vb8zXLLJ9ewUOfw3ib0g=YBHUcTAS=vMhZ7NnHg@mail.gmail.com>
 <20140915172255.GA798@awedesk.fritz.box>
 <CACx5bVwHo4AUN8UXarX1ygCr9jddYWnM8A-BCOF9W97FcMLJuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CACx5bVwHo4AUN8UXarX1ygCr9jddYWnM8A-BCOF9W97FcMLJuQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:LwRyhZWe857Z+2Uw0fmmHyT/JG+D88oGuue+dSoycksCS92wlh2
 4Haxqie/rBABnZom8r68DkbMb7NhGn4WZDxUb/SI7POv7Crhzr/w1/f4rX0xIzWFQOENVlq
 pPnZ+7ksD9prHRln29hgdvdHwtetye5tw+oUntTu0sK/3pv5WRt3yGfNWRq6Gv0DfWwHolE
 06QA6TR1WXchik322Botw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 01:14:36PM +0530, kavitha bk wrote:
> On Mon, Sep 15, 2014 at 10:52 PM, Andreas Werner <wernerandy@gmx.de> wrote:
> 
> > On Thu, Sep 04, 2014 at 09:59:53PM +0530, kavitha bk wrote:
> > > On Wed, Sep 3, 2014 at 8:04 PM, Andreas Werner <wernerandy@gmx.de>
> > wrote:
> > >
> > > > Is there a way to access the eeprom data from within another driver?
> > > >
> > > Yes I had to access mac address from eeprom from smsc [ethernet driver]
> > > so I exported a function from  eeprom driver
> > >
> > >
> > > > I have seen in at24 using the memory_accessor struct to allow access
> > e.g.
> > > > from platform driver,
> > > > but this is not want i want.
> > > >
> > > > Current driver sysfs iface:
> > > >         Predefined sections exported (24byte):
> > > >                 - revision
> > > >                 - serialnr
> > > >                 - prod_date
> > > >                 - rep_date
> > > >                 - hw_name
> > > >
> > > >         User memory (232 byte):
> > > >                 - user_eeprom (binary)
> > > >
> > > > This allows the userland to access the predefined data easily through
> > > > sysfs without
> > > > the need to format the eeprom bytes to get the right data.
> > > >
> > > > I also need an interface to have access within another driver e.g. we
> > have
> > > > an ethernet
> > > > driver which needs to read the serialnumber of the board.
> > > >
> > > > How can I do this?
> > > >
> > >
> > >
> > > Easy way is export a function in at24 driver but very bad it is
> > > Best way using memory_accessor.
> > > Explore  memory_accessor
> > >
> > >
> > >
> > >
> > >         struct memory_accessor *mem_acc =
> > driver->access_eeprom->serial_no
> > >
> > >
> > >         if (!mem_acc->read || !mem_acc->write)
> > >                 return -EIO;
> > >
> > >         ret = mem_acc->read(mem_acc, serial_no, offset, len);
> > >         if (ret != len)
> > >                 return -EIO;
> > >
> > >         return 0;
> > >
> > >
> > > > Regards
> > > > Andy
> > > >
> >
> > Hi,
> > i have checked the memory accessor. If i understand it right it is good if
> > I have some platform code.
> > The problem I have is, if I have some x86 system without platform config
> > (we normally have no BSP for x86)
> > the solution cannot work.
> >
> > Just a description of my problem.
> > I have an Ethernet driver which is a driver for a FPGA IP Core. The eth
> > runs at most on x86 systems.
> > Inside the driver i need a interface to the eeprom were I can access the
> > Serialnumber.
> >
> > For me the solution to export a function in the eeprom driver is the best
> > way to do it, isn´t it?
> >
> 
> 
> Yes may be it is appropriate to it this way in your case
> 

Hi,
i have also tried to export a function, but the problem is that the data of the eeprom is stored
in a structure of the eeprom driver, and i do not know how to get a pointer/reference to
this structure to get access from within another driver.

Does anybody of you have another idea how to access eeprom data from within another driver?

Thanks
Andy


> >
> > I hope it is clear what i want.
> >
> > Regards
> > Andy
> >
> >
> >
> >
> >
> > > > On Tue, Sep 02, 2014 at 01:30:52PM +0530, kavitha bk wrote:
> > > > > static ssize_t eeprom_read(struct device *dev,
> > > > >                         struct device_attribute *attr,
> > > > >                         char *buf) {
> > > > >         struct i2c_client *client = to_i2c_client(dev);
> > > > >         int ret = -1,i = 0;
> > > > >         unsigned char sn[256];
> > > > >
> > > > >         sn[0] = 0x00;
> > > > >         sn[1] = 0x00;
> > > > >
> > > > >         ret = i2c_master_send(client, sn, 2);
> > > > >
> > > > >         if(ret == -1)
> > > > >                 pr_info("ERROR: I2C send error\n");
> > > > >
> > > > >         ret = i2c_master_recv(client, sn, 256);
> > > > >         if(ret == -1)
> > > > >                 pr_info("I2C read error\n");
> > > > >
> > > > >
> > > > >         return sprintf(buf, "%s\n", sn);
> > > > > }
> > > > > static DEVICE_ATTR(eeprom, 0644, eeprom_read, NULL);
> > > > >
> > > > >
> > > > >
> > > > > In probe
> > > > >
> > > > >   err = device_create_file(&client->dev,&dev_attr_eeprom);
> > > > >                 if(err < 0) {
> > > > >                         pr_err("%s : failed to device create file\n",
> > > > > __func__);
> > > > >                         goto err_device_create_file_failed;
> > > > >                 }
> > > > >
> > > > >
> > > > >
> > > > > Sample code for reference
> > > > >
> > > > >
> > > > > Kavitha
> > > > >
> > > > >
> > > > >
> > > > >
> > > > > On Tue, Sep 2, 2014 at 3:22 PM, Andreas Werner <wernerandy@gmx.de>
> > > > wrote:
> > > > >
> > > > > > On Mon, Sep 01, 2014 at 01:52:10PM +0530, kavitha bk wrote:
> > > > > > > On Sat, Aug 30, 2014 at 2:26 AM, Andreas Werner <
> > wernerandy@gmx.de>
> > > > > > wrote:
> > > > > > >
> > > > > > > > I have a question regarding a driver for a Board Information
> > > > EEPROM.
> > > > > > > >
> > > > > > > > I want to give our customer easy access to our Board
> > Information
> > > > EEPROM
> > > > > > > > which is an 256byte I2C eeprom.
> > > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > There is a defined structure of information at the beginning
> > of the
> > > > > > eeprom
> > > > > > > > which includes board name, serialnumber, production date,
> > repair
> > > > date
> > > > > > and
> > > > > > > > a eeprom structure ident number.
> > > > > > > >
> > > > > > > > The rest of the eeprom is for user defined settings where
> > customer
> > > > can
> > > > > > > > write
> > > > > > > > any data to.
> > > > > > > >
> > > > > > > > I want to have access to the eeprom without any special to and
> > > > without
> > > > > > > > installing
> > > > > > > > anything just running linux and to a cat/echo to sysfs entries
> > to
> > > > > > > > read/write
> > > > > > > > data to the eeprom.
> > > > > > > >
> > > > > > > > What i want to do is to create sysfs entries for the pre
> > defined
> > > > > > settings
> > > > > > > > and
> > > > > > > > on entrie where customer can access the rest of the eeprom
> > bytes.
> > > > > > > >
> > > > > > > > Is drivers/misc/eeprom the right place to put those kind of
> > driver
> > > > in?
> > > > > > >
> > > > > > >
> > > > > > > Yes You can add here
> > > > > > >
> > > > > > > > Or are
> > > > > > > > there any other options to write those kind of driver?
> > > > > > > >
> > > > > > >
> > > > > > > Which eeprom are you using? You can explore CONFIG_EEPROM_AT24
> > > > driver for
> > > > > > > writing a sys interface
> > > > > > >
> > > > > >
> > > > > > Ok i will check it out.
> > > > > >
> > > > > > Thanks.
> > > > > >
> > > > > > Regards
> > > > > > Andy
> > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > Regards
> > > > > > > > Andy
> > > > > > > > --
> > > > > > > > To unsubscribe from this list: send the line "unsubscribe
> > > > > > linux-kernel" in
> > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > More majordomo info at
> > http://vger.kernel.org/majordomo-info.html
> > > > > > > > Please read the FAQ at  http://www.tux.org/lkml/
> > > > > > > >
> > > > > >
> > > >
> >
