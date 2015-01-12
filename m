Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbbALXKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:10:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbbALXKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:10:13 -0500
Date: Mon, 12 Jan 2015 15:10:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, willy@linux.intel.com,
        Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v12 18/20] dax: Add dax_zero_page_range
Message-Id: <20150112151012.b576357217d5f91cd3ddf63b@linux-foundation.org>
In-Reply-To: <1414185652-28663-19-git-send-email-matthew.r.wilcox@intel.com>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
	<1414185652-28663-19-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014 17:20:50 -0400 Matthew Wilcox <matthew.r.wilcox@intel.com> wrote:

> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> [ported to 3.13-rc2]
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

I never know what this means :(

I switched it to 

[ross.zwisler@linux.intel.com: ported to 3.13-rc2]
Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

but perhaps that was wrong?



also, coupla typos:


diff -puN fs/dax.c~dax-add-dax_zero_page_range-fix fs/dax.c
--- a/fs/dax.c~dax-add-dax_zero_page_range-fix
+++ a/fs/dax.c
@@ -475,7 +475,7 @@ EXPORT_SYMBOL_GPL(dax_fault);
  * block_truncate_page(), but we could go down to PAGE_SIZE if the filesystem
  * took care of disposing of the unnecessary blocks.  Even if the filesystem
  * block size is smaller than PAGE_SIZE, we have to zero the rest of the page
- * since the file might be mmaped.
+ * since the file might be mmapped.
  */
 int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
 							get_block_t get_block)
@@ -514,13 +514,13 @@ EXPORT_SYMBOL_GPL(dax_zero_page_range);
  * @get_block: The filesystem method used to translate file offsets to blocks
  *
  * Similar to block_truncate_page(), this function can be called by a
- * filesystem when it is truncating an DAX file to handle the partial page.
+ * filesystem when it is truncating a DAX file to handle the partial page.
  *
  * We work in terms of PAGE_CACHE_SIZE here for commonality with
  * block_truncate_page(), but we could go down to PAGE_SIZE if the filesystem
  * took care of disposing of the unnecessary blocks.  Even if the filesystem
  * block size is smaller than PAGE_SIZE, we have to zero the rest of the page
- * since the file might be mmaped.
+ * since the file might be mmapped.
  */
 int dax_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
 {
diff -puN include/linux/fs.h~dax-add-dax_zero_page_range-fix include/linux/fs.h
_


akpm3:/usr/src/linux-3.19-rc4> grep -r mmaped .| wc -l
70
akpm3:/usr/src/linux-3.19-rc4> grep -r mmapped .| wc -l 
107

lol.
