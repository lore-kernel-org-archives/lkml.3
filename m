Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbbALXKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:10:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbbALXKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:10:00 -0500
Date: Mon, 12 Jan 2015 15:09:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, willy@linux.intel.com
Subject: Re: [PATCH v12 09/20] dax,ext2: Replace xip_truncate_page with
 dax_truncate_page
Message-Id: <20150112150958.2e6bd85dc3e25b953d28c6cb@linux-foundation.org>
In-Reply-To: <1414185652-28663-10-git-send-email-matthew.r.wilcox@intel.com>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
	<1414185652-28663-10-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014 17:20:41 -0400 Matthew Wilcox <matthew.r.wilcox@intel.com> wrote:

> It takes a get_block parameter just like nobh_truncate_page() and
> block_truncate_page()
> 
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -458,3 +458,47 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	return result;
>  }
>  EXPORT_SYMBOL_GPL(dax_fault);
> +
> +/**
> + * dax_truncate_page - handle a partial page being truncated in a DAX file
> + * @inode: The file being truncated
> + * @from: The file offset that is being truncated to
> + * @get_block: The filesystem method used to translate file offsets to blocks
> + *
> + * Similar to block_truncate_page(), this function can be called by a
> + * filesystem when it is truncating an DAX file to handle the partial page.
> + *
> + * We work in terms of PAGE_CACHE_SIZE here for commonality with
> + * block_truncate_page(), but we could go down to PAGE_SIZE if the filesystem
> + * took care of disposing of the unnecessary blocks.

But PAGE_SIZE==PAGE_CACHE_SIZE.  Unclear what you're saying here.

> + Even if the filesystem
> + * block size is smaller than PAGE_SIZE, we have to zero the rest of the page
> + * since the file might be mmaped.
> + */
> 
> ...
>

