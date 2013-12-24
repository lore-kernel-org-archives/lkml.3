Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab3LXQYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 11:24:54 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:62366 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab3LXQYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 11:24:53 -0500
Message-ID: <52B9B559.2060400@cogentembedded.com>
Date: Tue, 24 Dec 2013 20:24:57 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ding Tianhong <dingtianhong@huawei.com>,
        Michal Ostrowski <mostrows@earthlink.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 06/20] ppp: slight optimization of addr compare
References: <52B96FCD.50901@huawei.com>
In-Reply-To: <52B96FCD.50901@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-12-2013 15:28, Ding Tianhong wrote:

> Use possibly more efficient ether_addr_equal
> to instead of memcmp.

> Cc: Michal Ostrowski <mostrows@earthlink.net>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> ---
>   drivers/net/ppp/pppoe.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)

> diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
> index 82ee6ed..1808a10 100644
> --- a/drivers/net/ppp/pppoe.c
> +++ b/drivers/net/ppp/pppoe.c
> @@ -131,12 +131,13 @@ static inline struct pppoe_net *pppoe_pernet(struct net *net)
>
>   static inline int cmp_2_addr(struct pppoe_addr *a, struct pppoe_addr *b)
>   {
> -	return a->sid == b->sid && !memcmp(a->remote, b->remote, ETH_ALEN);
> +	return a->sid == b->sid && ether_addr_equal(a->remote,
> +							      b->remote);

    If it really doesn't fit insto single line, the continuation line should 
start right under 'a->remote'.

WBR, Sergei

