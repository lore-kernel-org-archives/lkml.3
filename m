Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbbAHLtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 06:49:52 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:34073 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465AbbAHLtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 06:49:51 -0500
Date: Thu, 8 Jan 2015 03:49:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Milosz Tanski <milosz@adfin.com>
Subject: pread2/ pwrite2
Message-ID: <20150108114950.GB3351@infradead.org>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
 <20141210140347.GA23252@infradead.org>
 <20141210141211.GD2220@wil.cx>
 <20150105184143.GA665@infradead.org>
 <20150106004714.6d63023c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106004714.6d63023c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 12:47:14AM -0800, Andrew Morton wrote:
> > progress, which is a bit frustrating.
> 
> I took a look at pread2() as well and I have two main issues:
> 
> - The patchset includes a pwrite2() syscall which has nothing to do
>   with nonblocking reads and which was poorly described and had little
>   justification for inclusion.

It allows to do O_SYNC writes on a per-I/O basis.  This is very useful
for file servers (smb, cifs) as well as storage target devices.

Note: that part was my addition, and the complaint about lacking
description ever made it to me.  Can you point to the relevant
questions?

> - We've talked for years about implementing this via fincore+pread
>   and at least two fincore implementations are floating about.  Now
>   along comes pread2() which does it all in one hit.
> 
>   Which approach is best?  I expect fincore+pread is simpler, more
>   flexible and more maintainable.  But pread2() will have lower CPU
>   consumption and lower average-case latency.

fincore+pread is inherently racy and thus entirely unsuitable for the
use case of a non-blockign main thread.

Nevermind that the pread2 path is way simpler than any of the proposed
fincore patches.
