Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468AbaCRXTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:19:04 -0400
Received: from mxout1.netvision.net.il ([194.90.9.20]:62648 "EHLO
	mxout1.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbaCRXTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:19:02 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <5328D44D.9060509@gmail.com>
Date: Wed, 19 Mar 2014 01:18:37 +0200
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Richard Weinberger <richard@nod.at>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/xillybus: Handle OOM in xillybus_init()
References: <1395184025-17278-1-git-send-email-richard@nod.at>
In-reply-to: <1395184025-17278-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I stand (shamefully) corrected. Thanks.

   Eli

On 19/03/14 01:07, Richard Weinberger wrote:
> alloc_workqueue() can fail and returns NULL in case of
> OOM.
> Handle this case and undo class_create().
>
> Signed-off-by: Richard Weinberger<richard@nod.at>
> ---
>   drivers/staging/xillybus/xillybus_core.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/xillybus/xillybus_core.c b/drivers/staging/xillybus/xillybus_core.c
> index 2ebaf16..b0a6696 100644
> --- a/drivers/staging/xillybus/xillybus_core.c
> +++ b/drivers/staging/xillybus/xillybus_core.c
> @@ -2318,8 +2318,12 @@ static int __init xillybus_init(void)
>   	}
>
>   	xillybus_wq = alloc_workqueue(xillyname, 0, 0);
> +	if (!xillybus_wq) {
> +		class_destroy(xillybus_class);
> +		rc = -ENOMEM;
> +	}
>
> -	return 0; /* Success */
> +	return rc;
>   }
>
>   static void __exit xillybus_exit(void)
>    


