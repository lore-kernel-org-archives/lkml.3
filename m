Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935403Ab3E2W2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:28:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935383Ab3E2W22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:28:28 -0400
Date: Wed, 29 May 2013 15:28:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] minix: bug widening a binary "not" operation
Message-Id: <20130529152826.043e95791122bbd39fc9d005@linux-foundation.org>
In-Reply-To: <20130516075148.GA7494@elgon.mountain>
References: <20130516075148.GA7494@elgon.mountain>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 May 2013 10:51:49 +0300 Dan Carpenter <dan.carpenter@oracle.com> wrote:

> "chunk_size" is an unsigned int and "pos" is an unsigned long.  The
> "& ~(chunk_size-1)" operation clears the high 32 bits unintentionally.
> 
> The ALIGN() macro does the correct thing.
> 
> ...
>
> @@ -95,7 +95,7 @@ static int minix_readdir(struct file * filp, void * dirent, filldir_t filldir)
>  	char *name;
>  	__u32 inumber;
>  
> -	pos = (pos + chunk_size-1) & ~(chunk_size-1);
> +	pos = ALIGN(pos, chunk_size);
>  	if (pos >= inode->i_size)
>  		goto done;
>  

I'm suspecting there aren't many minix filesystems out there with a >4G
directory ;)

But we should fix it to set a good example, and to quieten
whatever-tool-i-suspect-you-were-using(?).
