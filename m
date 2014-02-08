Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaBHUKF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 15:10:05 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57028 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaBHUKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 15:10:02 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 8 Feb 2014 12:09:52 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Daniel Borkmann <dborkman@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 05/13] net: Mark function as static in core/filter.c
Message-ID: <20140208200951.GE20885@leaf>
References: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
 <b4fedb3d1984f8e1878015e12b7214c00a6588bb.1391888654.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b4fedb3d1984f8e1878015e12b7214c00a6588bb.1391888654.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 01:25:05AM +0530, Rashika Kheria wrote:
> Mark function as static in core/filter.c because it is not used outside
> this file.
> 
> This eliminates the following warning in core/filter.c:
> net/core/filter.c:48:7: warning: no previous prototype for ‘bpf_internal_load_pointer_neg_helper’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

This function actually is used outside this file, just not from C code;
a couple of assembly files call it.  (See also the comment above this
definition: "Exported for the bpf jit load helper.")

I'd suggest prototyping this function in include/linux/filter.h , unless
someone on CC has another preference.

>  net/core/filter.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index ad30d62..a022dad 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -44,7 +44,8 @@
>   *
>   * Exported for the bpf jit load helper.
>   */
> -void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, unsigned int size)
> +static void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb,
> +						  int k, unsigned int size)
>  {
>  	u8 *ptr = NULL;
>  
> -- 
> 1.7.9.5
> 
