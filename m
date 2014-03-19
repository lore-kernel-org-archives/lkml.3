Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbaCSVHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:07:23 -0400
Received: from smtp.citrix.com ([66.165.176.89]:25746 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065AbaCSVHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:07:19 -0400
X-IronPort-AV: E=Sophos;i="4.97,688,1389744000"; 
   d="scan'208";a="113054694"
Message-ID: <532A06FC.5000001@citrix.com>
Date: Wed, 19 Mar 2014 21:07:08 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Graf <tgraf@redhat.com>, Jesse Gross <jesse@nicira.com>,
        <pshelar@nicira.com>, <dev@openvswitch.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
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
        Miklos Szeredi <mszeredi@suse.cz>, <netfilter-devel@vger.kernel.org>,
        <netfilter@vger.kernel.org>, <coreteam@netfilter.org>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] core, nfqueue, openvswitch: Orphan frags in skb_zerocopy
 and handle errors
References: <1395261516-305-1-git-send-email-zoltan.kiss@citrix.com> <532A026E.5070609@redhat.com>
In-Reply-To: <532A026E.5070609@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/14 20:47, Thomas Graf wrote:
> On 03/19/2014 09:38 PM, Zoltan Kiss wrote:
>> skb_zerocopy can copy elements of the frags array between skbs, but it
>> doesn't
>> orphan them. Also, it doesn't handle errors, so this patch takes care
>> of that
>> as well.
>>
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>> ---
>
>> +    if (unlikely(skb_orphan_frags(to, GFP_ATOMIC))) {
>> +        skb_tx_error(to);
>> +        return -ENOMEM;
>>       }
>
> I think you should move this down to right before we iterate over the
> frags.

I agree, I was mislead by that __skb_fill_page_desc, but now I see it is 
actually the head buffer of the source, not a frag from there. And in 
case of a failure in skb_copy_bits we can spare an orphan_frag.

Zoli

