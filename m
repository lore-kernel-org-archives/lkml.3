Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaLRDLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 22:11:35 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:34694 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaLRDLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 22:11:33 -0500
MIME-Version: 1.0
In-Reply-To: <1418575877-21488-6-git-send-email-mst@redhat.com>
References: <1418575877-21488-1-git-send-email-mst@redhat.com>
	<1418575877-21488-6-git-send-email-mst@redhat.com>
Date: Thu, 18 Dec 2014 11:11:32 +0800
Message-ID: <CAMk6uBm_z98dHB3WvJ==ozb4p2uRx3fQa7CWHqDdYpducwxrqg@mail.gmail.com>
Subject: Re: [PATCH 05/18] blackfin/uaccess: fix sparse errors
From: Steven Miao <realmz6@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open
	list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        bfin <adi-buildroot-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 12:52 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> virtio wants to read bitwise types from userspace using get_user.  At the
> moment this triggers sparse errors, since the value is passed through an
> integer.
>
> Fix that up using __force.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/blackfin/include/asm/uaccess.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/blackfin/include/asm/uaccess.h b/arch/blackfin/include/asm/uaccess.h
> index 57701c3..6a46e7d 100644
> --- a/arch/blackfin/include/asm/uaccess.h
> +++ b/arch/blackfin/include/asm/uaccess.h
> @@ -147,7 +147,7 @@ static inline int bad_user_access_length(void)
>                 }                                               \
>         } else                                                  \
>                 _err = -EFAULT;                                 \
> -       x = (typeof(*(ptr)))_val;                               \
> +       x = (__force typeof(*(ptr)))_val;                               \
>         _err;                                                   \
>  })
>
> --
> MST
>
Acked-by: Steven Miao <realmz6@gmail.com>
