Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaBRWTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:19:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaBRWTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:19:35 -0500
Date: Tue, 18 Feb 2014 14:19:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Barry Song <21cnbao@gmail.com>
Cc: ohad@wizery.com, linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Wei Chen <Wei.Chen@csr.com>, Barry Song <Baohua.Song@csr.com>
Subject: Re: [PATCH] drivers/rpmsg/virtio_rpmsg_bus.c: fix the return value
 of rpmsg_init
Message-Id: <20140218141934.902737c24a0b46ef42e6ea9a@linux-foundation.org>
In-Reply-To: <1392624815-20759-1-git-send-email-21cnbao@gmail.com>
References: <1392624815-20759-1-git-send-email-21cnbao@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014 16:13:34 +0800 Barry Song <21cnbao@gmail.com> wrote:

> From: Wei Chen <Wei.Chen@csr.com>
> 
> rpmsg_init() always return ERROR code or random integer now, this patch fixes
> it.
> 
> ...
>
> --- a/drivers/rpmsg/virtio_rpmsg_bus.c
> +++ b/drivers/rpmsg/virtio_rpmsg_bus.c
> @@ -1096,9 +1096,10 @@ static int __init rpmsg_init(void)
>  	if (ret) {
>  		pr_err("failed to register virtio driver: %d\n", ret);
>  		bus_unregister(&rpmsg_bus);
> +		return ret;
>  	}
>  
> -	return ret;
> +	return 0;
>  }

Look more closely.  This patch has no effect...
