Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaJGGjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 02:39:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49597 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbaJGGjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 02:39:47 -0400
Date: Mon, 6 Oct 2014 23:39:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zach Brown <zab@zabbo.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] target/file: fix inclusive vfs_fsync_range() end
Message-ID: <20141007063945.GA4185@infradead.org>
References: <1412638813-13285-1-git-send-email-zab@zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412638813-13285-1-git-send-email-zab@zabbo.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 04:40:13PM -0700, Zach Brown wrote:
> Both of the file target's calls to vfs_fsync_range() got the end offset
> off by one.  The range is inclusive, not exclusive.  It would sync a bit
> more data than was required.
> 
> The sync path already tested the length of the range and fell back to
> LLONG_MAX so I copied that pattern in the rw path.
> 
> This is untested. I found the errors by inspection while following other
> code.

Maybe it's time to move vfs_fsync_range to a more normal calling
convention?
