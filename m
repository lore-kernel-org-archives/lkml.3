Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaIECiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 22:38:01 -0400
Received: from imap.thunk.org ([74.207.234.97]:39116 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbaIEChx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 22:37:53 -0400
Date: Thu, 4 Sep 2014 22:37:45 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Gioh Kim <gioh.kim@lge.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, adilger.kernel@dilger.ca, minchan@kernel.org,
        js1304@gmail.com, gunho.lee@lge.com
Subject: Re: [PATCHv4 3/3] jbd/jbd2: use non-movable memory for the jbd
 superblock
Message-ID: <20140905023745.GC1971@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Gioh Kim <gioh.kim@lge.com>, akpm@linux-foundation.org,
	jack@suse.cz, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com,
	peterz@infradead.org, adilger.kernel@dilger.ca, minchan@kernel.org,
	js1304@gmail.com, gunho.lee@lge.com
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
 <1409815781-28011-4-git-send-email-gioh.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409815781-28011-4-git-send-email-gioh.kim@lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 04:29:41PM +0900, Gioh Kim wrote:
> A long-lasting buffer-cache can distrub page migration so that
> it must be allocated from non-movable area.
> 
> The journal_init_inode is creating a buffer-cache for superblock journaling.
> The superblock exists until system shutdown so that the buffer-cache
> for the superblock would also exist for a long time
> and it can distrub page migration.
> 
> This patch make the buffer-cache be allocated from non-movable area
> not to distrub page migration.
> 
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, I've applied this to the ext4 git tree with a slightly
rewritten commit description (for clarity).

						- Ted
