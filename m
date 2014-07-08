Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbaGHMMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:12:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34034 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaGHMMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:12:30 -0400
Date: Tue, 8 Jul 2014 05:12:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
Cc: linux-kernel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>, linux-man@vger.kernel.org
Subject: Re: [PATCH 1/1] include/uapi: Define AT_FDNODIR constant as future
 guarantee
Message-ID: <20140708121229.GA21107@infradead.org>
References: <fb469d6277ef.53b85737@langara.bc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb469d6277ef.53b85737@langara.bc.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2014 at 07:51:19PM +0000, Steven Stewart-Gallus wrote:
> From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca
> 
> This constant means that in the far future it might be possible to
> define other AT_FD* constants.
> 
> Signed-off-by: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
> ---
> 
> This is my first kernel patch but this is really trivial so I hope I'm doing
> this right.

Almost.  For one you really should explain what the flag does,
especially if it's not actually use.

It took me a while that you're trying to document the way Linux
currently behaves for the cases where the dfd argument to the various
*at is neither a valid file descriptor nor the magic AT_FDCWD constant.

Posix says that openat with an absolute path is equivalent to open, so
the only strictly allowed other flags would those that allow some form
of relative path, but treat it differently than the currently possible
options.  I can't really think of a good way to do that, although we
recently had a case where a different AT_* value would be useful, even
if not fully conforming to that Posix wording.

Your explanation of what this constant does should also go into the man
page, so in addition to the kernel patch you should also propose a patch
to the man page documenting it.

Also I don't think AT_FDNODIR is a good choice of name, AT_ABSOLUTE
would be a lot more descriptive.

