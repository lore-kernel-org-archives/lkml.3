Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbbAWWaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:30:12 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57969 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbbAWWaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:30:09 -0500
Date: Fri, 23 Jan 2015 14:30:05 -0800
From: josh@joshtriplett.org
To: "Theodore Ts'o" <tytso@mit.edu>, Tom Zanussi <tom.zanussi@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] drivers/char: Support compiling out the
 getrandom(2) syscall
Message-ID: <20150123223005.GA1489@cloud>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
 <87fec26efb0a0e4a8daab238ee39261dca2dc985.1422035184.git.tom.zanussi@linux.intel.com>
 <20150123194610.GD8709@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123194610.GD8709@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 02:46:10PM -0500, Theodore Ts'o wrote:
> On Fri, Jan 23, 2015 at 12:37:16PM -0600, Tom Zanussi wrote:
> > Many embedded systems have no use for getrandom, and could benefit
> > from the size savings gained by omitting it.  Add a new EXPERT config
> > option, CONFIG_GETRANDOM_SYSCALL (default y), to support compiling it
> > out.
> 
> I'm really not sure this is a good idea.  Even the tiniest embedded
> device need secure crypto.
[...]
> We know already that home routers are running ancient kernels that are
> absolutely no protection whatever.  Is saving a few bytes really worth
> potentially opening up a similar attack vector on devices that will
> probably be at least an order of magnitude or more numerous than home
> routers, and even harder to upgrade once they get out there?
> 
> And if you don't have a good random number generator, you really are
> *toast*.
> 
> It's for this reason that /dev/[u]random were not eligible from being
> disabled from the very beginning; it's too much of an attractive
> nuisance to a clueless product manager....

Forcing the availability of the random devices and getrandom syscall
will not force userspace to actually *use* them, and there do exist real
devices that do not need them.

We're not yet talking about the full in-kernel entropy infrastructure,
which should also be removable *if* you aren't using it for CONFIG_NET
or similar.  We're talking about the userspace interfaces.  If you
aren't running any userspace bits that open /dev/*random or that call
getrandom, forcing the existence of those devices will not magically
make the system more secure.  Not all userspaces actually need
randomness, and some of those that do have better alternatives than
/dev/*random or getrandom (such as hardware RNGs).

- Josh Triplett
