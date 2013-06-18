Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab3FRQB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:01:27 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:59072 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648Ab3FRQBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:01:25 -0400
Date: Tue, 18 Jun 2013 12:01:20 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: Re: [ext3,ext4] old bug in htree_dirblock_to_tree()
Message-ID: <20130618160120.GG7359@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
References: <20130617152338.GS4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617152338.GS4165@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 04:23:38PM +0100, Al Viro wrote:
> 	Both ext3 and ext4 htree_dirblock_to_tree() is just filling
> the in-core rbtree for use by call_filldir().  All updates of
> ->f_pos are done by the latter; bumping it here (on error) is obviously
> wrong - we might very well have it nowhere near the block we'd found
> an error in.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Applied, thanks.  Nice catch!

Jan, I'll carry the fix for ext3 as well in the ext4 tree, unless
you'd prefer otherwise.

					- Ted
