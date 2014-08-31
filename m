Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaHaJvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 05:51:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41952 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaHaJvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 05:51:49 -0400
Date: Sun, 31 Aug 2014 11:51:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Miguel Oliveira <cmroliv@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: patch "staging: remove nokia_hp4p driver
Message-ID: <20140831095147.GB24601@amd>
References: <14094295422869@kroah.com>
 <20140830213022.GA17147@amd>
 <20140830220417.GA15000@kroah.com>
 <20140830224430.GA19622@amd>
 <B39194F7-2057-4D14-A3F7-EB6E73BF84F8@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B39194F7-2057-4D14-A3F7-EB6E73BF84F8@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> What is going on here? I get flamed for not cleaning up the driver,
> >>> because I cleaned it up before merging to -staging. Ok, so I did more
> >>> cleanups, sent 3 cleanup patches, no reaction on those, and now I got
> >>> a note that you are going to remove the driver...?
> >> 
> >> For the 3 "cleanup" patches, the first one was rejected and you said to
> >> not include it, so I couldn't apply the others.
> > 
> > That was different series. I'm talking about:
> > 
> > [PATCH 1/3] staging: nokia_h4: switch to right types and use bdaddr_t
> > [PATCH 2/3] staging: nokia_h4: avoid __uX types
> > [PATCH 3/3] staging: use inlines where it makes sense
> > 
> > That is still valid and received no comments at all.

>  and these are all trivial cleanups and could have been done back in
> January when this driver was merged into staging. It is end of
> August now and nothing happened to address anything in the TODO
> file.

[Could you please wrap at 80 characters?]

Would be done in january if someone pointed the problems out.

For the record, 3/3 addresses your comment

"These are a lot of public functions. Are they all really needed or can
the code be done smart."

in TODO file.

> The warning from end of May that this driver will be removed seemed
> to not have triggered anybody to work on the core issues of the
> driver.

Actually it did trigger me to work on the patch series above. It is
just that the series was ignored, and now I'm told that driver is
going to be removed because I did not do the work.

> There are 3 major topics that needs addressing before this driver should come anywhere near upstream kernel again, staging or otherwise.
> 
> a) Convert to using device tree for device detection
> 
> b) Convert to using hdev->setup for firmware loading
> 
> c) Convert to using hdev->set_bdaddr and HCI_QUIRK_INVALID_BDADDR

I thought staging is for merging code to be cleaned up. Not "please
rewrite, and possibly break the driver before merging it into
staging". Merge it into staging, then clean it up there.

(Also hopefully get some testing from n900 community; code is more
visible in staging).

And BTW it is first time I hear about a).

> Please keep in mind that this was not an ugly Windows driver with a
> lot of Windows specific typedefs or bad coding style or OS
> abstractions. From that point of view it was always good since it
> was written for Linux in the first place. It was just a bit
> dated. Any fixes to bring that in sync with all other drivers could
> have been done easily after it was merged into the Bluetooth
> subsystem.

So you are saying that most of the comments you had when I attempted
to merge the driver did not really need to be addressed? That's news
to me, normally maintainers want their comments addressed.

And yes, this driver bitroted a lot while being out of tree. It was
probably pretty good initially, mergeable with minimum effort. Now you
want it to bitrot a bit more.

> The reason why it ended up in staging is that the 3 core problems needed fixing. And 8 month later they still have not been fixed.
> 

I attempted hdev->setup conversion, but could not figure it out till
now. Clearly it needs to be done.

For doing that, it would be good to have userland to work with, and
yes it takes time. (Debugging on 4" screen sucks.)

> > You asked for more work and explained how easy it is to revert the
> > removal.
> > 
> > I did more work, you ignored it, and are removing the driver, anyway.
> 
> I have seen only fluff patches. Someone needs to address the core problems of the driver.

Clearly. But at the same time not taking even the trivial patches is
great way of stalling the devopment.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
