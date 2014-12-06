Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaLFPPG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:15:06 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48344 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaLFPPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:15:02 -0500
Date: Sat, 6 Dec 2014 20:44:50 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: staging: panel: suggestions needed
Message-ID: <20141206151450.GA11896@sudip-PC>
References: <20141202080214.GA4762@sudip-PC>
 <20141206084108.GA3404@1wt.eu>
 <20141206100933.GA7141@sudip-PC>
 <20141206102853.GB2959@firebird>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141206102853.GB2959@firebird>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2014 at 11:28:54AM +0100, Mariusz Gorski wrote:
> Hi Supid,
> 
> On Sat, Dec 06, 2014 at 03:39:33PM +0530, Sudip Mukherjee wrote:
> > On Sat, Dec 06, 2014 at 09:41:08AM +0100, Willy Tarreau wrote:
> > > Hi Sudip,
> > > 
> > > [ CCing Mariusz who's currently cleaning up the driver ]
> > > 
> > > On Tue, Dec 02, 2014 at 01:32:14PM +0530, Sudip Mukherjee wrote:
<snip>
> > > Feel free to do so. I never had the luck to own a 4-line LCD so this
> > > was never even planned. And yes, I remember something about 4-line LCDs
> > > using tricks such as 2x40 addressing being split into 4x20.
> > well, i work in a company which is in embedded training, so i have access to few hardware, and for this i can have 16x2 and 20x4 lcd, but no serial lcd ... :(
> 
> Setting the height to 4 is not going to make it work properly - due to
> the way the display is working internally. I also own one in 4x20 size
> and after I get done with the cleaning stuff, I'm going to add proper
> support for it.
ofcourse, just making the height to 4 will not work properly. Height 4 can be there only for user's advantage. but internally we need to monitor if the user is displaying on 3rd or 4th line, then we need to shift that data to the respective position of the 1st and 2nd line to display it properly.

thanks
sudip

> 
> > > 
> > > > 	2) The lcd commands you are writing to the lcd in an escape sequence
> > > > 	while writing to the lcd. Instead of that why don't we use ioctl for
> > > > 	lcd commands, and writing to the device will involve only sending data
> > > > 	to lcd ?
> > > 
<snip>
> > > init -> 
> > > select_in ->
> > > 
> > > And here's the module load command I used to run :
> > > insmod /tmp/panel-0.8.0.o parport=0 lcd_enabled=2 keypad_enabled=1 lcd_width=16 lcd_hwidth=16 lcd_height=2
> > > 
> > > Hoping this helps,
> > > Willy
> > > 
