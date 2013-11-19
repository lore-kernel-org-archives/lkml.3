Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3KSSU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:20:58 -0500
Received: from relay.parallels.com ([195.214.232.42]:50880 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3KSSU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:20:57 -0500
Message-ID: <528BABF7.1010009@parallels.com>
Date: Tue, 19 Nov 2013 22:20:39 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrey Vagin <avagin@openvz.org>, "David S. Miller" <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <criu@openvz.org>, Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] tcp: don't update snd_nxt, when a socket is switched
 from repair mode
References: <1384884606-9978-1-git-send-email-avagin@openvz.org>
In-Reply-To: <1384884606-9978-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.169.95.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 10:10 PM, Andrey Vagin wrote:
> 
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: James Morris <jmorris@namei.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

Acked-by: Pavel Emelyanov <xemul@parallels.com>

> ---
>  net/ipv4/tcp_output.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 6728546..fa9f57d 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3093,7 +3093,6 @@ void tcp_send_window_probe(struct sock *sk)
>  {
>  	if (sk->sk_state == TCP_ESTABLISHED) {
>  		tcp_sk(sk)->snd_wl1 = tcp_sk(sk)->rcv_nxt - 1;
> -		tcp_sk(sk)->snd_nxt = tcp_sk(sk)->write_seq;
>  		tcp_xmit_probe_skb(sk, 0);
>  	}
>  }
> 


