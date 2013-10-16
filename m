Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009Ab3JPDZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 23:25:21 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:64605 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3JPDZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 23:25:18 -0400
Message-ID: <525E06E6.2080502@huawei.com>
Date: Wed, 16 Oct 2013 11:24:22 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "Francois Romieu" <romieu@fr.zoreil.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Chas Williams <chas@cmf.nrl.navy.mil>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Samuel Ortiz <samuel@sortiz.org>, Paul Mackerras <paulus@samba.org>,
        Oliver Neukum <oneukum@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, <netfilter@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <guohanjun@huawei.com>
Subject: Re: [PATCH 02/18] net: use wrapper functions of net_ratelimit() to
 simplify code
References: <1381837514-50660-1-git-send-email-wangkefeng.wang@huawei.com>  <1381837514-50660-3-git-send-email-wangkefeng.wang@huawei.com> <1381854263.22110.19.camel@joe-AO722>
In-Reply-To: <1381854263.22110.19.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.221]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your reply.

On 10/16 0:24, Joe Perches wrote:
> On Tue, 2013-10-15 at 19:44 +0800, Kefeng Wang wrote:
>> Wrapper functions net_ratelimited_function() and net_XXX_ratelimited()
>> are called to simplify code.
> []
>> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> []
>> @@ -465,10 +465,8 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
>>  	if (likely(fdb)) {
>>  		/* attempt to update an entry for a local interface */
>>  		if (unlikely(fdb->is_local)) {
>> -			if (net_ratelimit())
>> -				br_warn(br, "received packet on %s with "
>> -					"own address as source address\n",
>> -					source->dev->name);
>> +			net_ratelimited_function(br_warn, br, "received packet on %s "
>> +				"with own address as source address\n", source->dev->name);
> 
> Hello Kefeng.
> 
> When these types of lines are changed, please coalesce the
> fragmented format pieces into a single string.
> 
> It makes grep a bit easier and 80 columns limits don't
> apply to formats.

Got it, I will coalesce them, but 80 columns limits will be
broken.

> I think using net_ratelimited_function is not particularly
> clarifying here.
> 
> Maybe net_ratelimited_function should be removed instead
> of its use sites expanded.
> 
> Perhaps adding macros like #define br_warn_ratelimited()
> would be better.

yes, I found dev_emerg_ratelimited already exists. I should
use them and will add some similar mcaros.

> This comment applies to the whole series.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> .
> 


