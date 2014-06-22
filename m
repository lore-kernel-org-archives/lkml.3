Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaFVBAh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 21:00:37 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60174 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbaFVBAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 21:00:36 -0400
Message-ID: <1403398834.2177.41.camel@dabdike.int.hansenpartnership.com>
Subject: Re: 32-bit bug in iovec iterator changes
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Date: Sat, 21 Jun 2014 18:00:34 -0700
In-Reply-To: <20140622005352.GS18016@ZenIV.linux.org.uk>
References: <20140619160801.GB4907@thunk.org>
	 <20140619162144.GC4907@thunk.org> <20140619223820.GN4453@dastard>
	 <20140621035144.GA8526@thunk.org>
	 <20140621055306.GP18016@ZenIV.linux.org.uk>
	 <20140621230922.GA13188@thunk.org>
	 <20140621234913.GQ18016@ZenIV.linux.org.uk>
	 <1403395400.2592.4.camel@jarvis.lan>
	 <20140622002618.GR18016@ZenIV.linux.org.uk>
	 <1403397164.2177.40.camel@dabdike.int.hansenpartnership.com>
	 <20140622005352.GS18016@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-06-22 at 01:53 +0100, Al Viro wrote:
> On Sat, Jun 21, 2014 at 05:32:44PM -0700, James Bottomley wrote:
> > > No, we are not.  Look:
> > > 	* comparison promotes both operands to u64 here, so its result is
> > > accurate, no matter how large count is.  They are compared as natural
> > > numbers.
> > 
> > True ... figured this out 10 seconds after sending the email.
> > 
> > > 	* assignment converts count to size_t, which *would* truncate for
> > > values that are greater than the maximal value representable by size_t.
> > > But in that case it's by definition greater than i->count, so we do not
> > > reach that assignment at all.
> > 
> > OK, so what I still don't get is why isn't the compiler warning when we
> > truncate a u64 to a u32?  We should get that warning in your new code,
> > and we should have got that warning in fs/block_dev.c where it would
> > have pinpointed the actual problem.
> 
> In which universe?
> 
> extern void f(unsigned int);
> 
> void g(unsigned long x)
> {
> 	f(x);
> }

In the one where the code is compiled with -Wconversion ... I'm just
surprised, I thought we had this enabled.

James


