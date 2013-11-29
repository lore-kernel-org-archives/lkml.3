Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3K2Kmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:42:47 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49527 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab3K2Kmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:42:42 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-28-52986fa1396d
Date: Fri, 29 Nov 2013 10:42:41 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: Re: Re: [PATCH v2] inet: fix possible seqlock deadlocks
To: Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: David Miller <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20131129103451609@jongman.heo
Msgkey: 20131129103451609@jongman.heo
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
X-ParentMTR: 20131129020248524@jongman.heo
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <788421.176041385721758959.JavaMail.weblogic@epml08>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42JZI2JSqLswf0aQwYmdvBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStj25JGtoIZchVHju5mamDcINvFyMkhJKAmcfPzIUYQW0LAROL5
	iflMELaYxIV769m6GLmAapYySqy4/JUZpmjeh8tMEIn5jBJrHs9gB0mwCKhKfJrQxQpiswno
	SHT83w9mCws4SNzs+go2VUQgQWL/xhvMIM3MAgsYJZZ9OsYIcYaixLWli9lAbF4BQYmTM5+w
	QGxTkXhzuY0JIq4qsWX5bKhTxSUuzL3EDmHzSsxofwpVLycx7esaqEulJc7P2sAI887i74+h
	4vwSx27vAJrJAdb75H4wzJjdm7+wQdgCElPPHIRq1ZS4vf81NFS0JQ5dussOM2bXqeXMML33
	t8wFq2EGemVK90N2kPHMQL3rd+mj+4oXGCSL1j5nmsCoPAtJahaS7lkI3chKFjCyrGIUTS1I
	LihOSi8y1CtOzC0uzUvXS87P3cQITAun/z3r3cF4+4D1IcZkYIxMZJYSTc4HppW8knhDYzMj
	C1MTU2Mjc0sz0oSVxHmTHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBkif/9qcgy/Jtp
	dnJgl/zMBoH1HPntJe6WK2ZJf6zd9V1sUoCV5cOlU/av/66WdzFA0XAGn9LUbde/MihnT6jp
	iOh3PPqL2evcQr2JTeuiWw/P0Mh99ubAiROLJeMXRHPUyh14enB+sMA0/tVRb2OydTUd97rO
	fsKzUcxs77FM8+iZ+0J55wUrsRRnJBpqMRcVJwIA0XaBGyEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t/tmboL82cEGaz8yGpxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jK2
	LWlkK5ghV3Hk6G6mBsYNsl2MnBxCAmoSNz8fYgSxJQRMJOZ9uMwEYYtJXLi3nq2LkQuoZj6j
	xJrHM9hBEiwCqhKfJnSxgthsAjoSHf/3g9nCAg4SN7u+gjWLCCRI7N94gxmkmVlgAaPEsk/H
	GCG2KUpcW7qYDcTmFRCUODnzCQvENhWJN5fbmCDiqhJbls+Gukhc4sLcS+wQNq/EjPanUPVy
	EtO+rmGGsKUlzs/awAhz9eLvj6Hi/BLHbu8AmskB1vvkfjDMmN2bv7BB2AISU88chGrVlLi9
	/zXU89oShy7dZYcZs+vUcmaY3vtb5oLVMAO9MqX7ITvIeGag3vW79NF9xQsMkkVrnzNNYJSb
	hSQ1C0n3LIRuZCULGFlWMYqmFiQXFCelV5joFSfmFpfmpesl5+duYgQnp2dLdjA2XLA+xCjA
	wajEwxvQOT1IiDWxrLgy9xCjBAezkgjvtNwZQUK8KYmVValF+fFFpTmpxYcYk4HxN5FZSjQ5
	H5g480riDY2NTcxMTC1NLAxMzUkTVhLnXXArKUhIID2xJDU7NbUgtQhmCxMHp1QDI/djV0nP
	3bsPB85eK1ycouU86ZOupR13pMf7sFn3GFgDcmdxLgn+uq9u6zOu9N72Z8XpP3nvqT0M6ZXo
	cmh3zFVsWj/RkXk5D9erb+n3UwPrLn+ec5VD+7LkzHcHeN/kfr3RNcfea/fGcr6jesdtDuQl
	ajeH39oq0ez/rCTn/u+9R2LjfBtWKLEUZyQaajEXFScCAGc2ji6SAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rATAgrSV032281


------- Original Message -------
Sender : Jongman Heo <jongman.heo@samsung.com>
Date : 2013-11-29 11:08 (GMT+09:00)
Title : Re: [PATCH v2] inet: fix possible seqlock deadlocks
>
>
>------ Original Message -------
>Sender : Eric Dumazet
>Date : 2013-11-29 02:51 (GMT+09:00)
>Title : [PATCH v2] inet: fix possible seqlock deadlocks
>> 
>> From: Eric Dumazet 
>> 
>> In commit c9e9042994d3 ("ipv4: fix possible seqlock deadlock") I left
>> another places where IP_INC_STATS_BH() were improperly used.
>> 
>> udp_sendmsg(), ping_v4_sendmsg() and tcp_v4_connect() are called from
>> process context, not from softirq context.
>> 
>> This was detected by lockdep seqlock support.
>> 
>> Reported-by: jongman heo 
>> Fixes: 584bdf8cbdf6 ("[IPV4]: Fix "ipOutNoRoutes" counter error for TCP and UDP")
>> Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
>> Signed-off-by: Eric Dumazet 
>> Cc: Hannes Frederic Sowa 
>> ---
>> net/ipv4/ping.c     |    2 +-
>> net/ipv4/tcp_ipv4.c |    2 +-
>> net/ipv4/udp.c      |    2 +-
>> 3 files changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
>> index 840cf1b9e6ee..242e7f4ed6f4 100644
>> --- a/net/ipv4/ping.c
>> +++ b/net/ipv4/ping.c
>> @@ -772,7 +772,7 @@ int ping_v4_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
>> err = PTR_ERR(rt);
>> rt = NULL;
>> if (err == -ENETUNREACH)
>> - IP_INC_STATS_BH(net, IPSTATS_MIB_OUTNOROUTES);
>> + IP_INC_STATS(net, IPSTATS_MIB_OUTNOROUTES);
>> goto out;
>> }
>> 
>> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
>> index 59a6f8b90cd9..067213924751 100644
>> --- a/net/ipv4/tcp_ipv4.c
>> +++ b/net/ipv4/tcp_ipv4.c
>> @@ -177,7 +177,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>> if (IS_ERR(rt)) {
>> err = PTR_ERR(rt);
>> if (err == -ENETUNREACH)
>> - IP_INC_STATS_BH(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
>> + IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
>> return err;
>> }
>> 
>> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
>> index 44dfaa09b584..44e3884f9e4c 100644
>> --- a/net/ipv4/udp.c
>> +++ b/net/ipv4/udp.c
>> @@ -999,7 +999,7 @@ int udp_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
>> err = PTR_ERR(rt);
>> rt = NULL;
>> if (err == -ENETUNREACH)
>> - IP_INC_STATS_BH(net, IPSTATS_MIB_OUTNOROUTES);
>> + IP_INC_STATS(net, IPSTATS_MIB_OUTNOROUTES);
>> goto out;
>> }
>> 
>
>Hi, Eric,
>
>I've applied your patch, and will let you know the result, after a full day or half day test.
>Usually the issue happens within 10 minutes after boot, but to be sure...
>
>Regards,
>Jongman Heo.
>

Hi, Eric,

It has survived about 9 hours, looks fine. Thanks~.

Tested-by: Jongman Heo <jongman.heo@samsung.com>
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
