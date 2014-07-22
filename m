Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaGVKzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:55:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41673 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaGVKzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:55:48 -0400
Date: Tue, 22 Jul 2014 12:55:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v2] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140722105546.GA9814@amd.pavel.ucw.cz>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
 <20140721160346.GP30979@8bytes.org>
 <20140721230500.GA7019@amd.pavel.ucw.cz>
 <6793803.1FXN0a3O0V@vostro.rjw.lan>
 <20140722103443.GV30979@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722103443.GV30979@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-07-22 12:34:44, Joerg Roedel wrote:
> On Tue, Jul 22, 2014 at 02:41:29AM +0200, Rafael J. Wysocki wrote:
> > It looks like some specific need motivated the Joerg's work, however,
> > so let's just not dismiss the use case lightly without knowing it.
> 
> The motivation was to optimize the data structures for machines with
> large amounts of RAM without penalizing average machines. On a 12TB
> machine you are close to 100000 pages just for one bitmap. Scanning
> through that linearly to find a given bit just doesnt scale anymore in
> this case.

Writing out every single page on 12TB machine to disk does not scale,
either :-).

> I also see how the problem could be solved differently, but what I
> didn't get from the discussion yet is: What is actually *wrong* with
> *this* approach?

It throws complex / tricky to review code at a problem... that is not
a problem in any reasonable configuration.

Now... should I spend half an hour reviewing your changes, or are we
maybe better without them?

> So we save around 50ms (or 62% of time) already on this 16GB machine.

Or about 5 seeks or about 0.000% of total hibernation cycle.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
