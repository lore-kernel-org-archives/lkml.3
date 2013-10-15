Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab3JOQYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:24:36 -0400
Received: from smtprelay0189.hostedemail.com ([216.40.44.189]:35909 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932283Ab3JOQYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:24:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::::::konrad.w
X-HE-Tag: rice84_26ab8e8bac32a
X-Filterd-Recvd-Size: 3076
Message-ID: <1381854263.22110.19.camel@joe-AO722>
Subject: Re: [PATCH 02/18] net: use wrapper functions of net_ratelimit() to
 simplify code
From: Joe Perches <joe@perches.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Chas Williams <chas@cmf.nrl.navy.mil>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Samuel Ortiz <samuel@sortiz.org>, Paul Mackerras <paulus@samba.org>,
        Oliver Neukum <oneukum@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, netfilter@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        guohanjun@huawei.com
Date: Tue, 15 Oct 2013 09:24:23 -0700
In-Reply-To: <1381837514-50660-3-git-send-email-wangkefeng.wang@huawei.com>
References: <1381837514-50660-1-git-send-email-wangkefeng.wang@huawei.com>
	 <1381837514-50660-3-git-send-email-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 19:44 +0800, Kefeng Wang wrote:
> Wrapper functions net_ratelimited_function() and net_XXX_ratelimited()
> are called to simplify code.
[]
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
[]
> @@ -465,10 +465,8 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
>  	if (likely(fdb)) {
>  		/* attempt to update an entry for a local interface */
>  		if (unlikely(fdb->is_local)) {
> -			if (net_ratelimit())
> -				br_warn(br, "received packet on %s with "
> -					"own address as source address\n",
> -					source->dev->name);
> +			net_ratelimited_function(br_warn, br, "received packet on %s "
> +				"with own address as source address\n", source->dev->name);

Hello Kefeng.

When these types of lines are changed, please coalesce the
fragmented format pieces into a single string.

It makes grep a bit easier and 80 columns limits don't
apply to formats.

I think using net_ratelimited_function is not particularly
clarifying here.

Maybe net_ratelimited_function should be removed instead
of its use sites expanded.

Perhaps adding macros like #define br_warn_ratelimited()
would be better.

This comment applies to the whole series.

