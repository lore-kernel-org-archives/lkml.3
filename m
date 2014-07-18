Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbaGRHQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:16:17 -0400
Received: from imap.thunk.org ([74.207.234.97]:42529 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283AbaGRHQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:16:14 -0400
Date: Fri, 18 Jul 2014 02:23:56 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] random: limit the contribution of the hw rng to at most
 half
Message-ID: <20140718062356.GC1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <1405591436-15445-1-git-send-email-tytso@mit.edu>
 <53C80A6D.5010201@zytor.com>
 <20140717220806.GW1491@thunk.org>
 <53C85D50.5040901@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C85D50.5040901@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 04:33:36PM -0700, H. Peter Anvin wrote:
> 
> I just want to make sure we don't negatively impact the real security of
> users because of "optics".  We already have a lot of problems with
> people extracting long-living keys from /dev/urandom because /dev/random
> is too slow.

With a system with RDRAND, we're mixing arch_get_rand_long() as part
of the extraction process (as the seed for the SHA's IV).  So if you
trust RDRAND, then using /dev/urandom even when the entropy count is
zero is going to be secure.  If you don't trust RDRAND, then the
RDSEED entropy accounting is going to be extremely disturbing.

So the only way that we could be impacting the "real security" of
users, would be if RDRAND was back-doored, but RDSEED wasn't.  And
that doesn't seem like a terribly likely scenario to me, but what do I
know?  :-)

						- Ted
