Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaHLJOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:14:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57475 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaHLJOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:14:32 -0400
Date: Tue, 12 Aug 2014 11:14:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, hannes@stressinduktion.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Reading large amounts from /dev/urandom broken
Message-ID: <20140812091428.GA3950@amd.pavel.ucw.cz>
References: <CANZNk81nyws__swPUoxz912wi5PJ2CBXbiLpJ-Jc4oLcX+J8vw@mail.gmail.com>
 <20140723151459.GA6673@thunk.org>
 <20140809074539.GA1467@amd.pavel.ucw.cz>
 <CANZNk83jWeqkESFVVNb4KS+H6gQYgcVtcU8xEMiMHz7jfE52nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANZNk83jWeqkESFVVNb4KS+H6gQYgcVtcU8xEMiMHz7jfE52nQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-08-10 14:51:08, Andrey Utkin wrote:
> 2014-08-09 10:45 GMT+03:00 Pavel Machek <pavel@ucw.cz>:
> > Warn about my quick benchmark?
> >
> > http://atrey.karlin.mff.cuni.cz/~pavel/quickbench.html
> >
> > I don't see what is insane about it. Yes, there might be more
> > effective generators of random bits, but that is not the point, this
> > is quick&dirty attempt at benchmark.
> >
> > Also people will use cat /dev/urandom > /dev/sdX (and similar) to
> > clean hard drives. There should be no need to warn about
> > that. (Performance is going to be disk-limited anyway).
> 
> I believe "cat /dev/urandom" doesn't result in reading with _block
> size_ more than 32 MB. As it was already explained by Theodore,
> currently single read() operation will return "short read" when
> requested to give more than 32 MB at once. You still can read more in
> consecuential reading acts.

Well, I still don't think this behaviour change is a good idea.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
