Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab3FEORd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:17:33 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:64865 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3FEORc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:17:32 -0400
Message-ID: <1370441849.24311.256.camel@edumazet-glaptop>
Subject: Re: [PATCH v9 net-next 5/7] net: simple poll/select low latency
 socket poll
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 05 Jun 2013 07:17:29 -0700
In-Reply-To: <1370440607.24311.251.camel@edumazet-glaptop>
References: <20130605103400.11172.49099.stgit@ladj378.jer.intel.com>
	 <20130605103452.11172.31453.stgit@ladj378.jer.intel.com>
	 <1370439054.24311.248.camel@edumazet-glaptop>
	 <51AF401C.2030506@linux.intel.com>
	 <1370440607.24311.251.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 06:56 -0700, Eric Dumazet wrote:

> This looks quite easy, by adding in include/uapi/asm-generic/poll.h
> 
> #define POLL_LL 0x8000
> 
> And do the sk_poll_ll() call only if flag is set.
> 
> I do not think we have to support select(), as its legacy interface, and
> people wanting ll should really use epoll() or poll().

Alternatively, add a per socket flag to enable/disable ll

This global enable assumes the application owns the host anyway.



