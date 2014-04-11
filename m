Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbaDKNAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:00:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbaDKNAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:00:33 -0400
Date: Fri, 11 Apr 2014 15:00:27 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Fabian Frederick <fabf@skynet.be>, Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, jack <jack@suse.cz>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] FS: Add generic data flush to fsync
Message-ID: <20140411130027.GA15758@quack.suse.cz>
References: <20140411065242.42916952dd5d8e4e53848b3b@skynet.be>
 <20140411074522.GA15518@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140411074522.GA15518@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 11-04-14 00:45:22, Christoph Hellwig wrote:
> On Fri, Apr 11, 2014 at 06:52:42AM +0200, Fabian Frederick wrote:
> > Currently, there's no generic HW flush management support in kernel.
> > Only 7 filesystems have their own way to manage the barrier flag.
> > 
> > This patch adds MS_BARRIER in sb_flags and conditionnaly issues the flush
> > in generic_file_fsync.
> 
> Please don't add a binary mount option for something thast already is a
> text option in many filesystems.  We can actually enable/disable cache
> flushes at the block device level, so I think this can be
> unconditional.
  How can those be disabled? I didn't find that by a quick look through
/sys and flush code in kernel...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
