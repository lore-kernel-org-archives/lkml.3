Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbaCTMey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:34:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbaCTMet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:34:49 -0400
Message-ID: <532AE010.9050903@redhat.com>
Date: Thu, 20 Mar 2014 13:33:20 +0100
From: Thomas Graf <tgraf@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Zoltan Kiss <zoltan.kiss@citrix.com>, Jesse Gross <jesse@nicira.com>,
        pshelar@nicira.com, dev@openvswitch.org
CC: "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Tom Herbert <therbert@google.com>, Jason Wang <jasowang@redhat.com>,
        Florian Westphal <fw@strlen.de>, Joe Perches <joe@perches.com>,
        Simon Horman <horms@verge.net.au>, Jiri Pirko <jiri@resnulli.us>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        Jan Beulich <JBeulich@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Miklos Szeredi <mszeredi@suse.cz>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2] core, nfqueue, openvswitch: Orphan frags in skb_zerocopy
 and handle errors
References: <1395263249-16450-1-git-send-email-zoltan.kiss@citrix.com> <532ADC33.5040607@redhat.com>
In-Reply-To: <532ADC33.5040607@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 01:16 PM, Thomas Graf wrote:
> On 03/19/2014 10:07 PM, Zoltan Kiss wrote:
>> skb_zerocopy can copy elements of the frags array between skbs, but it
>> doesn't
>> orphan them. Also, it doesn't handle errors, so this patch takes care
>> of that
>> as well.
>>
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>
> Acked-by: Thomas Graf <tgraf@redhat.com>

I take this back ;)

>> ---
>> +    if (unlikely(skb_orphan_frags(to, GFP_ATOMIC))) {
>> +        skb_tx_error(to);
>> +        return -ENOMEM;
>> +    }

Just noticed that you orphan the Netlink skb frags which do not
exist yet instead of the source skb frags.

> Did you consider calling skb_tx_error() for Netlink message
> allocation failures for the upcall as well? That memory pressure
> is currently not reported back.

