Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932AbaCTPdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:33:20 -0400
Received: from imap.thunk.org ([74.207.234.97]:44088 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932796AbaCTPdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:33:10 -0400
Date: Thu, 20 Mar 2014 11:32:51 -0400
From: tytso@mit.edu
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>, Kristian@thunk.org,
        =?iso-8859-1?Q?H=F8gsberg_=3Ckrh=40bitplanet=2Enet=3E?=@thunk.org,
        john.stultz@linaro.org, Greg Kroah-Hartman <greg@kroah.com>,
        Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
Message-ID: <20140320153250.GC20618@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	David Herrmann <dh.herrmann@gmail.com>, linux-kernel@vger.kernel.org,
	Hugh Dickins <hughd@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <matthew@wil.cx>,
	Karol Lewandowski <k.lewandowsk@samsung.com>,
	Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
	Lennart Poettering <lennart@poettering.net>, Kristian@thunk.org,
	=?iso-8859-1?Q?H=F8gsberg_=3Ckrh=40bitplanet=2E?=@thunk.org,
	=?iso-8859-1?Q?net=3E?=@thunk.org, john.stultz@linaro.org,
	Greg Kroah-Hartman <greg@kroah.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ryan Lortie <desrt@desrt.ca>,
	"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 08:06:45PM +0100, David Herrmann wrote:
> 
> This series introduces the concept of "file sealing". Sealing a file restricts
> the set of allowed operations on the file in question. Multiple seals are
> defined and each seal will cause a different set of operations to return EPERM
> if it is set. The following seals are introduced:
> 
>  * SEAL_SHRINK: If set, the inode size cannot be reduced
>  * SEAL_GROW: If set, the inode size cannot be increased
>  * SEAL_WRITE: If set, the file content cannot be modified

Looking at your patches, and what files you are modifying, you are
enforcing this in the low-level file system.

Why not make sealing an attribute of the "struct file", and enforce it
at the VFS layer?  That way all file system objects would have access
to sealing interface, and for memfd_shmem, you can't get another
struct file pointing at the object, the security properties would be
identical.

Cheers,

						- Ted
