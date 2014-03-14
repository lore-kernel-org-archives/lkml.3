Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaCNEvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 00:51:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49875 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaCNEvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 00:51:15 -0400
Date: Fri, 14 Mar 2014 04:51:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: NeilBrown <neilb@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] fs: fix i_writecount on shmem and friends
Message-ID: <20140314045105.GN18016@ZenIV.linux.org.uk>
References: <1393859798-1407-1-git-send-email-dh.herrmann@gmail.com>
 <CA+55aFwzBoTc+09jZTGjfTQTfkgZwrN5m09snb+F9inLaDn0OA@mail.gmail.com>
 <20140312181925.GK18016@ZenIV.linux.org.uk>
 <20140313150800.07878c80@notabene.brown>
 <20140313042934.GM18016@ZenIV.linux.org.uk>
 <20140313165541.2b23dc96@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313165541.2b23dc96@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 04:55:41PM +1100, NeilBrown wrote:

> Can we do direct writes from kernel space yet?  If so I'll change the code to
> do that so that it will work with any filesystem (which supports direct
> writes).

You can - see __swap_writepage() (mm/page_io.c).  However, that area is
about to get a lot of massage, so it would make sense to wait a bit...

> (The documentation says we that bitmap files should only be used on ext2 or
> ext3.  Most people use bitmaps on the raw devices so hopefully the few who
> have a need for files will read the documentation :-)
> 
> (and yes, I check for FMODE_WRITE)

Umm...  Where?
