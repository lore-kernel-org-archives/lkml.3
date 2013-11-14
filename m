Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab3KNIUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:20:25 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:56808 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab3KNIUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:20:21 -0500
MIME-Version: 1.0
In-Reply-To: <20131112135412.GF14929@order.stressinduktion.org>
References: <CAP8BHkGZ5EFxW4BNervKrOiEaQTNdSh9s2YOrFoexzQCOR=AqQ@mail.gmail.com>
	<20131111203954.GB3043@order.stressinduktion.org>
	<CAP8BHkG6=KuU9K7=sGsZftMDe58eTYByRu2DZ+j+KNqcfsOfAA@mail.gmail.com>
	<20131112135412.GF14929@order.stressinduktion.org>
Date: Thu, 14 Nov 2013 13:50:20 +0530
Message-ID: <CAP8BHkEyASA52Q4Zg4w5OqR7Hv7Y_it8SnG_tMPViza_T9TV+Q@mail.gmail.com>
Subject: Re: IPv6: Blackhole route support partial ?
From: Kamala R <kamala@aristanetworks.com>
To: Kamala R <kamala@aristanetworks.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have one quick question before I send the patch across. I noticed
that "ip -6 route show" shows an error -22 in the output which
signifies -EINVAL associated with blackhole routes. This behaviour is
not consistent with that of "ip route show" that shows no such error
for a blackhole route. Does this qualify a bug that needs fixing ?

Regards,
Kamala

On Tue, Nov 12, 2013 at 7:24 PM, Hannes Frederic Sowa
<hannes@stressinduktion.org> wrote:
> On Tue, Nov 12, 2013 at 04:39:10PM +0530, Kamala R wrote:
>> Hi,
>>
>> Sure, here it is.
>>
>> --- linux-3.12/net/ipv6/route.c.orig    2013-11-12 16:23:46.000000000 +0530
>> +++ linux-3.12/net/ipv6/route.c 2013-11-12 16:30:51.000000000 +0530
>> @@ -1570,9 +1570,13 @@ int ip6_route_add(struct fib6_config *cf
>>                 switch (cfg->fc_type) {
>>                 case RTN_BLACKHOLE:
>>                         rt->dst.error = -EINVAL;
>> +                       rt->dst.input = dst_discard;
>> +                       rt->dst.discard = dst_discard;
>>                         break;
>>                 case RTN_PROHIBIT:
>>                         rt->dst.error = -EACCES;
>> +                       rt->dst.input = ip6_pkt_prohibit;
>> +                       rt->dst.output = ip6_pkt_prohibit_out;
>>                         break;
>>                 case RTN_THROW:
>>                         rt->dst.error = -EAGAIN;
>>
>> Is this ok ?
>
> I woud move all the initialization of the function pointer into the
> switch-case. You could merge the case RTN_THROW with the default one by just
> using a ternary statement to initialize dst.error.
>
> Your patch must be well-formed to get included into the
> kernel. For that you should base your patch ontop net-next
> or net, write a proper commit message and send the git
> format-patch generated patch to this list. Here some hints:
> <https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/tree/Documentation/SubmittingPatches>
>
> You can check if your formatting is correct by using scripts/checkpatch
> --strict.
>
> Let me know if there are any problems with that.
>
> Thank you,
>
>   Hannes
>
