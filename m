Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965279AbaCULI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 07:08:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760234AbaCULI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 07:08:27 -0400
Message-ID: <532C1D74.50008@redhat.com>
Date: Fri, 21 Mar 2014 12:07:32 +0100
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
Subject: Re: [PATCH v4] core, nfqueue, openvswitch: Orphan frags in skb_zerocopy
 and handle errors
References: <1395397894-9493-1-git-send-email-zoltan.kiss@citrix.com>
In-Reply-To: <1395397894-9493-1-git-send-email-zoltan.kiss@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 11:31 AM, Zoltan Kiss wrote:
> skb_zerocopy can copy elements of the frags array between skbs, but it doesn't
> orphan them. Also, it doesn't handle errors, so this patch takes care of that
> as well, and modify the callers accordingly. skb_tx_error() is also added to
> the callers so they will signal the failed delivery towards the creator of the
> skb.
>
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> ---
> v2: orphan the frags right before touching the frags
>
> v3:
> - orphan 'from' instead of 'to'
> - call skb_tx_error() in the callers if something went wrong
>
> v4: correctly use error path in queue_userspace_packet

LGTM now

Acked-by: Thomas Graf <tgraf@redhat.com>

