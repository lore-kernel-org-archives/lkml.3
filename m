Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbaBTTcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:32:51 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37914 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755536AbaBTTct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:32:49 -0500
Date: Thu, 20 Feb 2014 20:32:31 +0100
From: Florian Westphal <fw@strlen.de>
To: Artie Hamilton <artiemhamilton@yahoo.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "\"David S. Miller\"" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: ip6tables IPv6-REDIRECT over bridges
Message-ID: <20140220193231.GB7119@breakpoint.cc>
References: <1392920071.66303.YahooMailNeo@web172306.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392920071.66303.YahooMailNeo@web172306.mail.ir2.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artie Hamilton <artiemhamilton@yahoo.com> wrote:
> Now the same thing should be done for IPv6. It should works quite similar
> (I just assume the above mentioned steps are already done):
> 
> $ sysctl -w net.ipv6.conf.br0.accept_ra=2
> $ sysctl -w net.bridge.bridge-nf-call-ip6tables=1
> $ ip6tables -t nat -A PREROUTING -p tcp -m tcp --dport 8080 -j REDIRECT --to-ports 81
> 
> But here is the problem: Connections will not be started. I see for example
> connections getting started to the service like this on the client:

Yes, because bridge layer does not detect when addresses have been
rewritten.

The check is only implemented for ipv4, see dnat_took_place use in br_netfilter.c
