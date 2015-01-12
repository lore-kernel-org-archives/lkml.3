Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbbALQMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:12:43 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbbALQM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:12:29 -0500
Message-ID: <54B3F265.9030301@nod.at>
Date: Mon, 12 Jan 2015 17:12:21 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: davem@davemloft.net, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bhutchings@solarflare.com,
        john.fastabend@gmail.com, herbert@gondor.apana.org.au,
        vyasevic@redhat.com, jiri@resnulli.us, vfalico@gmail.com,
        therbert@google.com, edumazet@google.com, yoshfuji@linux-ipv6.org,
        jmorris@namei.org, kuznet@ms2.inr.ac.ru, kadlec@blackhole.kfki.hu,
        kaber@trash.net, pablo@netfilter.org, kay@vrfy.org,
        stephen@networkplumber.org
Subject: Re: [PATCH 2/3] x_tables: Use also dev->ifalias for interface matching
References: <1421009571-5279-1-git-send-email-richard@nod.at>	 <1421009571-5279-3-git-send-email-richard@nod.at> <1421078666.4099.6.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1421078666.4099.6.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.01.2015 um 17:04 schrieb Eric Dumazet:
> On Sun, 2015-01-11 at 21:52 +0100, Richard Weinberger wrote:
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  include/linux/netfilter/x_tables.h | 22 ++++++++++++++++++++++
>>  net/ipv4/netfilter/arp_tables.c    | 28 +++++++++++++++++-----------
>>  net/ipv4/netfilter/ip_tables.c     | 15 +++++----------
>>  net/ipv6/netfilter/ip6_tables.c    | 18 +++++++-----------
>>  net/netfilter/xt_physdev.c         |  9 ++-------
>>  5 files changed, 53 insertions(+), 39 deletions(-)
> 
> Richard, I dislike this, sorry.

That's fine, the series carries the "RFC" burning mark for a reason.

> iptables is already horribly expensive, you add another expensive step
> for every rule.

Yeah, you mean the extra unlikey() check?

> device aliasing can be done from user space.

How?

I did this series because I'm not so happy with the device renaming what udev
does.
The idea was to offer udev a better kernel interface to deal with aliases.
Such that one can use the regular names form the kernel and the predictable
names generated from udev.

For block devices it was easy, we have the good old symlink.
For network interface the kernel does not offer an API.

> iptables should have used ifindex, its sad we allowed the substring
> match in first place.

Maybe nftables can do better. :-)

Thanks,
//richard
