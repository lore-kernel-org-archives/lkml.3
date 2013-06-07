Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3FGHWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:22:36 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59492 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753154Ab3FGHWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:22:34 -0400
Message-Id: <1370589753.21409.140661241005617.2A5614D3@webmail.messagingengine.com>
X-Sasl-Enc: uGyu354CzUAcuY3BaZT6C9msKy+qupdBVCX9O0mGjzsS 1370589753
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Alexandre Courbot <acourbot@nvidia.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>
Cc: gnurou@gmail.com, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-25df3f14
Subject: Re: [PATCH v2] simplefb: add support for a8b8g8r8 pixel format
Date: Fri, 07 Jun 2013 09:22:33 +0200
In-Reply-To: <1370584869-2904-1-git-send-email-acourbot@nvidia.com>
References: <1370584869-2904-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013, at 8:01, Alexandre Courbot wrote:
> A framebuffer of this format is set up by SHIELD's bootloader. This
> allows us to use it as a framebuffer console.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Acked-by: Olof Johansson <olof@lixom.net>
> ---
> Changes from v1:
> - Added description to motivate the change
> - Added ack
> 
>  Documentation/devicetree/bindings/video/simple-framebuffer.txt | 1 +
>  drivers/video/simplefb.c                                       | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/video/simple-framebuffer.txt b/Documentation/devicetree/bindings/video/simple-framebuffer.txt
> index 3ea4605..70c26f3 100644
> --- a/Documentation/devicetree/bindings/video/simple-framebuffer.txt
> +++ b/Documentation/devicetree/bindings/video/simple-framebuffer.txt
> @@ -12,6 +12,7 @@ Required properties:
>  - stride: The number of bytes in each line of the framebuffer.
>  - format: The format of the framebuffer surface. Valid values are:
>    - r5g6b5 (16-bit pixels, d[15:11]=r, d[10:5]=g, d[4:0]=b).
> +  - a8b8g8r8 (32-bit pixels, d[31:24]=a, d[23:16]=b, d[15:8]=g, d[7:0]=r).
>  
>  Example:
>  
> diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
> index e2e9e3e..d7041aa 100644
> --- a/drivers/video/simplefb.c
> +++ b/drivers/video/simplefb.c
> @@ -84,6 +84,7 @@ struct simplefb_format {
>  
>  static struct simplefb_format simplefb_formats[] = {
>  	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
> +	{ "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {31, 8} },

Hi,

31? I assume in practice this doesn't influence anything, but I think it should have read 24.

Greetings,
    Alexander

>  };
>  
>  struct simplefb_params {
> -- 
> 1.8.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
