Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbbALRTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:19:54 -0500
Received: from mars.intermailgate.com ([80.242.145.70]:52945 "EHLO
	mars.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbbALRTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:19:52 -0500
X-Antivirus-MYDOMAIN-Mail-From: netdev@bof.de via mars
X-Antivirus-MYDOMAIN: 1.25-st-qms (Clear:RC:0(192.109.53.146):SA:0(1.3/10.0):. Processed in 0.462407 secs Process 7089)
From: Patrick Schaaf <netdev@bof.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, davem@davemloft.net,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bhutchings@solarflare.com, john.fastabend@gmail.com,
        herbert@gondor.apana.org.au, vyasevic@redhat.com, jiri@resnulli.us,
        vfalico@gmail.com, therbert@google.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, jmorris@namei.org, kuznet@ms2.inr.ac.ru,
        kadlec@blackhole.kfki.hu, kaber@trash.net, pablo@netfilter.org,
        kay@vrfy.org, stephen@networkplumber.org
Subject: Re: [PATCH 2/3] x_tables: Use also dev->ifalias for interface matching
Date: Mon, 12 Jan 2015 18:19:49 +0100
Message-ID: <2868544.UBk2Y85taW@rofl>
User-Agent: KMail/4.14.3 (Linux/3.18.2-1.ga393f37-desktop; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1421081514.4099.14.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1421009571-5279-1-git-send-email-richard@nod.at> <1425960.ovH4s7sjue@rofl> <1421081514.4099.14.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2015 08:51:54 Eric Dumazet wrote:
> On Mon, 2015-01-12 at 17:39 +0100, Patrick Schaaf wrote:
> > 
> > Not to comment on the ifalias thing, which I think is unneccessary,
> > too, but matching on interface names instead of only ifindex, is
> > definitely needed, so that one can establish a full ruleset before
> > interfaces even exist. That's good practise at boottime, but also
> > needed for dynamic interface creation during runtime.
> 
> Please do not send html messages : Your reply did not reach the lists.

Sigh. Sorry...

> Then, all you mention could have been solved by proper userspace
> support.
> 
> Every time you add an interface or change device name, you could change
> firewalls rules if needed. Nothing shocking here.

That is totally impractical, IMO.

Interfaces come and go through many different actions. There's the admin 
downing and upping stuff like bridges or bonds. There's stuff like libvirt / 
KVM / qemu creating and destroying interfaces. In all these cases, in my 
practise, I give the interfaces useful names to that I can prefix-match them 
in iptables rules.

Dynamically modifying the ruleset for each such creation and destruction, 
would be a huge burden. The base ruleset would need suitable "hooks" where 
these rules were inserted (ordering matters!). The addition would hardly be 
atomic (with traditional iptables, unless done by generating a whole new 
ruleset and restoring). The programs (e.g. libvirt) would need to be able to 
call out to these specially crafted rule generator scripts. The admin would 
need to add them as pre/post actions to their static (manual) interface 
configuration. Loading and looking at the ruleset before bringing up the 
interface would be impossible.

Note that I do fully agree that it's sad that iptables rules waste all that 
memory for each and every rule! I remember musing about improving that in 
talks with Harald Welte back in the 90ies. A simple match would be perfectly 
fine for me. Only having ifindex support, isn't.

best regards
  Patrick
