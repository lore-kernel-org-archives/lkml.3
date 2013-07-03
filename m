Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3GCLfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:35:24 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:34793 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129Ab3GCLfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:35:23 -0400
Date: Wed, 3 Jul 2013 07:35:20 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ext4 updates for 3.11
Message-ID: <20130703113520.GA21189@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <nsxbo6mxu38.fsf@lambda.thunk.org>
 <CA+55aFyRLc81s03ULLZ26N0qwRqxS-9+6XpyhxVH62qx2b5o2A@mail.gmail.com>
 <20130702180447.GB16282@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130702180447.GB16282@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 08:04:47PM +0200, Jan Kara wrote:
>   That's caused by my patches (only for certain gcc versions). map->m_len
> is guaranteed to be > 0 in the first iteration (the function is called from
> under if (map->m_len > 0)). I though Ted silenced that warning but
> apparently he did not. The cleanest fix is likely to make a do-while loop
> from that one. I'll send Ted a patch for that.

Sorry, I fixed it with a code simplification (I thought the while loop
wasn't needed at all), but when you explained why in fact we still
needed it, I dropped my commit, and forgot that this also dropped the
fix which silenced the warning.  I'll grab your patch and included
with any other fixes that we might need for this merge window.

Linus, are you in a hurry to get this fixed up?  It's a false warning
on gcc's part, so it's not actually causing any actual problems.  If
not, I can wait until a week or so to see if there are any other bug
fixes that are required and push the fix to you towards the end of the
merge window.

							- Ted
