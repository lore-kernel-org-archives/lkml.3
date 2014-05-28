Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaE1DXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 23:23:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbaE1DXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 23:23:08 -0400
Message-ID: <53855695.8000106@redhat.com>
Date: Wed, 28 May 2014 11:23:01 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org
Subject: Re: [PATCH] hv: use correct order when freeing monitor_pages
References: <1401210980-2515-1-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1401210980-2515-1-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 01:16 AM, Radim Krčmář wrote:
> We try to free two pages when only one has been allocated.
> Cleanup path is unlikely, so I haven't found any trace that would fit,
> but I hope that free_pages_prepare() does catch it.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>  Cc'd stable because the worst-case looks hard to debug.
>  Btw. the module can't get unloaded after we successfully connect?
>
>  drivers/hv/connection.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
> index 7f10c15..e84f452 100644
> --- a/drivers/hv/connection.c
> +++ b/drivers/hv/connection.c
> @@ -224,8 +224,8 @@ cleanup:
>  		vmbus_connection.int_page = NULL;
>  	}
>  
> -	free_pages((unsigned long)vmbus_connection.monitor_pages[0], 1);
> -	free_pages((unsigned long)vmbus_connection.monitor_pages[1], 1);
> +	free_pages((unsigned long)vmbus_connection.monitor_pages[0], 0);
> +	free_pages((unsigned long)vmbus_connection.monitor_pages[1], 0);
>  	vmbus_connection.monitor_pages[0] = NULL;
>  	vmbus_connection.monitor_pages[1] = NULL;
>  

Acked-by: Jason Wang <jasowang@redhat.com>
