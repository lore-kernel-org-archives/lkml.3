Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab3FCPd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:33:29 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:54433 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756694Ab3FCPd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:33:27 -0400
Date: Mon, 3 Jun 2013 11:33:23 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] jbd2: check bh->b_data for NULL in
 jbd2_journal_get_descriptor_buffer before memset()
Message-ID: <20130603153323.GB20009@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Ruslan Bilovol <ruslan.bilovol@ti.com>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1370253616-8173-1-git-send-email-ruslan.bilovol@ti.com>
 <1370253616-8173-2-git-send-email-ruslan.bilovol@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370253616-8173-2-git-send-email-ruslan.bilovol@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 01:00:15PM +0300, Ruslan Bilovol wrote:
> The memset() doesn't perform any NULL-pointer checking
> before dereferencing passed pointer so this should be
> checked before calling it.

I can see that __getblk() can return NULL if there is a memory
allocation failure (and is defined to do so), so checking to make sure
bh is not NULL is a good thing to do.

Have you actually seen a case where bh is non-NULL, but bh->b_data is
NULL?  If not, it might be better to do something like this:

>  	bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
	if (!bh)
		return NULL;
	BUG_ON(!bh->b_data);

						- Ted
