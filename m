Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbaEEWPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:15:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820AbaEEWPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:15:33 -0400
Date: Mon, 5 May 2014 15:15:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        Seunghun Lee <waydi1@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Improve missing blank line after
 declarations test
Message-Id: <20140505151531.af8e82be3a0c4800f0051de2@linux-foundation.org>
In-Reply-To: <1399320736.26330.8.camel@joe-AO725>
References: <1398790752-8067-1-git-send-email-waydi1@gmail.com>
	<20140429173221.GE26890@mwanda>
	<20140503234326.GA30117@kroah.com>
	<20140505095935.GO26890@mwanda>
	<1399319468.26330.2.camel@joe-AO725>
	<1399320736.26330.8.camel@joe-AO725>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2014 13:12:16 -0700 Joe Perches <joe@perches.com> wrote:

> A couple more modifications to the declarations tests.
> 
> o Declarations can also be bitfields so exclude things with a colon
> o Make sure the current and previous lines are indented the same
>   to avoid matching some macro where a struct type is passed on
>   the previous line like:
> 
> 		next = list_entry(buffer->entry.next,
> 				  struct binder_buffer, entry);
> 		if (buffer_start_page(next) == buffer_end_page(buffer)) 

So checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
is stuck in -mm while I evaluate its effects.  Thus far that evaluation
has been "super non-intrusive", because the patch doesn't actually
do anything.

--- a/fs/open.c~a
+++ a/fs/open.c
@@ -39,6 +39,7 @@ int do_truncate(struct dentry *dentry, l
 {
 	int ret;
 	struct iattr newattrs;
+	wibble();
 
 	/* Not pretty: "inode->i_size" shouldn't really be signed. But it is. */
 	if (length < 0)
@@ -67,6 +68,7 @@ long vfs_truncate(struct path *path, lof
 {
 	struct inode *inode;
 	long error;
+	wobble();
 
 	inode = path->dentry->d_inode;
 



I add --strict and it still doesn't warn.  What did I do wrong this time?

