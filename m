Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbaG3M2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:28:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42852 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaG3M0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:26:23 -0400
Date: Wed, 30 Jul 2014 14:26:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org,
        deraadt@cvs.openbsd.org
Subject: Re: [PATCH -v4] random: introduce getrandom(2) system call
Message-ID: <20140730122620.GC13965@amd.pavel.ucw.cz>
References: <1405718127-30042-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405718127-30042-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The rationale of this system call is to provide resiliance against
> file descriptor exhaustion attacks, where the attacker consumes all
> available file descriptors, forcing the use of the fallback code where
> /dev/[u]random is not available.  Since the fallback code is often not
> well-tested, it is better to eliminate this potential failure mode
> entirely.

I'm not sure I understand the rationale; if someone can eat all your
file descriptors, he can make you stop working. So you can just stop
working when you can't open /dev/urandom, no?

Fallback code is probably very bad idea to use...

> The other feature provided by this new system call is the ability to
> request randomness from the /dev/urandom entropy pool, but to block
> until at least 128 bits of entropy has been accumulated in the
> /dev/urandom entropy pool.  Historically, the emphasis in the
> /dev/urandom development has been to ensure that urandom pool is
> initialized as quickly as possible after system boot, and preferably
> before the init scripts start execution.

Sounds like ioctl() for /dev/urandom for this behaviour would be nice?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
