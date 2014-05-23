Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaEWIaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:30:46 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41547 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaEWI1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:27:49 -0400
MIME-Version: 1.0
In-Reply-To: <1400840258-4919-1-git-send-email-dj@zeko.me>
References: <1400840258-4919-1-git-send-email-dj@zeko.me>
Date: Fri, 23 May 2014 10:27:48 +0200
Message-ID: <CAFLxGvzsYUd-zD2D9kewtguMYRQD3xS+iguSbWBuMXenopwxYw@mail.gmail.com>
Subject: Re: [PATCH] staging: usbip: use kcalloc instead of kzalloc for array allocations
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Djordje Zekovic <dj@zeko.me>
Cc: Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 12:17 PM, Djordje Zekovic <dj@zeko.me> wrote:
> The advantage of kcalloc is, that will prevent integer overflows which could
> result from the multiplication of number of elements and size and it is also
> a bit nicer to read.
>
> Signed-off-by: Djordje Zekovic <dj@zeko.me>
> ---
>  drivers/staging/usbip/stub_tx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/usbip/stub_tx.c b/drivers/staging/usbip/stub_tx.c
> index 1622563..4994090 100644
> --- a/drivers/staging/usbip/stub_tx.c
> +++ b/drivers/staging/usbip/stub_tx.c
> @@ -179,7 +179,7 @@ static int stub_send_ret_submit(struct stub_device *sdev)
>                 else
>                         iovnum = 2;
>
> -               iov = kzalloc(iovnum * sizeof(struct kvec), GFP_KERNEL);
> +               iov = kcalloc(iovnum * sizeof(struct kvec), GFP_KERNEL);

Does this even build?

static inline void *kcalloc(size_t n, size_t size, gfp_t flags)

-- 
Thanks,
//richard
