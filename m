Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbaE3Mfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:35:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59051 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaE3Mfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:35:36 -0400
Date: Fri, 30 May 2014 14:35:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miguel Oliveira <cmroliv@gmail.com>
Cc: gregkh@linuxfoundation.org, gulsah.1004@gmail.com, pali.rohar@gmail.com,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nokia_h4: nokia_core.c: use usleep_range()
 instead of msleep()
Message-ID: <20140530123533.GB10549@amd.pavel.ucw.cz>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
 <20140530113418.GA9670@amd.pavel.ucw.cz>
 <CAMGgR5swX-cp4navRBu8CxYnL5fRSxkBVRcu-xKXkr0oyBXP+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMGgR5swX-cp4navRBu8CxYnL5fRSxkBVRcu-xKXkr0oyBXP+A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> So the /Documentation/timers/timers-howto.txt stats:
> 
> SLEEPING FOR ~USECS OR SMALL MSECS ( 10us - 20ms):
> * Use usleep_range
> 
> - Why not msleep for (1ms - 20ms)?
> Explained originally here:
> http://lkml.org/lkml/2007/8/3/250
> msleep(1~20) may not do what the caller intends, and
> will often sleep longer (~20 ms actual sleep for any
> value given in the 1~20ms range). In many cases this
> is not the desired behavior.
...
> Should the documentation should be ignored?

Caller wants to sleep for 10ms; docs said it may sleep for 10-20msec;
that sounds reasonable. You replaced it with busy-loop for 10-15msec.

That does not sound like improvement.

Thanks,
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
