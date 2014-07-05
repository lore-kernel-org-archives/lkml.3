Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbaGER5t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 13:57:49 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56931 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754359AbaGER5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 13:57:47 -0400
X-Sasl-enc: 3ShQYrhC9yxhZbIsqiTq+a/GtK8Eu7OydFlUuach35fy 1404583066
Date: Sat, 5 Jul 2014 11:02:06 -0700
From: Greg KH <greg@kroah.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [USB spamming log] with 3.16-rc (git) my pl2303 is spaming my
 logs
Message-ID: <20140705180206.GA828@kroah.com>
References: <1404459477.27680.10.camel@x220>
 <4878627.a0D3mPHSVv@grover>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4878627.a0D3mPHSVv@grover>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2014 at 10:55:57AM -0400, Ed Tomlinson wrote:
> Hi
> 
> I have a raspberry PI sending its console to my box via a pl2303 

What exact pl2303 is this?  Can you provide the output from 'lsusb'?

> [    5.184385] usbserial: USB Serial support registered for pl2303
> [    5.184398] pl2303 1-2.6:1.0: pl2303 converter detected
> [    5.185353] usb 1-2.6: pl2303 converter now attached to ttyUSB0
> 
> and with the latest fixes from git on 3.16 its now started spamming my logs with: 
> 
> [55507.155354] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> [55510.736558] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> [55517.238586] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> [55521.099938] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> [55521.778520] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> [55523.229808] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> [55523.229846] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> [55525.074519] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> [55527.270207] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71

That's saying there was one of the following errors in this device:
  a) bitstuff error
  b) no response packet received within the prescribed bus turn-around
     time
  c) unknown USB error

All of which point to either a problem in the USB host controller, or
the usb device itself.

Is this an "unpatched" 3.16-rc kernel running on the rpi?  If so, odds
are it's a host controller issue...

thanks,

greg k-h
