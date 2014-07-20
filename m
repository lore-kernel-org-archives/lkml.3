Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaGTRlZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 13:41:25 -0400
Received: from imap.thunk.org ([74.207.234.97]:46186 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbaGTRlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 13:41:22 -0400
Date: Sun, 20 Jul 2014 13:41:04 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140720174104.GH5017@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Schwab <schwab@linux-m68k.org>,
	linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <87tx6cvt2p.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tx6cvt2p.fsf@igel.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 07:27:42PM +0200, Andreas Schwab wrote:
> Theodore Ts'o <tytso@mit.edu> writes:
> 
> > ERRORS
> > 	EINVAL		The buflen value was invalid.
> 
> Also on unknown flags?  Without that it would be impossible to probe for
> implemented flags.

We removed the cap on the buflen size (although if someone gives
something insanely large, it can get capped), so EINVAL will only
happen for unknown flags.  I'll fix the suggested man page.

	       	   	   	   	    - Ted

P.S. The reason why OpenBSD had a very strong opinion about returning
EIO for buflen greater than 256 bytes was they really wanted to pound
it into application writers than if they were trying to fetch more
than 256 bytes, they were probably Doing Something Wrong, and they
decided EIO was less subtle that EINVAL....

