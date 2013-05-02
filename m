Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab3EBDmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 23:42:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36971 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab3EBDma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 23:42:30 -0400
Date: Thu, 2 May 2013 04:42:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Hogan <james.hogan@imgtec.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] linkage.h: fix build breakage due to symbol prefix
 handling
Message-ID: <20130502034226.GA27379@ZenIV.linux.org.uk>
References: <1367442257-7897-1-git-send-email-james.hogan@imgtec.com>
 <20130501214335.GB11630@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130501214335.GB11630@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 10:43:35PM +0100, Al Viro wrote:

> Oh, hell...  Guys, my deep apologies - what happened is that this thing
> has been caught in -next, rebase done here (on top of Rusty's commit)
> and *not* pushed to linux-next.

Curiouser and curiouser...  FWIW, what I have is
$ cat .git/refs/heads/linkage-fixed
898429c05290b8c05d035199f65a3bb034b34bb7
$ cat .git/refs/heads/remotes/next
898429c05290b8c05d035199f65a3bb034b34bb7
both being the aforementioned rebase;  I really wonder WTF had I been doing
that could've produced that...  How does git deal with that sort of
ambiguities?
$ git log remotes/next | head -3
commit 898429c05290b8c05d035199f65a3bb034b34bb7
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Mar 19 14:25:51 2013 -0400
$ git log remotes/next/master | head -3
commit d7c35d45ce991ae01b6008abef120173fc9c3814
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Tue Apr 30 16:26:41 2013 +1000
(the latter, of course, coming from remote for linux-next mirror)
