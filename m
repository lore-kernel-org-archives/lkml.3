Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaIPRj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 13:39:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41025 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaIPRj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 13:39:56 -0400
Date: Tue, 16 Sep 2014 18:39:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Hogan <james.hogan@imgtec.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-fsdevel@vger.kernel.org, linux-metag@vger.kernel.org
Subject: Re: [PATCH] vfs: workaround gcc <4.6 build error in link_path_walk()
Message-ID: <20140916173951.GX7996@ZenIV.linux.org.uk>
References: <1410869255-8506-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410869255-8506-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 01:07:35PM +0100, James Hogan wrote:
> Commit d6bb3e9075bb (vfs: simplify and shrink stack frame of
> link_path_walk()) introduced build problems with GCC versions older than
> 4.6 due to the initialisation of a member of an anonymous union in
> struct qstr without enclosing braces.
> 
> This hits GCC bug 10676 [1] (which was fixed in GCC 4.6 by [2]), and
> causes the following build error:
>   fs/namei.c: In function 'link_path_walk':
>   fs/namei.c:1778: error: unknown field 'hash_len' specified in initializer
> 
> This is worked around by adding explicit braces.

IOW, the same thing QSTR_INIT is doing...  BTW, after looking at the commit
in question, what the hell was this
+                               name = this.name;
in link_path_walk() about?  Granted, none of the ->d_hash() instances in
the tree reassign qstr->name, and out-of-tree ones are unlikely to do it
either, so it's harmless but... why bother rereading this.name at all?
Linus?
