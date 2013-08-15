Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941Ab3HOUGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:06:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758889Ab3HOUGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:06:54 -0400
Message-ID: <520D34D7.9080208@redhat.com>
Date: Thu, 15 Aug 2013 16:06:47 -0400
From: Doug Ledford <dledford@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sasikantha Babu <sasikanth.v19@gmail.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ipc/mq: Removed unused def_attr local variable and
 its initialization in do_create
References: <1376320182-2118-1-git-send-email-sasikanth.v19@gmail.com> <1376320182-2118-2-git-send-email-sasikanth.v19@gmail.com>
In-Reply-To: <1376320182-2118-2-git-send-email-sasikanth.v19@gmail.com>
X-Enigmail-Version: 1.5.1
OpenPGP: id=0E572FDD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 11:09 AM, Sasikantha Babu wrote:
> In the first patch since we removed calling mq_attr_ok to validate
> mqueue attributes default/ceil values, So removing the unused def_attr
> 
> Signed-off-by: Sasikantha Babu <sasikanth.v19@gmail.com>
> ---
>  ipc/mqueue.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 04ece80..0bcf69c 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -741,13 +741,6 @@ static struct file *do_create(struct ipc_namespace *ipc_ns, struct inode *dir,
>  			return ERR_PTR(ret);
>  		/* store for use during create */
>  		path->dentry->d_fsdata = attr;
> -	} else {
> -		struct mq_attr def_attr;
> -
> -		def_attr.mq_maxmsg = min(ipc_ns->mq_msg_max,
> -					 ipc_ns->mq_msg_default);
> -		def_attr.mq_msgsize = min(ipc_ns->mq_msgsize_max,
> -					  ipc_ns->mq_msgsize_default);
>  	}
>  
>  	mode &= ~current_umask();
> 

Nak to this patch as well since it depends on the previous patch.
