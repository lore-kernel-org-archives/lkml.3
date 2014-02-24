Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaBXNpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:45:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:52328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbaBXNp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:45:29 -0500
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Feb 2014 08:45:29 EST
From: Arnd Bergmann <arnd@arndb.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>, Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] bug: When !CONFIG_BUG, simplify WARN_ON_ONCE and family
Date: Mon, 24 Feb 2014 14:39:46 +0100
Message-ID: <16994526.0QcMcz0xo0@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140224131605.3bd7febc@alan.etchedpixels.co.uk>
References: <20140224084437.GG20680@thin> <1747419.6FxgzfPen0@wuerfel> <20140224131605.3bd7febc@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:gFNSku5hHX2ZB+ZmQtzi2mCXExtYvOkwAWeYSJDgKnW
 cAqxqFs7sXAHE7VW3oAcI7U7/rjYT5wVPZXbPbEElV2ItsBweo
 waUGM1lJhl+PFzXBoLHq+3/4IJeEOkzoqf95+iD6aGpw/ifhIU
 cOXcjUIITo+b40h8WsgpsTicnNt3KrElixSX1mJVORHzvjN8XQ
 S6xZTV7ZPUDARz6ygR0rWdPDYvNyVqCf/W1/aut+QmYLUTkbXw
 yJGC6N66TvkT0HOqhDHCznllY5kwL6BLANuQhmREfPxYtjmey0
 B+j0QrisUDy+kiU531/iC3WmvPKWgIMzG1QweIVpCw5MQDQC9S
 3QNayYqZVJ/OxgTZ2sVs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 February 2014 13:16:05 One Thousand Gnomes wrote:
> 
> While I agree defining it as do {} while(1); would be a lot smarter,
> simply making it required that a platform provides an implementation of
> BUG() would be even better. 

But how do we get there? The majority of architectures define BUG()
already, but a lot of them only if CONFIG_BUG is enabled. That is
of course trivial do change, and it is what my older patch does
for ARM and x86.

We also have seven architectures without a BUG() implementation (c6x,
m32r, meta, microblaze, score, sh, unicore32) and six more (arm64,
hexagon openrisc tile um xtensa) that have no bug.h at all.

	Arnd
