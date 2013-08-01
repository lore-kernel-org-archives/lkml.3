Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3HAJAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 05:00:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43527 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab3HAJAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 05:00:47 -0400
Date: Thu, 1 Aug 2013 02:00:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs.git, part 1
Message-ID: <20130801090046.GB21552@infradead.org>
References: <20130701195949.GI4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701195949.GI4165@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 08:59:49PM +0100, Al Viro wrote:
> The major change in that pile is ->readdir() replacement with ->iterate(),
> dealing with ->f_pos races in ->readdir() instances for good.  There's
> a lot more, but I'd prefer to split the pull request into several stages
> and this is the first obvious cutoff point.  Please, pull from the
> usual place - 
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Again a little later, but iterate seems like a bad choice for a
directory specific operation in struct file operations, it really
should have "dir" somewhere in the method name.

