Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaJLRDf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 13:03:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39508 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaJLRDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 13:03:32 -0400
Date: Sun, 12 Oct 2014 10:03:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: Deduplicate code shared by xattr system calls
 operating on paths
Message-ID: <20141012170332.GA16885@infradead.org>
References: <1413133198-2386-1-git-send-email-ebiggers3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413133198-2386-1-git-send-email-ebiggers3@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 11:59:58AM -0500, Eric Biggers wrote:
> The following pairs of system calls dealing with extended attributes only
> differ in their behavior on whether the symbolic link is followed (when
> the named file is a symbolic link):
> 
> - setxattr() and lsetxattr()
> - getxattr() and lgetxattr()
> - listxattr() and llistxattr()
> - removexattr() and lremovexattr()
> 
> Despite this, the implementations all had duplicated code, so this commit
> redirects each of the above pairs of system calls to a corresponding
> function to which different lookup flags (LOOKUP_FOLLOW or 0) are passed.
> 
> For me this reduced the stripped size of xattr.o from 8824 to 8248 bytes.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
