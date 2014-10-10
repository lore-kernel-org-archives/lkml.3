Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaJJNVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 09:21:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbaJJNVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 09:21:34 -0400
Message-ID: <5437DD59.5000906@redhat.com>
Date: Fri, 10 Oct 2014 14:21:29 +0100
From: Steven Whitehouse <swhiteho@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: cluster-devel@redhat.com
Subject: Re: [PATCH 1/1 linux-next] GFS2: directly return gfs2_dir_check()
References: <1412887761-15293-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1412887761-15293-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/10/14 21:49, Fabian Frederick wrote:
> No need to store gfs2_dir_check result and test it before returning.
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
Since I've already sent a pull request for this merge window, and this 
is not urgent, I'll keep this one and use it to start off the new tree 
in due course, once the merge window has closed. Thanks,

Steve,

> ---
>   fs/gfs2/inode.c | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> index c4ed823..b41b5c7 100644
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -1045,11 +1045,7 @@ static int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
>   	if (error)
>   		return error;
>   
> -	error = gfs2_dir_check(&dip->i_inode, name, ip);
> -	if (error)
> -		return error;
> -
> -	return 0;
> +	return gfs2_dir_check(&dip->i_inode, name, ip);
>   }
>   
>   /**

