Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab3APRDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:03:14 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:37631 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431Ab3APQAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:00:43 -0500
X-Greylist: delayed 8592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jan 2013 11:00:43 EST
Message-ID: <50F6CE7E.4090807@suse.cz>
Date: Wed, 16 Jan 2013 16:59:58 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Greg KH <gregkh@linuxfoundation.org>, alan@linux.intel.com,
        jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] TTY: switch flipping functions to tty_port
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>  <20130116064735.GA7743@kroah.com> <50F6AD15.708@suse.cz> <1358351064.4068.43.camel@gandalf.local.home>
In-Reply-To: <1358351064.4068.43.camel@gandalf.local.home>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 04:44 PM, Steven Rostedt wrote:
> On Wed, 2013-01-16 at 14:37 +0100, Jiri Slaby wrote:
>> Steven, do you have any plans with the driver? What is its planned destiny?
> 
> Well, I'm currently using the device in my main machine. As it is my
> main box, I don't update the kernel as often.
> 
> Let me know what I need to do to fix it in the current kernel.

Every port in the system has to have its struct tty_port counterpart.

/me looked into the code

OMG. It contains a true copy of serial_core!

In the beginning (to remove the BROKEN flag), what it needs is struct
tty_port to be added to struct sb_uart_info. It obviously needs
tty_port_init + tty_port_destroy at appropriate places. Then it needs
tty_register_device to be switched to tty_port_register_device.

Finally, having the tty_port, all tty flipping functions take the
tty_port, not tty_struct (the build errors reported). This is easy while
you have a tty_port.

In the long term, it needs to get rid of the all the pseudo-uart* stuff
(the copy of serial_core) and use only tty layer+tty_port helpers.

thanks,
-- 
js
suse labs
