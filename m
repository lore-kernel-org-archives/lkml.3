Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab3APQWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:22:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:3606 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab3APQWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:22:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,480,1355126400"; 
   d="scan'208";a="247762207"
Date: Wed, 16 Jan 2013 16:42:38 +0000
From: Alan Cox <alan@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, Greg KH <gregkh@linuxfoundation.org>,
        jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] TTY: switch flipping functions to tty_port
Message-ID: <20130116164238.625db60c@bob.linux.org.uk>
In-Reply-To: <50F6CE7E.4090807@suse.cz>
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
	<20130116064735.GA7743@kroah.com>
	<50F6AD15.708@suse.cz>
	<1358351064.4068.43.camel@gandalf.local.home>
	<50F6CE7E.4090807@suse.cz>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013 16:59:58 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> On 01/16/2013 04:44 PM, Steven Rostedt wrote:
> > On Wed, 2013-01-16 at 14:37 +0100, Jiri Slaby wrote:
> >> Steven, do you have any plans with the driver? What is its planned
> >> destiny?
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

And it seems to just be another 165x0 driver anyway In fact it looks
like the right thing to do is to take it out and shoot it. We've got a
16x50 driver already.

There are a few bits of gunk in there to set custom board registers and
to figure out the configuration. See drivers/tty/serial/8250/8250_pci.c
and it ought to be possible to just plug it in there. The 422 stuff
might need a bit more tweaking.

Alan
