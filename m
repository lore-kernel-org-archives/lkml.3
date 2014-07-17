Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbaGQVdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:33:00 -0400
Received: from imap.thunk.org ([74.207.234.97]:41867 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757563AbaGQVc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:32:58 -0400
Date: Thu, 17 Jul 2014 16:54:17 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Zach Brown <zab@zabbo.net>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140717205417.GT1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Zach Brown <zab@zabbo.net>,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717194812.GC24196@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717194812.GC24196@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 12:48:12PM -0700, Zach Brown wrote:
> 
> > +	return urandom_read(NULL, buf, count, NULL);
> 
> I wonder if we want to refactor the entry points a bit more instead of
> directly calling the device read functions.  get_random_bytes() and
> urandom_read() both have their own uninitialied use warning message and
> tracing.  Does the syscall want its own little extraction function as
> well?

I'm not sure what warning you are worried about?  urandom_read() never
uses file or ppos, so passing in NULL works just fine as near as I can
tell.

I could refactor the entropy point, but it probably wouldn't add any
extra bloat, since the compiler would hopefully compile it away, but
adding the extra static function would seem to make things less
readable at least in my opinion.

					- Ted
