Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaHIHpq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 03:45:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55263 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaHIHpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 03:45:43 -0400
Date: Sat, 9 Aug 2014 09:45:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        hannes@stressinduktion.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Reading large amounts from /dev/urandom broken
Message-ID: <20140809074539.GA1467@amd.pavel.ucw.cz>
References: <CANZNk81nyws__swPUoxz912wi5PJ2CBXbiLpJ-Jc4oLcX+J8vw@mail.gmail.com>
 <20140723151459.GA6673@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723151459.GA6673@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I've inquired on the bugzilla why the reporter is abusing urandom in
> this way.  The other commenter on the bug replicated the problem, but
> that's not a "second bug report" in my book.
> 
> At the very least, this will probably cause me to insert a warning
> printk: "insane user of /dev/urandom: [current->comm] requested %d
> bytes" whenever someone tries to request more than 4k.

Warn about my quick benchmark?

http://atrey.karlin.mff.cuni.cz/~pavel/quickbench.html

I don't see what is insane about it. Yes, there might be more
effective generators of random bits, but that is not the point, this
is quick&dirty attempt at benchmark.

Also people will use cat /dev/urandom > /dev/sdX (and similar) to
clean hard drives. There should be no need to warn about
that. (Performance is going to be disk-limited anyway).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
