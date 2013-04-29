Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492Ab3D2Ql5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:41:57 -0400
Received: from natasha.panasas.com ([67.152.220.90]:45806 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470Ab3D2Qlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:41:55 -0400
Message-ID: <517EA27A.8080109@panasas.com>
Date: Mon, 29 Apr 2013 09:40:26 -0700
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Zhao Hongjiang <zhaohongjiang@huawei.com>
CC: <bhalevy@tonian.com>, Andrew Morton <akpm@linux-foundation.org>,
        <osd-dev@open-osd.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] =?UTF-8?B?ZXhvZnPvvJogZG9uJ3QgaW5jcmVhc2UgdXJpbGVuIGk=?=
 =?UTF-8?B?ZiBrcmVhbGxvYygpIGZhaWxz?=
References: <517D0C1E.4090004@huawei.com>
In-Reply-To: <517D0C1E.4090004@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.67.144]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2013 04:46 AM, Zhao Hongjiang wrote:
> Without the patch, edp->urilen is increased before krealloc(). If krealloc() fails,
> edp->urilen is too high. Fix that by only updating edp->urilen if krealloc() is successful.
> 
> Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
> ---
>  fs/exofs/sys.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/exofs/sys.c b/fs/exofs/sys.c
> index 1b4f2f9..79b0a85 100644
> --- a/fs/exofs/sys.c
> +++ b/fs/exofs/sys.c
> @@ -82,11 +82,11 @@ static ssize_t uri_store(struct exofs_dev *edp, const char *buf, size_t len)
>  {
>  	uint8_t *new_uri;
>  
> -	edp->urilen = strlen(buf) + 1;
> -	new_uri = krealloc(edp->uri, edp->urilen, GFP_KERNEL);
> +	new_uri = krealloc(edp->uri, strlen(buf) + 1, GFP_KERNEL);
>  	if (new_uri == NULL)
>  		return -ENOMEM;
>  	edp->uri = new_uri;
> +	edp->urilen = strlen(buf) + 1;
>  	strncpy(edp->uri, buf, edp->urilen);
>  	return edp->urilen;
>  }
> -- 1.7.1
> 

Thank you, will apply

Boaz
