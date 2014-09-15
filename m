Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaIOTO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:14:59 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:57298 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbaIOTO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:14:57 -0400
Date: Mon, 15 Sep 2014 12:14:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: James Hogan <james.hogan@imgtec.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-metag@vger.kernel.org
Subject: Re: [PATCH] tty/metag_da: Add console_poll module parameter
Message-ID: <20140915191452.GA18175@roeck-us.net>
References: <1410560122-12362-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410560122-12362-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 11:15:22PM +0100, James Hogan wrote:
> Currently the metag_da console channel is write only, it doesn't get
> polled for incoming data. This is for performance & latency reasons as
> polling blocks the processor for a significant amount of time waiting
> for the JTAG probe to respond to the request and restart the thread.
> This means that the console channel cannot be used for a login prompt,
> so ttyDA2 is usually used instead.
> 
> In a virtual environment with a virtual DA such as QEMU however the
> polling is much cheaper as the request can be handled immediately. It is
> useful to be able to enable polling in such an environment in order to
> get both the kernel log and a usable login prompt on the same DA
> channel.
> 
> Add a console_poll module parameter which allows polling to be enabled
> for the console channel. It defaults to off as that is the current
> behaviour for good reason on real hardware.
> 
> It can be enabled by appending metag_da.console_poll to the kernel
> command line.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Guenter Roeck <linux@roeck-us.net>

Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks a lot!

Guenter
