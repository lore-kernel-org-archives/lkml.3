Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbaCZWi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 18:38:58 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:15059 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbaCZWix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 18:38:53 -0400
X-IronPort-AV: E=Sophos;i="4.97,738,1389744000"; 
   d="scan'208";a="113959114"
Message-ID: <533356F8.7070307@citrix.com>
Date: Wed, 26 Mar 2014 22:38:48 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <jesse@nicira.com>, <pshelar@nicira.com>, <tgraf@redhat.com>,
        <dev@openvswitch.org>, <pablo@netfilter.org>,
        <kadlec@blackhole.kfki.hu>, <edumazet@google.com>,
        <dborkman@redhat.com>, <therbert@google.com>, <jasowang@redhat.com>,
        <fw@strlen.de>, <joe@perches.com>, <horms@verge.net.au>,
        <jiri@resnulli.us>, <mst@redhat.com>, <Paul.Durrant@citrix.com>,
        <JBeulich@suse.com>, <herbert@gondor.apana.org.au>, <mszeredi@suse.cz>,
        <netfilter-devel@vger.kernel.org>, <netfilter@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4] core, nfqueue, openvswitch: Orphan frags in skb_zerocopy
 and handle errors
References: <1395397894-9493-1-git-send-email-zoltan.kiss@citrix.com>	<20140326.155958.1928261590856069753.davem@davemloft.net> <20140326.161242.576245997077162750.davem@davemloft.net>
In-Reply-To: <20140326.161242.576245997077162750.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-7"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/03/14 20:12, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 26 Mar 2014 15:59:58 -0400 (EDT)
>
>> From: Zoltan Kiss <zoltan.kiss@citrix.com>
>> Date: Fri, 21 Mar 2014 10:31:34 +0000
>>
>>> skb_zerocopy can copy elements of the frags array between skbs, but it doesn't
>>> orphan them. Also, it doesn't handle errors, so this patch takes care of that
>>> as well, and modify the callers accordingly. skb_tx_error() is also added to
>>> the callers so they will signal the failed delivery towards the creator of the
>>> skb.
>>>
>>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>>
>> Applied, thanks Zoltan.
>
> Actually, Zoltan, you have to fix this:
>
> net/core/skbuff.c: In function ¡skb_zerocopy¢:
> net/core/skbuff.c:2172:2: warning: passing argument 1 of ¡skb_orphan_frags¢ discards ¡const¢ qualifi
> er from pointer target type [enabled by default]
> In file included from include/linux/tcp.h:21:0,
>                   from net/core/skbuff.c:50:
> include/linux/skbuff.h:1904:19: note: expected ¡struct sk_buff *¢ but argument is of type ¡const str
> uct sk_buff *¢
> net/core/skbuff.c:2173:3: warning: passing argument 1 of ¡skb_tx_error¢ discards ¡const¢ qualifier f
> rom pointer target type [enabled by default]
> net/core/skbuff.c:642:6: note: expected ¡struct sk_buff *¢ but argument is of type ¡const struct sk_
> buff *¢
>

Ok, resubmitted. 'from' is now not a const parameter, because 
skb->pfmemalloc might change.

Zoli
