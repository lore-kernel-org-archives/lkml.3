Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbaGOJoC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:44:02 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:50950 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757868AbaGOJn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:43:59 -0400
Message-ID: <53C4F7D2.7070707@mev.co.uk>
Date: Tue, 15 Jul 2014 10:43:46 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: sam-the-6 <asadi.samuel@gmail.com>, <hsweeten@visionengravers.com>,
        <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 92/93] Staging: comedi: 8255: fixed by adding an empthy
 line
References: <1405394144-26007-1-git-send-email-asadi.samuel@gmail.com>
In-Reply-To: <1405394144-26007-1-git-send-email-asadi.samuel@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-15 04:15, sam-the-6 wrote:
> From: Sam Asadi <asadi.samuel@gmail.com>
>
> fixed a coding style issue.
>
> Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
> 	modified:   drivers/staging/comedi/drivers/8255.c
> ---
>   drivers/staging/comedi/drivers/8255.c |  150 ++++++++++++++++-----------------
>   1 file changed, 74 insertions(+), 76 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
> index 46113a3..de273c7 100644
> --- a/drivers/staging/comedi/drivers/8255.c
> +++ b/drivers/staging/comedi/drivers/8255.c
> @@ -1,77 +1,73 @@
>   /*
> -    comedi/drivers/8255.c
> -    Driver for 8255
> -
> -    COMEDI - Linux Control and Measurement Device Interface
> -    Copyright (C) 1998 David A. Schleef <ds@schleef.org>
> -
> -    This program is free software; you can redistribute it and/or modify
> -    it under the terms of the GNU General Public License as published by
> -    the Free Software Foundation; either version 2 of the License, or
> -    (at your option) any later version.
> -
> -    This program is distributed in the hope that it will be useful,
> -    but WITHOUT ANY WARRANTY; without even the implied warranty of
> -    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> -    GNU General Public License for more details.
> +	comedi/drivers/8255.c
> +	Driver for 8255
> +
> +	COMEDI - Linux Control and Measurement Device Interface
> +	Copyright (C) 1998 David A. Schleef <ds@schleef.org>
> +
> +	This program is free software; you can redistribute it and/or modify
> +	it under the terms of the GNU General Public License as published by
> +	the Free Software Foundation; either version 2 of the License, or
> +	(at your option) any later version.
> +
> +	This program is distributed in the hope that it will be useful,
> +	but WITHOUT ANY WARRANTY; without even the implied warranty of
> +	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +	GNU General Public License for more details.
> +
> +	Driver: 8255
> +	Description: generic 8255 support
> +	Devices: [standard] 8255 (8255)
> +	Author: ds
> +	Status: works
> +	Updated: Fri,  7 Jun 2002 12:56:45 -0700
> +
> +	The classic in digital I/O.  The 8255 appears in Comedi as a single
> +	digital I/O subdevice with 24 channels.  The channel 0 corresponds
> +	to the 8255's port A, bit 0; channel 23 corresponds to port C, bit
> +	7.  Direction configuration is done in blocks, with channels 0-7,
> +	8-15, 16-19, and 20-23 making up the 4 blocks.  The only 8255 mode
> +	supported is mode 0.
> +
> +	You should enable compilation this driver if you plan to use a board
> +	that has an 8255 chip.  For multifunction boards, the main driver will
> +	configure the 8255 subdevice automatically.
> +
> +	This driver also works independently with ISA and PCI cards that
> +	directly map the 8255 registers to I/O ports, including cards with
> +	multiple 8255 chips.  To configure the driver for such a card, the
> +	option list should be a list of the I/O port bases for each of the
> +	8255 chips.  For example,
> +
> +	comedi_config /dev/comedi0 8255 0x200,0x204,0x208,0x20c
> +
> +	Note that most PCI 8255 boards do NOT work with this driver, and
> +	need a separate driver as a wrapper.  For those that do work, the
> +	I/O port base address can be found in the output of 'lspci -v'.
> +
> +	This file contains an exported subdevice for driving an 8255.
> +
> +	To use this subdevice as part of another driver, you need to
> +	set up the subdevice in the attach function of the driver by
> +	calling:
> +
> +	subdev_8255_init(device, subdevice, io_function, iobase)
> +
> +	device and subdevice are pointers to the device and subdevice
> +	structures.  io_function will be called to provide the
> +	low-level input/output to the device, i.e., actual register
> +	access.  io_function will be called with the value of iobase
> +	as the last parameter.  If the 8255 device is mapped as 4
> +	consecutive I/O ports, you can use NULL for io_function
> +	and the I/O port base for iobase, and an internal function will
> +	handle the register access.
> +
> +	In addition, if the main driver handles interrupts, you can
> +	enable commands on the subdevice by calling subdev_8255_init_irq()
> +	instead.  Then, when you get an interrupt that is likely to be
> +	from the 8255, you should call subdev_8255_interrupt(), which
> +	will copy the latched value to a Comedi buffer.
>   */
> -/*
> -Driver: 8255
> -Description: generic 8255 support
> -Devices: [standard] 8255 (8255)
> -Author: ds
> -Status: works
> -Updated: Fri,  7 Jun 2002 12:56:45 -0700
> -
> -The classic in digital I/O.  The 8255 appears in Comedi as a single
> -digital I/O subdevice with 24 channels.  The channel 0 corresponds
> -to the 8255's port A, bit 0; channel 23 corresponds to port C, bit
> -7.  Direction configuration is done in blocks, with channels 0-7,
> -8-15, 16-19, and 20-23 making up the 4 blocks.  The only 8255 mode
> -supported is mode 0.
> -
> -You should enable compilation this driver if you plan to use a board
> -that has an 8255 chip.  For multifunction boards, the main driver will
> -configure the 8255 subdevice automatically.
> -
> -This driver also works independently with ISA and PCI cards that
> -directly map the 8255 registers to I/O ports, including cards with
> -multiple 8255 chips.  To configure the driver for such a card, the
> -option list should be a list of the I/O port bases for each of the
> -8255 chips.  For example,
> -
> -  comedi_config /dev/comedi0 8255 0x200,0x204,0x208,0x20c
> -
> -Note that most PCI 8255 boards do NOT work with this driver, and
> -need a separate driver as a wrapper.  For those that do work, the
> -I/O port base address can be found in the output of 'lspci -v'.
> -
> -*/
> -
> -/*
> -   This file contains an exported subdevice for driving an 8255.
> -
> -   To use this subdevice as part of another driver, you need to
> -   set up the subdevice in the attach function of the driver by
> -   calling:
> -
> -     subdev_8255_init(device, subdevice, io_function, iobase)
> -
> -   device and subdevice are pointers to the device and subdevice
> -   structures.  io_function will be called to provide the
> -   low-level input/output to the device, i.e., actual register
> -   access.  io_function will be called with the value of iobase
> -   as the last parameter.  If the 8255 device is mapped as 4
> -   consecutive I/O ports, you can use NULL for io_function
> -   and the I/O port base for iobase, and an internal function will
> -   handle the register access.
> -
> -   In addition, if the main driver handles interrupts, you can
> -   enable commands on the subdevice by calling subdev_8255_init_irq()
> -   instead.  Then, when you get an interrupt that is likely to be
> -   from the 8255, you should call subdev_8255_interrupt(), which
> -   will copy the latched value to a Comedi buffer.
> - */

