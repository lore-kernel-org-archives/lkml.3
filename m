Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab3LOLYa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 06:24:30 -0500
Received: from smtp205.alice.it ([82.57.200.101]:37802 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab3LOLY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 06:24:28 -0500
Date: Sun, 15 Dec 2013 12:24:13 +0100
From: Gianluca Anzolin <gianluca@sottospazio.it>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Gustavo Padovan <gustavo@padovan.org>, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, gregkh@linuxfoundation.org,
        jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] rfcomm (userland) broken by commit 29cd718b
Message-ID: <20131215112413.GA8980@sottospazio.it>
References: <1377620926-23370-1-git-send-email-gianluca@sottospazio.it>
 <20130919162413.GG4006@joana>
 <52AA1854.500@ahsoftware.de>
 <52AA1E62.1030109@hurleysoftware.com>
 <52AA483E.4080706@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AA483E.4080706@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 12:35:26AM +0100, Alexander Holler wrote:
> Am 12.12.2013 21:36, schrieb Peter Hurley:
> 
> >> What currently happens is that when one kills rfcomm (and any other
> >> terminal which might use that tty), the entry in /dev doesn't
> >> disappear. That means the same call to refcomm with the same device
> >> (e.g. [/dev/]rfcomm1 doesn't work.
> > 
> > Thanks for the report, Alexander.
> > 
> > Point 4 above details a different situation; something else is
> > happening.
> > 
> > Would you please detail the necessary steps to reproduce this regression?
> > (How do you 'kill' rfcomm? etc.  Shell command lines would be best.)
> 
> Just call
> 
> rfcomm connect rfcomm9 01:23:45:67:89:ab
> 
> wait until the connection happened  (a message will appear) and then
> press ctrl-c. This still terminates the bluetooth connection, but the
> device in /dev is now left.

Yes I'm able to reproduce the regression which is indeed caused by that
commit.

However I'm puzzled. Surely there is a fifth case I didn't cover because
when rfcomm_dev_state_change() is called, the tty_port is there but the tty is
not, and therefore I cannot get a reference to it and send the HUP.

I'll let you know when I have something working.

> 
> Regards,
> 
> Alexander Holler
