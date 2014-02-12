Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaBLQ3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:29:10 -0500
Received: from imap.thunk.org ([74.207.234.97]:57103 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbaBLQ3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:29:08 -0500
Date: Wed, 12 Feb 2014 11:29:04 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Azat Khuzhin <a3at.mail@gmail.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] ext4: initialize multi-block allocator before
 checking block descriptors
Message-ID: <20140212162904.GD14520@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Azat Khuzhin <a3at.mail@gmail.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	open list <linux-kernel@vger.kernel.org>
References: <1392128652-6882-1-git-send-email-a3at.mail@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392128652-6882-1-git-send-email-a3at.mail@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 06:24:12PM +0400, Azat Khuzhin wrote:
> With EXT4FS_DEBUG ext4_count_free_clusters() will call
> ext4_read_block_bitmap() without s_group_info initialized, so we need to
> initialize multi-block allocator before.
> 
> And we can't initialize multi-block allocator without group descriptors,
> since it use them.
> Also we need to install s_op before initializing multi-block allocator,
> because in ext4_mb_init_backend() new inode is created.

Applied, thanks.

					- Ted
