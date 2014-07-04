Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbaGDUWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 16:22:04 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:42642 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaGDUWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 16:22:03 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH 1/1] ntfs: kernel-doc warning fixes
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <anton@tuxera.com>
In-Reply-To: <1404503598-32536-1-git-send-email-fabf@skynet.be>
Date: Fri, 4 Jul 2014 21:21:55 +0100
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-ntfs-dev@lists.sourceforge.net
Content-Transfer-Encoding: 8BIT
Message-Id: <A2B2CD07-AC72-48F0-8176-E25A39F2850A@tuxera.com>
References: <1404503598-32536-1-git-send-email-fabf@skynet.be>
To: Fabian Frederick <fabf@skynet.be>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks good, thanks.  Feel free to add:

Acked-by: Anton Altaparmakov <anton@tuxera.com>

Andrew, could you please take it in your tree for merging?

Thanks a lot in advance!

Best regards,

	Anton

On 4 Jul 2014, at 20:53, Fabian Frederick <fabf@skynet.be> wrote:

> cached_page and lru_pvec were removed from
> ntfs_attr_extend_initialized in commit 2ec93b0bf35f
> ("ntfs: clean up ntfs_attr_extend_initialized")
> 
> lru_pvec has been removed from __ntfs_grab_cache_pages in commit 4c99000ac47c
> ("ntfs: use add_to_page_cache_lru()")
> 
> Cc: Anton Altaparmakov <anton@tuxera.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-ntfs-dev@lists.sourceforge.net
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> fs/ntfs/file.c | 3 ---
> 1 file changed, 3 deletions(-)
> 
> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
> index 5c9e2c8..f5ec1ce 100644
> --- a/fs/ntfs/file.c
> +++ b/fs/ntfs/file.c
> @@ -74,8 +74,6 @@ static int ntfs_file_open(struct inode *vi, struct file *filp)
>  * ntfs_attr_extend_initialized - extend the initialized size of an attribute
>  * @ni:			ntfs inode of the attribute to extend
>  * @new_init_size:	requested new initialized size in bytes
> - * @cached_page:	store any allocated but unused page here
> - * @lru_pvec:		lru-buffering pagevec of the caller
>  *
>  * Extend the initialized size of an attribute described by the ntfs inode @ni
>  * to @new_init_size bytes.  This involves zeroing any non-sparse space between
> @@ -395,7 +393,6 @@ static inline void ntfs_fault_in_pages_readable_iovec(const struct iovec *iov,
>  * @nr_pages:	number of page cache pages to obtain
>  * @pages:	array of pages in which to return the obtained page cache pages
>  * @cached_page: allocated but as yet unused page
> - * @lru_pvec:	lru-buffering pagevec of caller
>  *
>  * Obtain @nr_pages locked page cache pages from the mapping @mapping and
>  * starting at index @index.
> -- 
> 1.9.1
> 

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

