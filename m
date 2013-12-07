Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3LGC1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 21:27:46 -0500
Received: from dmz-mailsec-scanner-1.mit.edu ([18.9.25.12]:45960 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029Ab3LGC1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 21:27:45 -0500
X-AuditID: 1209190c-b7f7f6d000000bbd-1e-52a287a0a1eb
Date: Fri, 6 Dec 2013 21:27:42 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [3.13 PATCH 0/2] random: bytes vs. bits
Message-ID: <cover.1386382885.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsUixG6nrrugfVGQwaNmeYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJVx6u8M1oK9nBVbFixlaWC8wt7FyMkhIWAicfDhXxYIW0ziwr31
	bF2MXBxCArOZJNb/2gDlbGCUOLP0PzuE85NRYn5DIxNIC4uAisTmXceZQWw2AQWJH/PXgdki
	AsoSq2ZuAqthBor/ureJFcQWFjCQaLgxiw3E5gWypx9sZYSwBSVOznzCAlGvJXHj30ugXg4g
	W1pi+T8OkLAo0KopJ7exTWDkn4WkYxaSjlkIHQsYmVcxyqbkVunmJmbmFKcm6xYnJ+blpRbp
	GurlZpbopaaUbmIEBR6nJM8OxjcHlQ4xCnAwKvHwXrBaFCTEmlhWXJl7iFGSg0lJlNe9DSjE
	l5SfUpmRWJwRX1Sak1p8iFGCg1lJhHenGlCONyWxsiq1KB8mJc3BoiTOe5PDPkhIID2xJDU7
	NbUgtQgmK8PBoSTB2wsyVLAoNT21Ii0zpwQhzcTBCTKcB2h4IkgNb3FBYm5xZjpE/hSjopQ4
	bztIQgAkkVGaB9cLSwyvGMWBXhHmXQBSxQNMKnDdr4AGMwENbn4wD2RwSSJCSqqB0e7rvNqz
	PH0/fh7kMC1bUTu5enORQvOaI6drS/bv7A37eH7eg2eN3tzTr297uWtzg/+W2/6yf2PsZqat
	tNR9z9v17UL/Lqf6xWzl0o71x+ZEyX34xhhULeLBzqzitfvE/u+37d6osc4QXB7D83XiZr9z
	a9+VmjEyLfwo+2z2HvcMN+7Cux8KVJVYijMSDbWYi4oTARBXax3nAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new when-to-push logic in v3.13-rc1~61^2~6 "random: push extra
entropy to the output pools" uses the name "entropy_bytes" for a
quantity that's actually in bits.  This results in confusing,
buggy-looking lines both where the variable is set and where it's
used.  Fortunately it's all consistent if the variable is understood
as counting bits, so the behavior is fine.

This code is new in v3.13-rc1, so fixing the name seems in order for
3.13.  The first patch here just does that.

One cause of the mistake is probably that the names of
random_read_wakeup_thresh and random_write_wakeup_thresh don't
indicate what units they're in.  This is an especially acute issue now
that we have three units for entropy in different places -- bytes,
bits, and 1 / (1 << ENTROPY_SHIFT) fractions of a bit.  The second
patch clarifies the units in both names.  (Maybe other names should be
clarified too.)  This may as well be post-3.13.

Cheers,
Greg


Greg Price (2):
  random: entropy_bytes is actually bits
  random: clarify bits/bytes in wakeup thresholds

 drivers/char/random.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

-- 
1.8.3.2
