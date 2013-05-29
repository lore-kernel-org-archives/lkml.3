Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966580Ab3E2PAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:00:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:45380 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966260Ab3E2PAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:00:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,764,1363158000"; 
   d="scan'208";a="341998675"
Message-ID: <51A617D7.6000406@linux.intel.com>
Date: Wed, 29 May 2013 17:59:35 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Or Gerlitz <or.gerlitz@gmail.com>
CC: Eric Dumazet <erdnetdev@gmail.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v6 net-next 2/5] net: implement support for low latency
 socket polling
References: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com> <20130529063935.27486.18610.stgit@ladj378.jer.intel.com> <CAJZOPZJqF1FTLH3a3ZKUTA4ViesAZEkRi=dgd-ux8eRu9TyhBw@mail.gmail.com>
In-Reply-To: <CAJZOPZJqF1FTLH3a3ZKUTA4ViesAZEkRi=dgd-ux8eRu9TyhBw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/2013 17:14, Or Gerlitz wrote:
> On Wed, May 29, 2013 at 9:39 AM, Eliezer Tamir
> <eliezer.tamir@linux.intel.com> wrote:
>> Adds a new ndo_ll_poll method and the code that supports and uses it.
>> This method can be used by low latency applications to busy poll Ethernet
>> device queues directly from the socket code. The value of sysctl_net_ll_poll
>> controls how many microseconds to poll. Set to zero to disable.
>
> Unlike with TCP sockets, UDP sockets may receive packets from multiple
> sources and hence the receiving context may be steered to be executed
> on different cores through RSS or other Flow-Steering HW mechanisms
> which could mean different napi contexts for the same socket, is that
> a problem here? what's the severity?

Nothing will break if you poll on the wrong queue.
Your data will come through normal NAPI processing of the right queue.

One of the things we plan on adding in the next version is a more fine 
grained control over which sockets get to busy poll.

-Eliezer
