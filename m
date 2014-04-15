Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaDORCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:02:30 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:19136 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbaDORC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:02:28 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsMNAFxlTVNXQzum/2dsb2JhbABYgwbENwICgSIXdIIlAQEBAwEnExwjBQsIAw4KLjkeBhOHdAwBzCUXjmMHhDgBA5hhAZJFgzM7
Date: Tue, 15 Apr 2014 19:04:21 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Christoph Hellwig <hch@infradead.org>
Cc: Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, jack <jack@suse.cz>,
        akpm <akpm@linux-foundation.org>, tytso <tytso@mit.edu>
Subject: Re: [PATCH 1/1] FS: Add generic data flush to fsync
Message-Id: <20140415190421.7dbf7ef08a545c6ab5538a5c@skynet.be>
In-Reply-To: <20140414072242.GE7860@infradead.org>
References: <20140411065242.42916952dd5d8e4e53848b3b@skynet.be>
	<20140411074522.GA15518@infradead.org>
	<20140411230530.984a9d57b3dec487af936d29@skynet.be>
	<20140414072242.GE7860@infradead.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014 00:22:42 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Apr 11, 2014 at 11:05:30PM +0200, Fabian Frederick wrote:
> > Ok, that would mean 'older' filesystems -without barrier flag-
> > to call generic_file_fsync would result in a flush but ext4 without journal 
> > also calls it ; maybe with nobarrier and I'm not sure it's the only case.
> > How can I deal with this problem ?
> 
> I don't really think not implementing the barrier option is a problem.
> For ext4 if you want consistency either opencode generic_file_fsync
> there and add the check, or add a __generic_file_fsync that doesn't
> do the flush.

I've been searching once again for generic_file_fsync callsites and EXT4
is the only filesystem with barrier flag calling generic_file_fsync.

If Ted or Jan could tell me whether EXT4 without journal can issue the flush 
(blkdev_issue_flush) whatever option has been chosen for 'barrier' (as that option stands for journal barrier) -> simple case, just add blkdev_issue_flush.

or if it requires looking at barrier flag in ext4/fsync.c
In that case I'd be interested to know how (needs_barrier is based on journal
flags) ... 

-> generic_file_fsync calls __generic_file_fsync (flush=true)
-> ext4 calls __generic_file_fsync(false) if nobarrier.
 
Fabian
