Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbaHFGr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 02:47:58 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57396 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbaHFGr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 02:47:57 -0400
Message-ID: <53E1CF98.6010308@gmail.com>
Date: Wed, 06 Aug 2014 09:47:52 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Hans Wennborg <hans@hanshq.net>, bharrosh@panasas.com,
        osd-dev@open-osd.org, linux-kernel@vger.kernel.org
Subject: Re: [osd-dev] [PATCH 13/15] exofs: fix decimal printf format specifiers
 prefixed with 0x
References: <1407300246-454-1-git-send-email-hans@hanshq.net>
In-Reply-To: <1407300246-454-1-git-send-email-hans@hanshq.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 07:44 AM, Hans Wennborg wrote:
> The prefix suggests the number should be printed in hex, so use
> the %x specifier to do that.
> 
> Found by using regex suggested by Joe Perches.
> 
> Signed-off-by: Hans Wennborg <hans@hanshq.net>

Thanks will push
Boaz

> ---
>  fs/exofs/dir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/exofs/dir.c b/fs/exofs/dir.c
> index 49f51ab..54ab575 100644
> --- a/fs/exofs/dir.c
> +++ b/fs/exofs/dir.c
> @@ -143,7 +143,7 @@ Espan:
>  bad_entry:
>  	EXOFS_ERR(
>  		"ERROR [exofs_check_page]: bad entry in directory(0x%lx): %s - "
> -		"offset=%lu, inode=0x%llu, rec_len=%d, name_len=%d\n",
> +		"offset=%lu, inode=0x%llx, rec_len=%d, name_len=%d\n",
>  		dir->i_ino, error, (page->index<<PAGE_CACHE_SHIFT)+offs,
>  		_LLU(le64_to_cpu(p->inode_no)),
>  		rec_len, p->name_len);
> 

