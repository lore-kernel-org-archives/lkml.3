Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbaAJTVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 14:21:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39267 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaAJTVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 14:21:16 -0500
Message-ID: <52D04820.4090500@infradead.org>
Date: Fri, 10 Jan 2014 11:21:04 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dominique Martinet <dominique.martinet@cea.fr>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        v9fs-developer@lists.sourceforge.net
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] 9P: introduction of a new cache=mmap model.
References: <1389357849-20367-1-git-send-email-dominique.martinet@cea.fr>
In-Reply-To: <1389357849-20367-1-git-send-email-dominique.martinet@cea.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 04:44 AM, Dominique Martinet wrote:
>  - Add cache=mmap option

Seems to be missing a documentation update to Documentation/filesystems/9p.txt.

>  - Make mmap read-write while keeping it as synchronous as possible
>  - Build writeback fid on mmap creation if it is writable
> 
> Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
> Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
> ---
> 
> The patch has been taken into next-20131105 (commit 94876b5) but has
> apparently been dropped because of a conflict?
> Anyway, this is the very same patch as last time with the conflict solved
> (conflicting patch was ceaec15d4
> "9p: make v9fs_cache_inode_{get,put,set}_cookie empty inlines for !9P_CACHEFS")
> 
> The patch applies on linus' master, next's master, and has been retested
> on top of 3.13.0-rc7.
> 
> Sorry if I was supposed to drop Eric's sign-off due to the minor edit!
> 
> 
>  fs/9p/v9fs.c           |   9 +++-
>  fs/9p/v9fs.h           |   1 +
>  fs/9p/v9fs_vfs.h       |   2 +
>  fs/9p/vfs_addr.c       |   7 +++
>  fs/9p/vfs_file.c       | 140 +++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/9p/vfs_inode.c      |  22 +++++---
>  fs/9p/vfs_inode_dotl.c |   9 ++--
>  fs/9p/vfs_super.c      |   8 +--
>  8 files changed, 179 insertions(+), 19 deletions(-)


-- 
~Randy
