Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbaIEChy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 22:37:54 -0400
Received: from imap.thunk.org ([74.207.234.97]:39109 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbaIEChu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 22:37:50 -0400
Date: Thu, 4 Sep 2014 22:37:28 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Gioh Kim <gioh.kim@lge.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, adilger.kernel@dilger.ca, minchan@kernel.org,
        js1304@gmail.com, gunho.lee@lge.com
Subject: Re: [PATCHv4 1/3] fs.c: support buffer cache allocations with gfp
 modifiers
Message-ID: <20140905023728.GA1971@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Gioh Kim <gioh.kim@lge.com>, akpm@linux-foundation.org,
	jack@suse.cz, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com,
	peterz@infradead.org, adilger.kernel@dilger.ca, minchan@kernel.org,
	js1304@gmail.com, gunho.lee@lge.com
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
 <1409815781-28011-2-git-send-email-gioh.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409815781-28011-2-git-send-email-gioh.kim@lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 04:29:39PM +0900, Gioh Kim wrote:
> A buffer cache is allocated from movable area
> because it is referred for a while and released soon.
> But some filesystems are taking buffer cache for a long time
> and it can disturb page migration.
> 
> New APIs are introduced to allocate buffer cache
> with user specific flag.
> *_gfp APIs are for user want to set page allocation flag for page cache
> allocation.
> And *_unmovable APIs are for the user wants to allocate page cache from
> non-movable area.
> 
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, I've applied this to the ext4 git tree with a slightly
rewritten commit description (for clarity).

						- Ted
