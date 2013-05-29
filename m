Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966876Ab3E2UUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:20:47 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:36693 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966780Ab3E2UUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:20:41 -0400
Message-ID: <1369858835.1971.26.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH v6 net-next 2/5] net: implement support for low latency
 socket polling
From: Ben Hutchings <bhutchings@solarflare.com>
To: Or Gerlitz <or.gerlitz@gmail.com>
CC: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Eric Dumazet <erdnetdev@gmail.com>, David Miller <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 29 May 2013 21:20:35 +0100
In-Reply-To: <CAJZOPZJqF1FTLH3a3ZKUTA4ViesAZEkRi=dgd-ux8eRu9TyhBw@mail.gmail.com>
References: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com>
	 <20130529063935.27486.18610.stgit@ladj378.jer.intel.com>
	 <CAJZOPZJqF1FTLH3a3ZKUTA4ViesAZEkRi=dgd-ux8eRu9TyhBw@mail.gmail.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19900.004
X-TM-AS-Result: No--22.817600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 17:14 +0300, Or Gerlitz wrote:
> On Wed, May 29, 2013 at 9:39 AM, Eliezer Tamir
> <eliezer.tamir@linux.intel.com> wrote:
> > Adds a new ndo_ll_poll method and the code that supports and uses it.
> > This method can be used by low latency applications to busy poll Ethernet
> > device queues directly from the socket code. The value of sysctl_net_ll_poll
> > controls how many microseconds to poll. Set to zero to disable.
> 
> Unlike with TCP sockets, UDP sockets may receive packets from multiple
> sources and hence the receiving context may be steered to be executed
> on different cores through RSS or other Flow-Steering HW mechanisms
> which could mean different napi contexts for the same socket, is that
> a problem here? what's the severity?

Maybe ARFS could be extended so the driver can tell whether a UDP socket
it's steering for is connected or not.  Then for disconnected sockets
the driver can use a filter that only matches destination address.
(Though that's probably undesirable if the socket has SO_REUSEPORT set.)

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

