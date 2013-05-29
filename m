Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617Ab3E2OOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:14:34 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:50617 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935150Ab3E2OOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:14:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130529063935.27486.18610.stgit@ladj378.jer.intel.com>
References: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com>
	<20130529063935.27486.18610.stgit@ladj378.jer.intel.com>
Date: Wed, 29 May 2013 17:14:31 +0300
Message-ID: <CAJZOPZJqF1FTLH3a3ZKUTA4ViesAZEkRi=dgd-ux8eRu9TyhBw@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 2/5] net: implement support for low latency
 socket polling
From: Or Gerlitz <or.gerlitz@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Eric Dumazet <erdnetdev@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 9:39 AM, Eliezer Tamir
<eliezer.tamir@linux.intel.com> wrote:
> Adds a new ndo_ll_poll method and the code that supports and uses it.
> This method can be used by low latency applications to busy poll Ethernet
> device queues directly from the socket code. The value of sysctl_net_ll_poll
> controls how many microseconds to poll. Set to zero to disable.

Unlike with TCP sockets, UDP sockets may receive packets from multiple
sources and hence the receiving context may be steered to be executed
on different cores through RSS or other Flow-Steering HW mechanisms
which could mean different napi contexts for the same socket, is that
a problem here? what's the severity?

Or.
