Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbaIEDw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 23:52:58 -0400
Received: from imap.thunk.org ([74.207.234.97]:39200 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbaIEDw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 23:52:56 -0400
Date: Thu, 4 Sep 2014 23:17:35 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Gioh Kim <gioh.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>,
        jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, adilger.kernel@dilger.ca, minchan@kernel.org,
        gunho.lee@lge.com
Subject: Re: [PATCHv4 0/3] new APIs to allocate buffer-cache with user
 specific flag
Message-ID: <20140905031735.GD1971@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Gioh Kim <gioh.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
	paulmck@linux.vnet.ibm.com, peterz@infradead.org,
	adilger.kernel@dilger.ca, minchan@kernel.org, gunho.lee@lge.com
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
 <20140904151612.7bf5b813069ff78973e01571@linux-foundation.org>
 <540905B1.1050200@lge.com>
 <20140905011419.GE4364@thunk.org>
 <20140905014808.GA26070@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905014808.GA26070@js1304-P5Q-DELUXE>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonson,

Thanks for the update.  I've applied Gioh's patches to the ext4 tree,
but I'd appreciate a further clarification.  My understanding with the
problem you were trying to address is that with the current CMA
implementation, kswapd was getting activiated too early, yes?

But it would still be a good idea to try to use non-moveable memory in
preference in favor of CMA memory; even if the page migration can move
the contents of the page elsewhere, wouldn't be better to avoid
needing to do the page migation in the first place.  Given that the
ext4 file systems are getting mounted very early in the boot process,
when there should be plenty of CMA and non-CMA elegible memory
available, why was CMA memory getting selected for the buffer cache
allocations when non-CMA memory available?

In other words, even without Gioh's patch to force the use of non-CMA
eligible memory, wouldn't it be better if the memory allocator used
non-CMA preferentially if it were available.  This should be
orthogonal to whether or not kswaped gets activiated, right?

Regards,

							- Ted
