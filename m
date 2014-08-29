Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaH2L1C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:27:02 -0400
Received: from imap.thunk.org ([74.207.234.97]:55556 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbaH2L1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:27:00 -0400
Date: Fri, 29 Aug 2014 07:26:55 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Calvin Owens <jcalvinowens@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: BUG: drivers/char/random.c:986
Message-ID: <20140829112655.GB20278@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Calvin Owens <jcalvinowens@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
References: <20140829050150.GA3011@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140829050150.GA3011@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 10:01:50PM -0700, Calvin Owens wrote:
> Hello all,
> 
> I hit this BUG_ON() on my laptop a few days ago: http://i.imgur.com/N1GQeJW.jpg
> 
> In the current upstream, this corresponds to line 1022:
> 
> 	BUG_ON(r->entropy_count > r->poolinfo->poolfracbits);
> 
> It triggered when I executed `dd if=/dev/urandom of=file bs=N count=1`
> while watching a YouTube video in Chromium. I don't recall the exact value of
> N I used, but it was rather large (>50M), and a few bytes past an even power
> of two (I was creating a file to test an HTTP upload script I was working on).
> 
> I haven't had any luck reproducing this on the current upstream or the version
> it was originally triggered on.

Known bug, fixed in 79a8468747c5 which landed in mainline as of
3.16-rc6.  And you were running 3.16-rc4.  (BTW, in the future it
would be nice if you mentioned the kernel version you were running in;
I found it by looking at the jpg, but it's always more convenient to
be able to read it in ASCII.  :-)

Cheers,

						- Ted
