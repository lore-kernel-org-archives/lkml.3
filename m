Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3EZQ20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 12:28:26 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:34615 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3EZQ2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 12:28:25 -0400
Message-ID: <51A23825.7000303@cogentembedded.com>
Date: Sun, 26 May 2013 20:28:21 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: atomlin@redhat.com
CC: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pshelar@nicira.com, mst@redhat.com, alexander.h.duyck@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v1] skbuff: Hide GFP_ATOMIC page allocation failures for
 dropped packets
References: <1369574241-21397-1-git-send-email-atomlin@redhat.com>
In-Reply-To: <1369574241-21397-1-git-send-email-atomlin@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 26-05-2013 17:17, atomlin@redhat.com wrote:

> From: Aaron Tomlin <atomlin@redhat.com>

> Failed GFP_ATOMIC allocations by the network stack result in dropped
> packets, which will be received on a subsequent retransmit, and an
> unnecessary, noisy warning with a kernel backtrace.

> These warnings are harmless, but they still cause users to panic and
> file bug reports over dropped packets. It would be better to hide the
> failed allocation warnings and backtraces, and let retransmits handle
> dropped packets quietly.

> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> ---
>   net/core/skbuff.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index af9185d..02139d6 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -236,7 +236,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>   		? skbuff_fclone_cache : skbuff_head_cache;
>
>   	if (sk_memalloc_socks() && (flags & SKB_ALLOC_RX))
> -		gfp_mask |= __GFP_MEMALLOC;
> +		gfp_mask |= (__GFP_MEMALLOC|__GFP_NOWARN);

    Parens not needed here.

WBR, Sergei

