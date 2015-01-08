Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbbAHWhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:37:36 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:37272 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbbAHWhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:37:35 -0500
Date: Thu, 8 Jan 2015 22:36:26 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] serial: 8250: Make ISA ports optional
Message-ID: <20150108223626.43fd93d5@lxorguk.ukuu.org.uk>
In-Reply-To: <1896224.oMI8M6J5T7@wuerfel>
References: <1420513785-23660-1-git-send-email-peter@hurleysoftware.com>
	<20150108131008.16c9a31c@lxorguk.ukuu.org.uk>
	<54AEAC47.1040403@hurleysoftware.com>
	<1896224.oMI8M6J5T7@wuerfel>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One idea that has come up in the past but never saw an implementation
> is to make the ttyS namespace and minor numbers completely generic and
> let any serial port driver use it. This would be a major rework, but
> have the added advantage of cleaning up a number of other namespace
> issues as well. There also lots of open question, in particular how
> to maintain compatibility with existing drivers. One could imagine
> that each uart always gets a ttyS device and optionally also gets
> a device node for the same port with a driver specific chardev as
> most of them do today. Or it could be an either/or decision that is
> made at compile time or as a module parameter.

I'm not sure we should use ttyS for it. ttyS means 8250, a lot of
existing code knows what ttyS is and what sort of ioctls and the like are
assumed. A generic namespace needs not to be attached to a legacy naming 

(eg also put all serial ports in /dev/serial/0 /dev/serial/1 etc either
via the tty layer or via systemd/udev)

Alan
