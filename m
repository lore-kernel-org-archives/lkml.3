Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbbAVSVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:21:51 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:56648 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbbAVSVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:21:48 -0500
MIME-Version: 1.0
In-Reply-To: <1421949760-5705-1-git-send-email-md.jamalmohiuddin@gmail.com>
References: <1421949760-5705-1-git-send-email-md.jamalmohiuddin@gmail.com>
Date: Thu, 22 Jan 2015 10:21:47 -0800
Message-ID: <CA+mtBx8yeLG7UwqtknAsUTBtpocspraBcfj5W-2vTBA5pC8LEQ@mail.gmail.com>
Subject: Re: [PATCH] include:linux:Optimizations to __skb_push
From: Tom Herbert <therbert@google.com>
To: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        viro@zeniv.linux.org.uk,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 10:02 AM, Mohammad Jamal
<md.jamalmohiuddin@gmail.com> wrote:
> This patch optimizes __skb_push function
>
> Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
> ---
>  include/linux/skbuff.h |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 85ab7d7..9acffb2 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1671,9 +1671,8 @@ static inline unsigned char *__skb_put(struct sk_buff *skb, unsigned int len)
>  unsigned char *skb_push(struct sk_buff *skb, unsigned int len);
>  static inline unsigned char *__skb_push(struct sk_buff *skb, unsigned int len)
>  {
> -       skb->data -= len;
>         skb->len  += len;
> -       return skb->data;
> +       return skb->data -= len;
>  }
>
Hmm, this seems less readable to me. What is the effect of this patch?
Does the compiler even produce different assembly?

Thanks,
Tom

>  unsigned char *skb_pull(struct sk_buff *skb, unsigned int len);
> --
> 1.7.9.5
>
