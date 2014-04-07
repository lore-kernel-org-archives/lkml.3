Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaDGOhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:37:20 -0400
Received: from imap.thunk.org ([74.207.234.97]:51104 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbaDGOhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:37:18 -0400
Date: Mon, 7 Apr 2014 10:37:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Azat Khuzhin <a3at.mail@gmail.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] ext4: initialize multi-block allocator before
 checking block descriptors
Message-ID: <20140407143715.GB25478@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Azat Khuzhin <a3at.mail@gmail.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	open list <linux-kernel@vger.kernel.org>
References: <1396712916-6296-1-git-send-email-a3at.mail@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396712916-6296-1-git-send-email-a3at.mail@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2014 at 07:48:36PM +0400, Azat Khuzhin wrote:
> With EXT4FS_DEBUG ext4_count_free_clusters() will call
> ext4_read_block_bitmap() without s_group_info initialized, so we need to
> initialize multi-block allocator before.
> 
> And dependencies that must be solved, to allow this:
> - multi-block allocator needs in group descriptors
> - need to install s_op before initializing multi-block allocator,
>   because in ext4_mb_init_backend() new inode is created.
> - initialize number of group desc blocks (s_gdb_count) otherwise
>   number of clusters returned by ext4_free_clusters_after_init() is not correct.
>   (see ext4_bg_num_gdb_nometa())

Thanks, applied.

					- Ted
