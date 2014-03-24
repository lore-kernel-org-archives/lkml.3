Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaCXWrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 18:47:43 -0400
Received: from relay.parallels.com ([195.214.232.42]:37854 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaCXWrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 18:47:39 -0400
Message-ID: <5330B5F0.1090905@parallels.com>
Date: Tue, 25 Mar 2014 02:47:12 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrey Vagin <avagin@openvz.org>
CC: <linux-kernel@vger.kernel.org>, <criu@openvz.org>,
        <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Eric Dumazet <edumazet@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 1/3] tcp: allow to enable repair mode for sockets in any
 state
References: <1395408781-8145-1-git-send-email-avagin@openvz.org> <1395408781-8145-2-git-send-email-avagin@openvz.org>
In-Reply-To: <1395408781-8145-2-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [12.232.193.53]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -2375,7 +2378,7 @@ void tcp_sock_destruct(struct sock *sk)
>  static inline bool tcp_can_repair_sock(const struct sock *sk)
>  {
>  	return ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN) &&
> -		((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_ESTABLISHED));
> +		(sk->sk_state != TCP_LISTEN);

This set only covers states that may happen after ESTABLISHED, so
I would still exclude others (e.g. syn-sent) from the white list.

>  }
>  
>  static int tcp_repair_options_est(struct tcp_sock *tp,
> 

Thanks,
Pavel
