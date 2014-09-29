Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaI2Tij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:38:39 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59992 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbaI2Tii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:38:38 -0400
Date: Mon, 29 Sep 2014 15:38:23 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, linux-karma-devel@lists.sourceforge.net,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V2 resend] FS/OMFS: block number sanity check during
 fill_super operation
Message-ID: <20140929193823.GJ6835@localhost>
References: <1412010428-10642-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412010428-10642-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 07:07:08PM +0200, Fabian Frederick wrote:
> This patch defines maximum block number to 2^31.
> It also converts bitmap_size and array_size to
> unsigned int in omfs_get_imap
> 
> Suggested-By: Linus Torvalds <torvalds@linux-foundation.org>
> Suggested-By: Bob Copeland <me@bobcopeland.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Bob Copeland <me@bobcopeland.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> This is untested.

Acked-by: Bob Copeland <me@bobcopeland.com>

I also gave it a quick test.  For just plain corruption of s_num_blocks,
there's a later check that one would normally hit since the number is
stored in a second place, and we compare them.  But if both
omfs_rb->r_num_blocks and sbi->s_num_blocks are the same insane number, I
agree we should give up here.

-- 
Bob Copeland %% www.bobcopeland.com
