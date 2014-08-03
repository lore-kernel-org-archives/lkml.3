Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbaHCD7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 23:59:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbaHCD7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 23:59:37 -0400
Date: Sun, 3 Aug 2014 05:59:31 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] scatterlist.h: Change CONFIG_DEBUG_SG for ifdef
 statement in sg_set_bf
Message-ID: <20140803035931.GA24059@mguzik.redhat.com>
References: <1407034573-14358-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1407034573-14358-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2014 at 10:56:13PM -0400, Nicholas Krause wrote:
> This changes the ifdef statement in sg_set_bg to !CONFIG_DEBUG_SG in order
> to avoid a bug with xhci dequence/enquence functions.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  include/linux/scatterlist.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index adae88f..62de7b3 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -111,7 +111,7 @@ static inline struct page *sg_page(struct scatterlist *sg)
>  static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
>  			      unsigned int buflen)
>  {
> -#ifdef CONFIG_DEBUG_SG
> +#ifdef !CONFIG_DEBUG_SG
>  	BUG_ON(!virt_addr_valid(buf));
>  #endif

Have you tried compiling this? IIRC you said you would compile your
stuff, what hapened to that?

What exactly were you trying to achieve? Did this BUG_ON detect a
problem on your system and now you are trying to silence it?

The change would be wrong even if it compiled since it would just
execute the assertion only when debug is disabled.

-- 
Mateusz Guzik
