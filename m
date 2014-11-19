Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbaKSVaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:30:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56626 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345AbaKSVaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:30:08 -0500
Date: Wed, 19 Nov 2014 21:30:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] situation with csum_and_copy_... API
Message-ID: <20141119213006.GE7996@ZenIV.linux.org.uk>
References: <20141118212307.GU7996@ZenIV.linux.org.uk>
 <20141119.153136.867017618826698045.davem@davemloft.net>
 <CA+55aFyQR2gOzEDROcWFcQzLvTjOxyJRjFJXJ03JB5knd-Gsgg@mail.gmail.com>
 <20141119.161744.1661940121298888832.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119.161744.1661940121298888832.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 04:17:44PM -0500, David Miller wrote:
> > Seeing a "__get_user()" and just being able to glance up in the same
> > function and seeing the "access_ok()" is just a good safety net. And
> > means that people don't have to waste time thinking about or looking
> > for where the hell the security net really is.
> 
> Fair enough.

OK, with 3/5 dropped 4/5 get a trivial conflict (removal of function in 4/5
vs. change in it in 3/5).  With that dealt with, the sucker is in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-davem

Shortlog:
Al Viro (4):
      separate kernel- and userland-side msghdr
      {compat_,}verify_iovec(): switch to generic copying of iovecs
      fold verify_iovec() into copy_msghdr_from_user()
      bury skb_copy_to_page()

Diffstat:
 arch/arm/kernel/sys_oabi-compat.c |    4 +--
 include/linux/socket.h            |   17 +++++++---
 include/linux/syscalls.h          |    6 ++--
 include/net/compat.h              |    5 ++-
 include/net/sock.h                |   23 -------------
 net/compat.c                      |   83 +++++++++++++++-------------------------------
 net/core/iovec.c                  |   47 --------------------------
 net/socket.c                      |  140 +++++++++++++++++++++++++++++++++++++-----------------------------------------
 8 files changed, 114 insertions(+), 211 deletions(-)

I'll post more for review after I finally get some sleep - up for bloody 27
hours by now ;-/
