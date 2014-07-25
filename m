Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447AbaGYNA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:00:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbaGYNAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:00:23 -0400
Message-ID: <53D254D9.9030905@redhat.com>
Date: Fri, 25 Jul 2014 15:00:09 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, willemb@google.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] net: filter: rename 'struct sk_filter' to 'struct
 bpf_prog'
References: <1406275499-7822-1-git-send-email-ast@plumgrid.com> <53D23EAF.4000001@redhat.com> <20140725115414.GA4770@salvia>
In-Reply-To: <20140725115414.GA4770@salvia>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 01:54 PM, Pablo Neira Ayuso wrote:
> On Fri, Jul 25, 2014 at 01:25:35PM +0200, Daniel Borkmann wrote:
>> [ also Cc'ing Willem, Pablo ]
>>
>> On 07/25/2014 10:04 AM, Alexei Starovoitov wrote:
>>> 'sk_filter' name is used as 'struct sk_filter', function sk_filter() and
>>> as variable 'sk_filter', which makes code hard to read.
>>> Also it's easily confused with 'struct sock_filter'
>>> Rename 'struct sk_filter' to 'struct bpf_prog' to clarify semantics and
>>> align the name with generic BPF use model.
>>
>> Agreed, as we went for kernel/bpf/, renaming makes absolutely sense.
>
> My nft socket filtering changes are accomodated into struct sk_filter,
> and will still be, so I still need some generic name there...

All the parts from filter.c which is BPF's core engine have been moved
into kernel/bpf/ to get it ready for tracing et al, since there is not
always a socket context anymore. The *whole* infrastructure around struct
sk_filter is [e]BPF and used in non-net related contexts as well, whereas
nft socket filtering is *only* for sockets. Due to the socket-only specific
use case why doesn't it make more sense to have a union in struct sock
around sk_filter (or however we name it) and only allow one of the two
being loaded on a socket?
