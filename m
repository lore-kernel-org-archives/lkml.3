Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaKIKtu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 05:49:50 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:53475 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaKIKts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 05:49:48 -0500
Message-ID: <545F46C8.2090502@gmail.com>
Date: Sun, 09 Nov 2014 18:49:44 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>
Subject: Re: [PATCH] drivers: input: mouse: Use "static inline" instead of
 "inline" in "lifebook.h"
References: <545F4602.10101@gmail.com>
In-Reply-To: <545F4602.10101@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After this patch, our tile can pass allmodconfig building. :-)

Thanks.

On 11/09/2014 06:46 PM, Chen Gang wrote:
> For inline function in header file, better to be "static inline", or may
> cause building break under the latest upstream gcc (although, probably,
> it should be the gcc's issue).
> 
> The related error (with allmodconfig under tile):
> 
>     MODPOST 4002 modules
>   ERROR: "lifebook_detect" [drivers/input/mouse/psmouse.ko] undefined!
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/input/mouse/lifebook.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/mouse/lifebook.h b/drivers/input/mouse/lifebook.h
> index 4c4326c..0baf02a 100644
> --- a/drivers/input/mouse/lifebook.h
> +++ b/drivers/input/mouse/lifebook.h
> @@ -16,14 +16,14 @@ void lifebook_module_init(void);
>  int lifebook_detect(struct psmouse *psmouse, bool set_properties);
>  int lifebook_init(struct psmouse *psmouse);
>  #else
> -inline void lifebook_module_init(void)
> +static inline void lifebook_module_init(void)
>  {
>  }
> -inline int lifebook_detect(struct psmouse *psmouse, bool set_properties)
> +static inline int lifebook_detect(struct psmouse *psmouse, bool set_properties)
>  {
>  	return -ENOSYS;
>  }
> -inline int lifebook_init(struct psmouse *psmouse)
> +static inline int lifebook_init(struct psmouse *psmouse)
>  {
>  	return -ENOSYS;
>  }
> 


-- 
Chen Gang

Open share and attitude like air water and life which God blessed
