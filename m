Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbaCRVZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:25:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138AbaCRVZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:25:33 -0400
Date: Tue, 18 Mar 2014 14:25:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] MINIX: specific inode data access standardization
Message-Id: <20140318142531.ebb7f50ed458df868d64cf10@linux-foundation.org>
In-Reply-To: <20140318185221.697f8368fca2e51728e201ca@skynet.be>
References: <20140318185221.697f8368fca2e51728e201ca@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 18:52:21 +0100 Fabian Frederick <fabf@skynet.be> wrote:

> minix_i uppercase conversion (like majority of other filesystems).
>
> ...
>
> @@ -255,7 +255,7 @@ struct inode *minix_new_inode(const struct inode *dir, umode_t mode, int *error)
>  	inode->i_ino = j;
>  	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
>  	inode->i_blocks = 0;
> -	memset(&minix_i(inode)->u, 0, sizeof(minix_i(inode)->u));
> +	memset(&MINIX_I(inode)->u, 0, sizeof(MINIX_I(inode)->u));
>  	insert_inode_hash(inode);
>  	mark_inode_dirty(inode);

minix is correct and the other filesystems are wrong.

minix_i() is a regular C function.  There is no earthly reason why it
should be all-caps.

