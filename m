Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3EUNbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:31:44 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58935 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab3EUNbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:31:41 -0400
Message-ID: <1369143099.3301.216.camel@edumazet-glaptop>
Subject: Re: [PATCH v3 net-next 0/4] net: low latency Ethernet device polling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alex Rosenbaum <alexr@mellanox.com>
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 21 May 2013 06:31:39 -0700
In-Reply-To: <519B7355.9090303@mellanox.com>
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com>
	 <519B632F.7040202@mellanox.com> <519B68A4.3010406@linux.intel.com>
	 <519B7355.9090303@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-21 at 16:15 +0300, Alex Rosenbaum wrote:
> On 5/21/2013 3:29 PM, Eliezer Tamir wrote:
> > What benchmarks are you using to test poll/select/epoll?
> for epoll/select latency tests we are using sockperf as performance 
> latency tool: https://code.google.com/p/sockperf/
> It is a client-server based tool and it supported ping-pong, throughput, 
> and under-load test type.
> For epoll, you will need to define a 'feedfile' ("-f filepathname") 
> which has a list of TCP and/or UDP socket and defined your IO mux type 
> ("-F epoll").

I totally agree, most modern applications use poll/select/epoll,
and a fair amount of sockets per task, sendfile()/vmsplice()/... and
netperf is not using same paths.

Thanks Alex !



