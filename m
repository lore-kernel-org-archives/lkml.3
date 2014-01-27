Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaA0WwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:52:13 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:35156 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbaA0WwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:52:12 -0500
Message-ID: <52E6F12D.90701@cogentembedded.com>
Date: Tue, 28 Jan 2014 02:52:13 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: xypron.glpk@gmx.de, devel@driverdev.osuosl.org
CC: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de, ke42caxa@cip.cs.fau.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usbip/userspace/libsrc/names.c: memory leak
References: <1390861789-8981-1-git-send-email-xypron.glpk@gmx.de>
In-Reply-To: <1390861789-8981-1-git-send-email-xypron.glpk@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/28/2014 01:29 AM, xypron.glpk@gmx.de wrote:

> From: Heinrich Schuchardt <xypron.glpk@gmx.de>

> p is freed if NULL.

    This is not an issue.

> p is leaked if second calloc fails.
>
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> ---
>   drivers/staging/usbip/userspace/libsrc/names.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/usbip/userspace/libsrc/names.c b/drivers/staging/usbip/userspace/libsrc/names.c
> index 3c8d28b..b2904e8 100644
> --- a/drivers/staging/usbip/userspace/libsrc/names.c
> +++ b/drivers/staging/usbip/userspace/libsrc/names.c
> @@ -170,12 +170,12 @@ static void *my_malloc(size_t size)
>
>   	p = calloc(1, sizeof(struct pool));
>   	if (!p) {
> -		free(p);
>   		return NULL;
>   	}

    {} not needed anymore.

>
>   	p->mem = calloc(1, size);
>   	if (!p->mem)
> +		free(p);
>   		return NULL;

    How about {} around the *if* arm?

WBR, Sergei