Please format those as three separate comments in the usual block 
comment style:

/*
  * Multi
  * line
  * comment
  */

>
>   #include <linux/module.h>
>   #include "../comedidev.h"
> @@ -94,6 +90,7 @@ I/O port base address can be found in the output of 'lspci -v'.
>
>   struct subdev_8255_private {
>   	unsigned long iobase;
> +
>   	int (*io)(int, int, int, unsigned long);
>   };
>
> @@ -102,9 +99,8 @@ static int subdev_8255_io(int dir, int port, int data, unsigned long iobase)
>   	if (dir) {
>   		outb(data, iobase + port);
>   		return 0;
> -	} else {
> +	} else
>   		return inb(iobase + port);
> -	}
>   }

If either the 'if' or the 'else' use braces, the other one should too.

>
>   void subdev_8255_interrupt(struct comedi_device *dev,
> @@ -309,9 +305,9 @@ EXPORT_SYMBOL_GPL(subdev_8255_init_irq);
>
>   /*
>
> -   Start of the 8255 standalone device
> +	Start of the 8255 standalone device
>
> - */
> +*/

Please use the usual block comment style.

>
>   static int dev_8255_attach(struct comedi_device *dev,
>   			   struct comedi_devconfig *it)
> @@ -373,8 +369,10 @@ static struct comedi_driver dev_8255_driver = {
>   	.attach		= dev_8255_attach,
>   	.detach		= dev_8255_detach,
>   };
> +
>   module_comedi_driver(dev_8255_driver);
>
>   MODULE_AUTHOR("Comedi http://www.comedi.org");
>   MODULE_DESCRIPTION("Comedi low-level driver");
>   MODULE_LICENSE("GPL");
> +
>

Extra blank line is unnecessary.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
