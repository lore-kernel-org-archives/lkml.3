Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab3AQK5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:57:21 -0500
Received: from ares07.inai.de ([5.9.24.206]:47544 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756717Ab3AQK5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:57:20 -0500
Date: Thu, 17 Jan 2013 11:57:14 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: David Miller <davem@davemloft.net>
cc: carlos@systemhalted.org, bhutchings@solarflare.com,
        yoshfuji@linux-ipv6.org, amwang@redhat.com, tmb@mageia.org,
        eblake@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, libvirt-list@redhat.com, tgraf@suug.ch,
        libc-alpha@sourceware.org, schwab@suse.de
Subject: Re: Redefinition of struct in6_addr in <netinet/in.h> and
 <linux/in6.h>
In-Reply-To: <20130116.210512.2230612692562212911.davem@davemloft.net>
Message-ID: <alpine.LNX.2.01.1301171153540.15372@nerf07.vanv.qr>
References: <1358351232.2923.10.camel@bwh-desktop.uk.solarflarecom.com> <20130116.164511.2027039182184636075.davem@davemloft.net> <50F75AD7.7000703@systemhalted.org> <20130116.210512.2230612692562212911.davem@davemloft.net>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 2013-01-17 03:05, David Miller wrote:

>From: Carlos O'Donell <carlos@systemhalted.org>
>Date: Wed, 16 Jan 2013 20:58:47 -0500
>
>> So I just went down the rabbit hole, and the further I get the
>> closer I get to having two exact copies of the same definitions
>> in both glibc and the kernel and using whichever one was included
>> first.
>> 
>> Is anyone opposed to that kind of solution?
>
>Sounds interesting, please share :-)

iptables has the same issue, and solved it its way. 
(uapi/)linux/netfilter.h is used to get at things like union 
nf_inet_addr. This union contains struct in6_addr. There is no include 
for in6_addr in netfilter.h itself. This may break the "standalone 
compilation" test, but at least allows for specifying the 
environment-specific header for in6_addr in the C file:

a. userspace: #include <netinet/in.h> before <linux/netfilter.h>
b. kernel parts: #include <linux/in6.h> before <linux/netfilter.h>
