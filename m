Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab3K2CIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 21:08:34 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:54937 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab3K2CIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 21:08:30 -0500
X-AuditID: cbfee691-b7f666d0000048b0-31-5297f71de67f
Date: Fri, 29 Nov 2013 02:08:29 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: Re: [PATCH v2] inet: fix possible seqlock deadlocks
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20131129020248524@jongman.heo
Msgkey: 20131129020248524@jongman.heo
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131129020248524@jongman.heo
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <20844393.153981385690907396.JavaMail.weblogic@epml08>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42JZI2JSoCv7fXqQwYtlXBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj4opb7AUbpCo+7frB3MB4RbKLkZNDSEBN4ubnQ4wgtoSAiUTv
	woXMELaYxIV769m6GLmAapYySrSd2c4CU3T95WSoxHxGiSO3PrOCJFgEVCVmN94Dm8QmoCPR
	8X8/WFxYwEbi6qpNYLaIgLbE8rU7mECamQWuMkqc/vKQEeIMRYlrSxezgdi8AoISJ2c+gdqm
	InFu7hWouKrE/J6bTBBxcYkLcy+xQ9i8EjPan0LVy0lM+7oG6gVpifOzNjDCvLP4+2OoOL/E
	sdsgR3CA9T65HwwzZvfmL2wQtoDE1DMHoVo1JW7vfw21lk9izcK3LDBjdp1azgzTe3/LXLAa
	ZqBXpnQ/ZAcZzwzUu36XPrqveAWcJP4/Pcg0gVF5FpLULCTdsxC6kZUsYGRZxSiaWpBcUJyU
	XmSqV5yYW1yal66XnJ+7iRGYFk7/ezZxB+P9A9aHGJOBMTKRWUo0OR+YVvJK4g2NzYwsTE1M
	jY3MLc1IE1YS501/lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbHfbMcVUfbfrhdX1n6Z
	23azcYHn0WXTTvdum/89zfTacvnGEs8aqZXljVOsl78NU5MKm/X1fK/FyWMnP6/coJq0/46T
	9PPs7Jtvm10f3vwQc3N62gQeicfHligErupU9HQzMp4rWWj/06vMwOL7dI4NNtE7M6p+K6Yy
	yfpEF63TZvZn4AvS3KLEUpyRaKjFXFScCADTlsLYIQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t/tGbqy36cHGZzbwWxxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jIu
	rrjFXrBBquLTrh/MDYxXJLsYOTmEBNQkbn4+xAhiSwiYSFx/OZkNwhaTuHBvPZDNBVQzn1Hi
	yK3PrCAJFgFVidmN98Aa2AR0JDr+7weLCwvYSFxdtQnMFhHQlli+dgcTSDOzwFVGidNfHjJC
	bFOUuLZ0MdgGXgFBiZMzn7BAbFORODf3ClRcVWJ+z00miLi4xIW5l9ghbF6JGe1PoerlJKZ9
	XcMMYUtLnJ+1gRHm6sXfH0PF+SWO3QY5ggOs98n9YJgxuzd/gXpSQGLqmYNQrZoSt/e/hlrL
	J7Fm4VsWmDG7Ti1nhum9v2UuWA0z0CtTuh+yg4xnBupdv0sf3Ve8Ak4S/58eZJrAKDcLSWoW
	ku5ZCN3IShYwsqxiFE0tSC4oTkqvMNQrTswtLs1L10vOz93ECE5OzxbuYPxy3voQowAHoxIP
	b0Dn9CAh1sSy4srcQ4wSHMxKIry/ioBCvCmJlVWpRfnxRaU5qcWHGJOB8TeRWUo0OR+YOPNK
	4g2NjU3MTEwtTSwMTM1JE1YS5717MylISCA9sSQ1OzW1ILUIZgsTB6dUA2O66ZPAsOW/H/xR
	PLzw+M3vptV9f4+y8fpPUIm+uqmVIaNhf2D4fufjYt3zHp06E7157/Eu9TDGH33K0q/y75vy
	ON54u6fwrtn5Ku/6oBv7nBfI6KxT6F1beUR+DVdMivntndeLkkpe77ZPyr946+xqtcMh/wu2
	PHFgrVokb7FVVnb9UpuO4DlKLMUZiYZazEXFiQC9qMGYkgMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAT28i5r030747

 
------ Original Message -------
Sender : Eric Dumazet<eric.dumazet@gmail.com>
Date : 2013-11-29 02:51 (GMT+09:00)
Title : [PATCH v2] inet: fix possible seqlock deadlocks
> 
> From: Eric Dumazet 
> 
> In commit c9e9042994d3 ("ipv4: fix possible seqlock deadlock") I left
> another places where IP_INC_STATS_BH() were improperly used.
> 
> udp_sendmsg(), ping_v4_sendmsg() and tcp_v4_connect() are called from
> process context, not from softirq context.
> 
> This was detected by lockdep seqlock support.
> 
> Reported-by: jongman heo 
> Fixes: 584bdf8cbdf6 ("[IPV4]: Fix "ipOutNoRoutes" counter error for TCP and UDP")
> Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
> Signed-off-by: Eric Dumazet 
> Cc: Hannes Frederic Sowa 
> ---
> net/ipv4/ping.c     |    2 +-
> net/ipv4/tcp_ipv4.c |    2 +-
> net/ipv4/udp.c      |    2 +-
> 3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> index 840cf1b9e6ee..242e7f4ed6f4 100644
> --- a/net/ipv4/ping.c
> +++ b/net/ipv4/ping.c
> @@ -772,7 +772,7 @@ int ping_v4_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
> err = PTR_ERR(rt);
> rt = NULL;
> if (err == -ENETUNREACH)
> - IP_INC_STATS_BH(net, IPSTATS_MIB_OUTNOROUTES);
> + IP_INC_STATS(net, IPSTATS_MIB_OUTNOROUTES);
> goto out;
> }
> 
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 59a6f8b90cd9..067213924751 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -177,7 +177,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> if (IS_ERR(rt)) {
> err = PTR_ERR(rt);
> if (err == -ENETUNREACH)
> - IP_INC_STATS_BH(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
> + IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
> return err;
> }
> 
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 44dfaa09b584..44e3884f9e4c 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -999,7 +999,7 @@ int udp_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
> err = PTR_ERR(rt);
> rt = NULL;
> if (err == -ENETUNREACH)
> - IP_INC_STATS_BH(net, IPSTATS_MIB_OUTNOROUTES);
> + IP_INC_STATS(net, IPSTATS_MIB_OUTNOROUTES);
> goto out;
> }
> 

Hi, Eric,

I've applied your patch, and will let you know the result, after a full day or half day test.
Usually the issue happens within 10 minutes after boot, but to be sure...

Regards,
Jongman Heo.
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
