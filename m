Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab3EIQwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 12:52:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab3EIQwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 12:52:07 -0400
Date: Thu, 9 May 2013 12:50:28 -0400
From: David Teigland <teigland@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, swhiteho@redhat.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for May 8 (dlm)
Message-ID: <20130509165028.GA18077@redhat.com>
References: <20130508140122.e4747b58be4333060b7a248a@canb.auug.org.au>
 <518A93BD.3020300@infradead.org>
 <20130509094745.049e46fff25f357e7eb50123@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509094745.049e46fff25f357e7eb50123@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 09:47:45AM +1000, Stephen Rothwell wrote:
> [Just forwarding to David ...]
> 
> On Wed, 08 May 2013 11:04:45 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:
> >
> > on x86_64:
> > 
> > when CONFIG_GFS2_FS_LOCKING_DLM=y and CONFIG_DLM=m:
> > 
> > fs/built-in.o: In function `gfs2_lock':
> > file.c:(.text+0xa512c): undefined reference to `dlm_posix_get'
> > file.c:(.text+0xa5140): undefined reference to `dlm_posix_unlock'
> > file.c:(.text+0xa514a): undefined reference to `dlm_posix_lock'

gfs2/file.c calls the dlm directly, so I suppose gfs2 itself needs
to depend on the dlm.  It's been like this for a long time, so I
don't know why it only appeared now.

> > fs/built-in.o: In function `gdlm_cancel':
> > lock_dlm.c:(.text+0xb3f57): undefined reference to `dlm_unlock'
> > fs/built-in.o: In function `gdlm_unmount':
> > lock_dlm.c:(.text+0xb40ff): undefined reference to `dlm_release_lockspace'
> > fs/built-in.o: In function `sync_unlock.isra.4':
> > lock_dlm.c:(.text+0xb420d): undefined reference to `dlm_unlock'
> > fs/built-in.o: In function `sync_lock.isra.5':
> > lock_dlm.c:(.text+0xb42d9): undefined reference to `dlm_lock'
> > fs/built-in.o: In function `gdlm_put_lock':
> > lock_dlm.c:(.text+0xb45e7): undefined reference to `dlm_unlock'
> > fs/built-in.o: In function `gdlm_mount':
> > lock_dlm.c:(.text+0xb4928): undefined reference to `dlm_new_lockspace'
> > lock_dlm.c:(.text+0xb4c75): undefined reference to `dlm_release_lockspace'
> > fs/built-in.o: In function `gdlm_lock':
> > lock_dlm.c:(.text+0xb529f): undefined reference to `dlm_lock'

lock_dlm.c is GFS2_FS_LOCKING_DLM which depends on DLM.
Is that not correct?

Dave

