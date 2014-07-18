Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946079AbaGRVFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:05:40 -0400
Received: from ja.ssi.bg ([178.16.129.10]:35921 "EHLO ja.home.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932291AbaGRVFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:05:38 -0400
X-Greylist: delayed 654 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2014 17:05:31 EDT
Date: Fri, 18 Jul 2014 23:48:07 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
X-X-Sender: ja@ja.home.ssi.bg
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org, dcb314@hotmail.com,
        davem@davemloft.net, kadlec@blackhole.kfki.hu, kaber@trash.net,
        pablo@netfilter.org, horms@verge.net.au, wensong@linux-vs.org
Subject: Re: [PATCH 3/5] net/netfilter/ipvs/ip_vs_ctl.c: drop argument range
 check just before the check for equality
In-Reply-To: <1405697638-23767-1-git-send-email-andrey.krieger.utkin@gmail.com>
Message-ID: <alpine.LFD.2.11.1407182339160.2273@ja.home.ssi.bg>
References: <1405697638-23767-1-git-send-email-andrey.krieger.utkin@gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Fri, 18 Jul 2014, Andrey Utkin wrote:

> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80601
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> ---
>  net/netfilter/ipvs/ip_vs_ctl.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 581a658..4ed7b59 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -2338,8 +2338,6 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
>  
>  	if (cmd < IP_VS_BASE_CTL || cmd > IP_VS_SO_SET_MAX)
>  		return -EINVAL;
> -	if (len < 0 || len >  MAX_ARG_LEN)
> -		return -EINVAL;

	The above check ensures the set_arglen[] value (some
struct size) does not exceed the arg[MAX_ARG_LEN] space. You can check
commit 04bcef2a83f40c ("ipvs: Add boundary check on ioctl arguments")
for more info. Still, check can be reduced to
if (len > MAX_ARG_LEN)... Also, len is unsigned, so len < 0 is
useless even for this reason.

>  	if (len != set_arglen[SET_CMDID(cmd)]) {
>  		pr_err("set_ctl: len %u != %u\n",
>  		       len, set_arglen[SET_CMDID(cmd)]);
> -- 
> 1.8.5.5

Regards

--
Julian Anastasov <ja@ssi.bg>
