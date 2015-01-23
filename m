Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbbAWTqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:46:17 -0500
Received: from imap.thunk.org ([74.207.234.97]:57891 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbbAWTqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:46:15 -0500
Date: Fri, 23 Jan 2015 14:46:10 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: josh@joshtriplett.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] drivers/char: Support compiling out the
 getrandom(2) syscall
Message-ID: <20150123194610.GD8709@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Tom Zanussi <tom.zanussi@linux.intel.com>, josh@joshtriplett.org,
	linux-kernel@vger.kernel.org
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
 <87fec26efb0a0e4a8daab238ee39261dca2dc985.1422035184.git.tom.zanussi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fec26efb0a0e4a8daab238ee39261dca2dc985.1422035184.git.tom.zanussi@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 12:37:16PM -0600, Tom Zanussi wrote:
> Many embedded systems have no use for getrandom, and could benefit
> from the size savings gained by omitting it.  Add a new EXPERT config
> option, CONFIG_GETRANDOM_SYSCALL (default y), to support compiling it
> out.

I'm really not sure this is a good idea.  Even the tiniest embedded
device need secure crypto.  In fact, one could argue that in the case
of the Internet of Things, the tiniests embedded devices
**especially** need secure crypto.  It would be.... unfortunate.... if
the next time North Korea gets upset at the Great Satan, that all of
our light bulbs, refridgerators, cars, heating systems, etc., are
subject to attack.

We know already that home routers are running ancient kernels that are
absolutely no protection whatever.  Is saving a few bytes really worth
potentially opening up a similar attack vector on devices that will
probably be at least an order of magnitude or more numerous than home
routers, and even harder to upgrade once they get out there?

And if you don't have a good random number generator, you really are
*toast*.

It's for this reason that /dev/[u]random were not eligible from being
disabled from the very beginning; it's too much of an attractive
nuisance to a clueless product manager....

	     	  	    	    	 - Ted
