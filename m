Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaBKQDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:03:08 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaBKQDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:03:06 -0500
Date: Tue, 11 Feb 2014 08:03:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: O_TMPFILE detection
Message-ID: <20140211160302.GA18936@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've started implementing support for O_TMPFILE in xfs_io in preparation
for proper testcases and found something rather annoying:

Given that we implicitly pass O_DIRECTORY as part of the full O_TMPFILE
flag an open using O_TMPFILE will simply succeed on a kernel old enough
to not have O_TMPFILE support, and give you a file descriptor for the
directory passed in.  Of course this only works if you open the fd
read-only which isn't all that useful for real temporary files, but it
would be the natural choice for a feature test.

I guess we can't really fix this up any more, but does anyone have a
good idea how to document this properly in the man page?
