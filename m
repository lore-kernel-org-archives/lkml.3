Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab3KHFHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 00:07:00 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:39793 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3KHFG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 00:06:58 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [patch] fat: double unlock on error path
References: <20131107074108.GB21844@elgon.mountain>
Date: Fri, 08 Nov 2013 14:06:52 +0900
In-Reply-To: <20131107074108.GB21844@elgon.mountain> (Dan Carpenter's message
	of "Thu, 7 Nov 2013 10:41:08 +0300")
Message-ID: <87zjpfv5w3.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> There is a stray unlock here which was not intended.  I have removed it.
>
> Fixes: 3f9f3dfb5755 ('fat: add fat_fallocate operation')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/fs/fat/file.c b/fs/fat/file.c
> index 03f716f..befedee 100644
> --- a/fs/fat/file.c
> +++ b/fs/fat/file.c
> @@ -257,10 +257,8 @@ static long fat_fallocate(struct file *file, int mode,
>  		goto error;
>  
>  	err = inode_newsize_ok(inode, (len + offset));
> -	if (err) {
> -		mutex_unlock(&inode->i_mutex);
> +	if (err)
>  		goto error;
> -	}
>  
>  	if (mode & FALLOC_FL_KEEP_SIZE) {
>  		/* First compute the number of clusters to be allocated */

Right. Namjae, please include this fix to patchset at next time.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
