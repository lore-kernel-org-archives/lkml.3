Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab3AWP0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:26:46 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:2883 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab3AWP0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:26:44 -0500
Message-ID: <51000131.3070300@parallels.com>
Date: Wed, 23 Jan 2013 19:26:41 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrey Vagin <avagin@openvz.org>
CC: netdev@vger.kernel.org, criu@openvz.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>, Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 2/2] tcp: add ability to set a timestamp offset (v2)
References: <1358953314-12979-1-git-send-email-avagin@openvz.org> <1358953314-12979-3-git-send-email-avagin@openvz.org>
In-Reply-To: <1358953314-12979-3-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 086ceda..23f93d4 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2704,6 +2704,10 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
>  		else
>  			err = -EINVAL;
>  		break;
> +	case TCP_TIMESTAMP:
> +		tp->tsoffset = 0;
> +		tp->tsoffset = val - tcp_time_stamp(tp);

I believe we should check that the socket state is TCP_CLOSE.
Otherwise tcp_time_stamp() readers might be surprised while
reading the value.

> +		break;
>  	default:
>  		err = -ENOPROTOOPT;
>  		break;
