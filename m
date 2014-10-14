Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbaJNLft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 07:35:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56702 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbaJNLfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:35:48 -0400
Date: Tue, 14 Oct 2014 04:35:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/4] ext4: Add fdatasync scalability optimization
Message-ID: <20141014113547.GB3926@infradead.org>
References: <1413281035-6483-1-git-send-email-dmonakhov@openvz.org>
 <1413281035-6483-5-git-send-email-dmonakhov@openvz.org>
 <20141014105729.GA19981@infradead.org>
 <87oateq4e5.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87oateq4e5.fsf@openvz.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 03:25:54PM +0400, Dmitry Monakhov wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
> > Much of the bookkeeping here seems generic and should be in common
> > code and not inside a filesystem.
> Yes. But this means that I need to store flush_id inside generic inode
> which likely will be accepted negatively because VFS people do not like
> inode bloating. But if you are OK then I'll prepare the patch.

With my "VFS person critical of struct inode size increases" hat on
I'm still critical of any struct inode increase, so if you can find
an option that say just takes the address of the counter variable
I'd prefer that.  But even if we have to increase the inode this might
be one of the cases where it's fine as cache flushing is something
at least all on disk filesystems need to do.
