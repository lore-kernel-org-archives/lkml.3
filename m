Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbbAEQ2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:28:40 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40695 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbbAEQ2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:28:38 -0500
Date: Mon, 5 Jan 2015 17:28:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: NeilBrown <neilb@suse.de>, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] TTY: add support for "tty slave" devices.
Message-ID: <20150105162833.GA20821@amd>
References: <20141211214801.4127.93914.stgit@notabene.brown>
 <20141211215943.4127.24792.stgit@notabene.brown>
 <20141228142010.GA3922@amd>
 <20150103103357.2406fc23@notabene.brown>
 <20150105154141.6f191cd5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105154141.6f191cd5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2015-01-05 15:41:41, One Thousand Gnomes wrote:
> > It would be really nice if the uart would register the line disciple as a
> > child device, then the line discipline would register whatever it wants.
> 
> For almost every case this doesn't work. You need a tty interface as well
> because thats how you manage it.
> 
> > But that isn't how it works.  The line discipline doesn't talk to the uart.
> > Rather the tty layer talks to the uart (through tty_operations) and to the
> > line discipline (through tty_ldisc_ops) and also registers the char_dev.
> 
> This is intentional. An ldisc has no business knowing what it's connected
> to. Try running bluetooth over a tty/pty pair remotely to a dongle - and
> you can do it or faking a GSM mux over a tty/pty pair for testing.

Not all cases are like that. IIRC Neil's hardware uses CTS/RTS in an
interesting way. bc2048 is connected to serial+clocks+gpios...

> There are lots of cases where we know the correct ldisc from information
> in the ACPI, DT or even USB identifiers in order to plug in the right
> ldisc and daemon but I think that pretty much has to be in user space.
> The kernel might be able to set an ldisc but it can't go around starting
> bluetooth daemons, doing modem chats to go into mux mode or firing up
> JMRI and java when it sees a Sprog. That's a job for systemd/udev.

No need to start bluetooth daemons: userspace can start them
itself. Just like in btusb case.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
