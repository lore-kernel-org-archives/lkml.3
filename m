Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaJVI5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:57:52 -0400
Received: from mx0.aculab.com ([213.249.233.131]:53307 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753454AbaJVI5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:57:50 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Sasha Levin'" <sasha.levin@oracle.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC: "a.ryabinin@samsung.com" <a.ryabinin@samsung.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "mschmidt@redhat.com" <mschmidt@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] netlink: don't copy over empty attribute data
Thread-Topic: [PATCH] netlink: don't copy over empty attribute data
Thread-Index: AQHP7XCqNtnisQ6kGkCcFJwzg6TZJJw70J0A
Date: Wed, 22 Oct 2014 08:55:51 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1C9DCF6A@AcuExch.aculab.com>
References: <1413924669-26732-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1413924669-26732-1-git-send-email-sasha.levin@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin
> netlink uses empty data to seperate different levels. However, we still
> try to copy that data from a NULL ptr using memcpy, which is an undefined
> behaviour.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  lib/nlattr.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/nlattr.c b/lib/nlattr.c
> index 9c3e85f..6512b43 100644
> --- a/lib/nlattr.c
> +++ b/lib/nlattr.c
> @@ -430,7 +430,8 @@ void __nla_put(struct sk_buff *skb, int attrtype, int attrlen,
>  	struct nlattr *nla;
> 
>  	nla = __nla_reserve(skb, attrtype, attrlen);
> -	memcpy(nla_data(nla), data, attrlen);
> +	if (data)
> +		memcpy(nla_data(nla), data, attrlen);

Were it even appropriate to add a conditional here, the correct
check would be against 'attrlen', not 'data'.

	David

>  }
>  EXPORT_SYMBOL(__nla_put);
> 
> --
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


