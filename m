Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaLCMdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:33:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43398 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaLCMdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:33:38 -0500
Date: Wed, 3 Dec 2014 13:33:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Miguel Oliveira <cmroliv@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: patch "staging: remove nokia_hp4p driver
Message-ID: <20141203123336.GA31708@amd>
References: <14094295422869@kroah.com>
 <20140830213022.GA17147@amd>
 <20140830220417.GA15000@kroah.com>
 <20140830224430.GA19622@amd>
 <B39194F7-2057-4D14-A3F7-EB6E73BF84F8@holtmann.org>
 <20140831095147.GB24601@amd>
 <4CA4FD0A-C167-4A12-A137-766CB3A2D5D5@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA4FD0A-C167-4A12-A137-766CB3A2D5D5@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > "These are a lot of public functions. Are they all really needed or can
> > the code be done smart."
> > 
> > in TODO file.
> 
> so what about all the other really major details that needed fixing. I mean anybody who was compiling for OMAP platform could have fixed the tons and tons of inlines quickly.
> 

Do you have n900 nearby? You are welcome to try...

Unfortunately, it is not exactly easy. v3.18 with USB patch works with
nfsroot, which makes development possible (good).

Some core (or omap) change broke h4p between 3.15 and 3.16. Bisect
will not be fun, I suspect.

> > (Also hopefully get some testing from
> > n900 community; code is more
> > visible in staging).
> 
> The problem is that they are testing the wrong thing. And lets face it, we already knew this driver works since Nokia shipped it in products.
>

Except that it does not :-(. Apparently not even place in staging was
enough to get regular testing... but at least it will help bisect.

> > I attempted hdev->setup conversion, but could not figure it out till
> > now. Clearly it needs to be done.
> > 
> > For doing that, it would be good to have userland to work with, and
> > yes it takes time. (Debugging on 4" screen sucks.)
> 
> Actually hdev->setup does not need any userland. As long as request_firmware() works, you are just fine. And since the driver already uses that in the first place, I assume it works.
> 

Without working serial port, you can't really debug without
userland. Not on machine that lacks shift-pgup.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
