Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaAQMO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 07:14:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51174 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaAQMOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 07:14:53 -0500
Date: Fri, 17 Jan 2014 13:14:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>, Sebastian Reichel <sre@ring0.de>
Subject: Re: [PATCH v6] Bluetooth: Add hci_h4p driver
Message-ID: <20140117121451.GA15496@amd.pavel.ucw.cz>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <20140102161824.GA8204@amd.pavel.ucw.cz>
 <A5B72277-42D4-4A24-8A29-9BE18762E8C4@holtmann.org>
 <20140103001753.GA21023@amd.pavel.ucw.cz>
 <20140110145207.GB12048@amd.pavel.ucw.cz>
 <20140111002801.GA20216@amd.pavel.ucw.cz>
 <FD05FD52-1502-4AB8-8650-FC785B700088@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FD05FD52-1502-4AB8-8650-FC785B700088@holtmann.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Add hci_h4p bluetooth driver to bluetooth-next. This device is used
> > for example on Nokia N900 cell phone.
> > 
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > Thanks-to: Sebastian Reichel <sre@debian.org>
> > Thanks-to: Joe Perches <joe@perches.com>
> > 
> > ---
> > 
> > Changes from v5: Comment fixes and some refactoring suggested by 
> > Joe Perches. Please apply.

> > --- /dev/null
> > +++ b/drivers/bluetooth/hci_h4p.h
> 
> can we please get the naming straight. File names do not start with hci_ anymore. We moved away from it since that term is too generic.
> 

Ok, this is easy.

> > +	struct timer_list lazy_release;
> 
> Timer? Not delayed work?

But these changes sound like bigger piece of refactoring, and more is
suggested below. Which is good, but will be tricky to develop/test on
bluetooth-next, as running Maemo is really needed for testing.

So... this will take longer than expected, and I believe it makes
sense to push it to staging, first. That will bring linux-n900 tree
closer to mainline, and preserve more of history.

Regards,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
