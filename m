Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab3JCEXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:23:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52790 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab3JCEXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:23:52 -0400
Message-ID: <1380774230.19002.135.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH net-next] fix unsafe set_memory_rw from softirq
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Xi Wang <xi.wang@gmail.com>, x86@kernel.org,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Date: Wed, 02 Oct 2013 21:23:50 -0700
In-Reply-To: <1380772231-3566-1-git-send-email-ast@plumgrid.com>
References: <1380772231-3566-1-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 20:50 -0700, Alexei Starovoitov wrote:
> on x86 system with net.core.bpf_jit_enable = 1

> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index a6ac848..378fa03 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -27,6 +27,7 @@ struct sk_filter
>  	unsigned int         	len;	/* Number of filter blocks */
>  	unsigned int		(*bpf_func)(const struct sk_buff *skb,
>  					    const struct sock_filter *filter);
> +	struct work_struct	work;
>  	struct rcu_head		rcu;
>  	struct sock_filter     	insns[0];
>  };

Nice catch !

It seems only x86 and s390 needs this work_struct.

(and you might CC Heiko Carstens <heiko.carstens@de.ibm.com> to ask him
to make the s390 part, of Ack it if you plan to do it)

Thanks


