Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3FYRzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:55:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45157 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750830Ab3FYRzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:55:43 -0400
Date: Tue, 25 Jun 2013 13:55:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Rupesh Gujare <rupesh.gujare@atmel.com>
cc: Greg KH <gregkh@linuxfoundation.org>, <devel@linuxdriverproject.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <shigekatsu.tateno@atmel.com>
Subject: Re: [PATCH] staging: ozwpan: Convert printk to dev_dbg()
In-Reply-To: <51C9D818.1090702@atmel.com>
Message-ID: <Pine.LNX.4.44L0.1306251352150.1340-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jun 2013, Rupesh Gujare wrote:

> On 25/06/13 18:02, Greg KH wrote:
> > On Tue, Jun 25, 2013 at 05:30:02PM +0100, Rupesh Gujare wrote:
> >> convert all debug messages from printk to dev_dbg() & add kernel config to
> >> enable/disable these messages during compilation.
> > No, just use the built-in dynamic debug code in the kernel, no need to
> > provide any new macros or functions or most importantly, no new Kconfig
> > options.
> >
> 
> New macro (oz_trace) is being used as pointer to "struct device *" is 
> not available in all functions for dev_dbg() function.
> Please let me know if there is better way to handle this, I will be 
> happy to rework on this.

It depends on the situation.  In many cases there _is_ a struct device
associated with the log message, even if a pointer to that device isn't
available in the function.  The proper solution in those cases is to
make it available, by passing the function an extra "struct device *"
argument.

In a few cases there really is no device associated with the message.  
For example, if the module prints out a message when it is first 
loaded, there probably is no device around at that time.  However, in 
most cases there _is_ an associated device.

Alan Stern

