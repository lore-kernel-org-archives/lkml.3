Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaHCM2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 08:28:37 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:33799 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaHCM2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 08:28:36 -0400
Message-ID: <53DE2AEF.6080904@cogentembedded.com>
Date: Sun, 03 Aug 2014 16:28:31 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, linux-kernel@vger.kernel.org
CC: linux-usb@vger.kernel.org
Subject: Re: [PATCH] scatterlist.h: Change CONFIG_DEBUG_SG for ifdef statement
 in sg_set_bf
References: <1407034573-14358-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1407034573-14358-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03-08-2014 6:56, Nicholas Krause wrote:

> This changes the ifdef statement  in sg_set_bg to !CONFIG_DEBUG_SG in order
> to avoid a bug with xhci dequence/enquence functions.

    dequeue/enqueue?

> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>   include/linux/scatterlist.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index adae88f..62de7b3 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -111,7 +111,7 @@ static inline struct page *sg_page(struct scatterlist *sg)
>   static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
>   			      unsigned int buflen)
>   {
> -#ifdef CONFIG_DEBUG_SG
> +#ifdef !CONFIG_DEBUG_SG

    Didn't you mean #ifndef instead? I guess you didn't even try to build-test 
this.

>   	BUG_ON(!virt_addr_valid(buf));
>   #endif
>   	sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));

WBR, Sergei

