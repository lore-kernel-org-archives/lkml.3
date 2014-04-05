Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaDEPHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 11:07:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26784 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbaDEPHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 11:07:04 -0400
Message-ID: <53401C11.7010601@oracle.com>
Date: Sat, 05 Apr 2014 11:06:57 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: raven@themaw.net
CC: autofs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] autofs4: check dev ioctl size before allocating
References: <1394934021-16965-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1394934021-16965-1-git-send-email-sasha.levin@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping? Anyone wants to take this?

On 03/15/2014 09:40 PM, Sasha Levin wrote:
> There wasn't any check of the size passed from userspace before
> trying to allocate the memory required.
> 
> This meant that userspace might request more space than allowed,
> triggering an OOM.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  fs/autofs4/dev-ioctl.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
> index 3182c0e..86fa7af 100644
> --- a/fs/autofs4/dev-ioctl.c
> +++ b/fs/autofs4/dev-ioctl.c
> @@ -103,6 +103,9 @@ static struct autofs_dev_ioctl *copy_dev_ioctl(struct autofs_dev_ioctl __user *i
>  	if (tmp.size < sizeof(tmp))
>  		return ERR_PTR(-EINVAL);
>  
> +	if (tmp.size > (PATH_MAX + sizeof(tmp)))
> +		return ERR_PTR(-E2BIG);
> +
>  	return memdup_user(in, tmp.size);
>  }
>  
> 

