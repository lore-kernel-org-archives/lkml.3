Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964869AbaEQPp1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 11:45:27 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:36745 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964828AbaEQPpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 11:45:25 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Manuel =?iso-8859-1?Q?Sch=F6lling?= <manuel.schoelling@gmx.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs: FAT: Cleanup string initializations (char[] instead of char *)
References: <1400339665-22321-1-git-send-email-manuel.schoelling@gmx.de>
Date: Sun, 18 May 2014 00:45:20 +0900
In-Reply-To: <1400339665-22321-1-git-send-email-manuel.schoelling@gmx.de>
	("Manuel =?iso-8859-1?Q?Sch=F6lling=22's?= message of "Sat, 17 May 2014
 17:14:25 +0200")
Message-ID: <878uq0l88f.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Schölling <manuel.schoelling@gmx.de> writes:

> Initializations like 'char *foo = "bar"' will create two variables: a static
> string and a pointer (foo) to that static string. Instead 'char foo[] = "bar"'
> will declare a single variable and will end up in shorter
> assembly (according to Jeff Garzik on the KernelJanitor's TODO list).
>
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>

Looks good.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

> ---
>  fs/fat/inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index b3361fe..8b7d00e 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -359,7 +359,7 @@ struct inode *fat_iget(struct super_block *sb, loff_t i_pos)
>  
>  static int is_exec(unsigned char *extension)
>  {
> -	unsigned char *exe_extensions = "EXECOMBAT", *walk;
> +	unsigned char exe_extensions[] = "EXECOMBAT", *walk;
>  
>  	for (walk = exe_extensions; *walk; walk += 3)
>  		if (!strncmp(extension, walk, 3))

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
