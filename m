Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaLFKJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 05:09:45 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33519 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaLFKJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 05:09:43 -0500
Date: Sat, 6 Dec 2014 15:39:33 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Mariusz Gorski <marius.gorski@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: staging: panel: suggestions needed
Message-ID: <20141206100933.GA7141@sudip-PC>
References: <20141202080214.GA4762@sudip-PC>
 <20141206084108.GA3404@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141206084108.GA3404@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2014 at 09:41:08AM +0100, Willy Tarreau wrote:
> Hi Sudip,
> 
> [ CCing Mariusz who's currently cleaning up the driver ]
> 
> On Tue, Dec 02, 2014 at 01:32:14PM +0530, Sudip Mukherjee wrote:
> > Hi,
> > I have been looking at your panel driver, and am attaching a 20x4 alphanueric
> > lcd to it. Will start testing it in a few days as and when I get time. Looks
> > like, it is receiving mostly checkpatch and sparse cleanups.
> 
> yes mostly.
> 
> > Just wanted your opinion on few things I was thinking:
> > 	1) Number of lines you have fixed to 2 and 40 char per line. since I am
> > 	going to connect 20x4 , i need to remember that after displaying 20
> > 	character in 1st line, next char will come to 3rd line. instead why
> > 	don't we make the option of number of line to 4 ?
> 
> Feel free to do so. I never had the luck to own a 4-line LCD so this
> was never even planned. And yes, I remember something about 4-line LCDs
> using tricks such as 2x40 addressing being split into 4x20.
well, i work in a company which is in embedded training, so i have access to few hardware, and for this i can have 16x2 and 20x4 lcd, but no serial lcd ... :(
> 
> > 	2) The lcd commands you are writing to the lcd in an escape sequence
> > 	while writing to the lcd. Instead of that why don't we use ioctl for
> > 	lcd commands, and writing to the device will involve only sending data
> > 	to lcd ?
> 
> Because you cannot send that from a script. It's just as if you had to use
> an ioctl to clear your terminal, inverse its video or to move its cursor,
> it would not be very convenient.
yes, ioctl will not be possible from script. but here in India, we will usually use c code for embedded systems, on very rare occassion we will use scripts. and we will be using open(), read(), write(), ioctl() and close() system calls from our projects.
here, we can have both methods in the code. if someone is using escape sequence - that will work, and we can also have the ioctl for the same purpose.
> 
> > 	3) You have given fixed minor number in your code. Any problem if we
> > 	make it dynamic ?
> 
> No objection, but I think we should keep a config option to bind to the
> old minor. The rationale behind this is that this driver is mostly used
> in embedded systems with a fixed /dev.
ok. but one doubt: won't misc_register create the /dev entry automatically ?

thanks
sudip
> 
> > 	4) For now I am only attaching a LCD, but I also want to attach a
> > 	keypad to it. Can you please let me know about the schematic of the
<snip>
> init -> 
> select_in ->
> 
> And here's the module load command I used to run :
> insmod /tmp/panel-0.8.0.o parport=0 lcd_enabled=2 keypad_enabled=1 lcd_width=16 lcd_hwidth=16 lcd_height=2
> 
> Hoping this helps,
> Willy
> 
