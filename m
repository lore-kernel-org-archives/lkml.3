Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3CDCIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:08:48 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:58379 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab3CDCIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:08:47 -0500
Message-ID: <1362362923.15793.84.camel@edumazet-glaptop>
Subject: Re: [PATCH] filter: fix sparse warning for
 bpf_internal_load_pointer_neg_helper
From: Eric Dumazet <erdnetdev@gmail.com>
To: Claudiu Ghioc <claudiughioc@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, dborkman@redhat.com,
        jpirko@redhat.com, akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Claudiu Ghioc <claudiu.ghioc@gmail.com>
Date: Sun, 03 Mar 2013 18:08:43 -0800
In-Reply-To: <1362353404-27034-1-git-send-email-claudiu.ghioc@gmail.com>
References: <1362353404-27034-1-git-send-email-claudiu.ghioc@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-04 at 01:30 +0200, Claudiu Ghioc wrote:
> Removed the following sparse warning:
> *   net/core/filter.c:48:6: warning: symbol
>     'bpf_internal_load_pointer_neg_helper' was
>     not declared. Should it be static?
> 
> Signed-off-by: Claudiu Ghioc <claudiu.ghioc@gmail.com>
> ---
>  net/core/filter.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2e20b55..f6c907c 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -45,7 +45,7 @@
>   *
>   * Exported for the bpf jit load helper.
>   */
> -void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, unsigned int size)
> +static void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, unsigned int size)
>  {
>  	u8 *ptr = NULL;
>  

Hmm, have you read the comment ?

Also :


