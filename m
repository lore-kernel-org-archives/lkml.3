Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbaHFAx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 20:53:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24191 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaHFAx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 20:53:58 -0400
Message-ID: <53E17C8A.9070204@oracle.com>
Date: Tue, 05 Aug 2014 20:53:30 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, ericvh@gmail.com,
        rminnich@sandia.gov, lucho@ionkov.net
CC: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/9p/: don't treat error as status value in file locking
References: <1403480661-32620-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1403480661-32620-1-git-send-email-sasha.levin@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On 06/22/2014 07:44 PM, Sasha Levin wrote:
> When trying to lock a file we didn't properly handle the case where a
> failure in p9_client_lock_dotl() occurs and treated the status value
> as valid instead of discarding it due to the error.
> 
> This would usually trigger a BUG() since the status value would
> just be stack garbage.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  fs/9p/vfs_file.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
> index 520c11c..06077f3 100644
> --- a/fs/9p/vfs_file.c
> +++ b/fs/9p/vfs_file.c
> @@ -194,7 +194,7 @@ static int v9fs_file_do_lock(struct file *filp, int cmd, struct file_lock *fl)
>  	for (;;) {
>  		res = p9_client_lock_dotl(fid, &flock, &status);
>  		if (res < 0)
> -			break;
> +			return res;
>  
>  		if (status != P9_LOCK_BLOCKED)
>  			break;
> 

