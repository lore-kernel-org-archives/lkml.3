Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaLYWhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 17:37:52 -0500
Received: from mout.gmx.net ([212.227.17.22]:61474 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbaLYWhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 17:37:50 -0500
Message-ID: <549C91B9.8080009@gmx.de>
Date: Thu, 25 Dec 2014 23:37:45 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
CC: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH repost 12/16] parisc/uaccess: fix sparse errors
References: <1419499661-8566-1-git-send-email-mst@redhat.com> <1419499661-8566-13-git-send-email-mst@redhat.com>
In-Reply-To: <1419499661-8566-13-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:BLag1ejocmloeYUrYmzQnA7gZ8lTd4nkrW78lq0Xr/QY5rCNRlL
 byEM6fl/GtGCqpttypIqb23y2RKlpZgHZH8NKSZJktENO/k3/Z15Ep1LGxiNOSGIHWTQh8c
 Gm2+lGkFCwASu9r1ybTvXlBQ2X4dDQIUNJXfsuWsQmpq6qSYpR06BbuPCG+5Sd7SNz4uZES
 eLc6UtN7ulw/Q6PmObnXQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 12/25/2014 10:29 AM, Michael S. Tsirkin wrote:
> virtio wants to read bitwise types from userspace using get_user.  At the

I don't know the virtio code much yet, but does it makes sense to read bitwise types?
Will virtio then get possible troubles because of endianess correct as well?

Do you have a code example, or the sparse error message ?

Helge

> moment this triggers sparse errors, since the value is passed through an
> integer.
>
> Fix that up using __force.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   arch/parisc/include/asm/uaccess.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/parisc/include/asm/uaccess.h b/arch/parisc/include/asm/uaccess.h
> index a5cb070..3a20da6 100644
> --- a/arch/parisc/include/asm/uaccess.h
> +++ b/arch/parisc/include/asm/uaccess.h
> @@ -104,7 +104,7 @@ struct exception_data {
>   	    }                                           \
>   	}                                               \
>   							\
> -	(x) = (__typeof__(*(ptr))) __gu_val;            \
> +	(x) = (__force __typeof__(*(ptr))) __gu_val;            \
>   	__gu_err;                                       \
>   })
>
>

