Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab3APQXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:23:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17399 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab3APQXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:23:12 -0500
X-Authority-Analysis: v=2.0 cv=e+OEuNV/ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=oS6VeJ3zRZwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ylgaL1uFd_sA:10 a=I9WiF3Pm5Iv87ngVyhUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358353390.4068.51.camel@gandalf.local.home>
Subject: Re: [PATCH 00/10] TTY: switch flipping functions to tty_port
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@linux.intel.com,
        jirislaby@gmail.com, linux-kernel@vger.kernel.org
Date: Wed, 16 Jan 2013 11:23:10 -0500
In-Reply-To: <50F6CE7E.4090807@suse.cz>
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
	  <20130116064735.GA7743@kroah.com> <50F6AD15.708@suse.cz>
	 <1358351064.4068.43.camel@gandalf.local.home> <50F6CE7E.4090807@suse.cz>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 16:59 +0100, Jiri Slaby wrote:
> On 01/16/2013 04:44 PM, Steven Rostedt wrote:
> > On Wed, 2013-01-16 at 14:37 +0100, Jiri Slaby wrote:
> >> Steven, do you have any plans with the driver? What is its planned destiny?
> > 
> > Well, I'm currently using the device in my main machine. As it is my
> > main box, I don't update the kernel as often.
> > 
> > Let me know what I need to do to fix it in the current kernel.
> 
> Every port in the system has to have its struct tty_port counterpart.
> 
> /me looked into the code
> 
> OMG. It contains a true copy of serial_core!

LOL... Yes this driver truly does suck. I started with a copy that came
with the device (well, downloaded it from their web site). I did the
bare minimum to get it working with the latest kernel, in the hope that
I can get others to help make it into a proper driver.

> 
> In the beginning (to remove the BROKEN flag), what it needs is struct
> tty_port to be added to struct sb_uart_info. It obviously needs
> tty_port_init + tty_port_destroy at appropriate places. Then it needs
> tty_register_device to be switched to tty_port_register_device.
> 
> Finally, having the tty_port, all tty flipping functions take the
> tty_port, not tty_struct (the build errors reported). This is easy while
> you have a tty_port.
> 
> In the long term, it needs to get rid of the all the pseudo-uart* stuff
> (the copy of serial_core) and use only tty layer+tty_port helpers.

grumble, this is a bit more work than I currently have time for. This
driver needs some major loving. But my heart is someplace else, and
until I can get a divorce from what I'm currently working on, this
driver will need to find lovers from someone else.

-- Steve


