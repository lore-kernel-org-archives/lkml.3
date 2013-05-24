Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047Ab3EXHoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 03:44:38 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:28827 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759970Ab3EXHog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 03:44:36 -0400
Date: Fri, 24 May 2013 09:44:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: anish singh <anish198519851985@gmail.com>
Cc: Mylene Josserand <Mylene.Josserand@navocap.com>,
        kernelnewbies <kernelnewbies@kernelnewbies.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: [I2C] informations + advice about messages handling
Message-ID: <20130524094407.61d0ec42@endymion.delvare>
In-Reply-To: <CAK7N6vpg6QUAKODKO2Msr4+GTASLDpA2cG1teQV3yiwt7D4SSw@mail.gmail.com>
References: <CA78C307B8F06747967D122FC656B153986448@SERVEUR0.nvp.local>
	<CAK7N6vpg6QUAKODKO2Msr4+GTASLDpA2cG1teQV3yiwt7D4SSw@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anish, Mylène,

On Fri, 24 May 2013 12:52:40 +0530, anish singh wrote:
> On Fri, May 24, 2013 at 12:41 PM, Mylene Josserand
> <Mylene.Josserand@navocap.com> wrote:
> > I have read that this function "i2c_smbus_write_byte_data" uses
> > "i2c_smbus_xfer" which uses "i2c_lock_adapter".
> > In this function, there is a mutex so I thought that it will handle it
> > but it says "Get exclusive access to an I2C bus segment". What is
> > exactly an I2C segment ? Is it the device we are talking about ? Or is
> > it the use of the i2c bus ?
> Don't know what you are referring here.

In the most simple case, your I2C bus has a single segment so "segment"
or "bus" mean the same thing.

It only starts mattering when I2C bus multiplexing comes into play.
Then your bus is split into segments, with one segment (trunk) between
the master (controller) and the multiplexer, and one or more segments
(branches) hanging off the multiplexer.

Take look at
https://i2c.wiki.kernel.org/index.php/I2C_bus_multiplexing
for a sample topology.

But anyway the comment in front of i2c_lock_adapter() is somewhat
misleading. If you read the code you'll see that it always locks the
whole bus tree, because it uses the root segment's mutex.

> > I will certainly have to create an i2c driver and I would like to know
> > if this "collision" handling (if it is handled) is done in old kernel
> > (2.6.32) or is it handled only in new kernel versions ?
> AFAIK collision handling and detection was not supported till now
> in linux kernel until recently but I think this patch is doing that.
> I may be wrong but I didn't see collision handling in earlier linux
> kernels.
> http://thread.gmane.org/gmane.linux.kernel/1410276

This is for a specific case. The general case is handled by the
per-adapter mutex for years now. 2.6.32 should be just fine in this
respect.

> > If you have any documentation on how the i2c messages are handled in
> > case of different devices uses, it will help me a lot ! I will search in
> > the kernel documentation but there is many files about i2c.
> > And if you know a good i2c driver that I can use as an example to design
> > mine, it will be great !

Best is to look at a driver for a device which is similar in
functionality to yours.

-- 
Jean Delvare
