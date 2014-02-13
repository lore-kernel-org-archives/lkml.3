Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaBMJko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:40:44 -0500
Received: from smtp.ispras.ru ([83.149.199.79]:47894 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbaBMJkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:40:40 -0500
Message-ID: <52FC9315.2090707@ispras.ru>
Date: Thu, 13 Feb 2014 13:40:37 +0400
From: Andrey Tsyvarev <tsyvarev@ispras.ru>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: jaegeuk.kim@samsung.com, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] f2fs: f2fs unmount hangs if f2fs_init_acl() fails
 during mkdir syscall
References: <52F320FC.50803@ispras.ru> <1391666564.25542.78.camel@kjgkr> <52F37D67.208@ispras.ru> <1391734185.25542.80.camel@kjgkr> <1391749933.25542.83.camel@kjgkr> <52F9DF85.7040402@ispras.ru> <52FC832F.6000103@cn.fujitsu.com>
In-Reply-To: <52FC832F.6000103@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> BTW, have you tested the case that added remove_dirty_dir_inode() into the fail path
> of init_inode_metadata?
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index e095a4f..d5a2c9e 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -375,6 +375,7 @@ put_error:
>          /* once the failed inode becomes a bad inode, i_mode is S_IFREG */
>          truncate_inode_pages(&inode->i_data, 0);
>          truncate_blocks(inode, 0);
> +       remove_dirty_dir_inode(inode);
>   error:
>          remove_inode_page(inode);
>          return ERR_PTR(err);
Yes, i have tested that case. Fail in init_inode_metadata has been 
processed correctly. Thanks.

-- 
Best regards,

Andrey Tsyvarev

Linux Verification Center, ISPRAS

web:http://linuxtesting.org

