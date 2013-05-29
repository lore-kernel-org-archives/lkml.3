Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965999Ab3E2TIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:08:51 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:47080 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab3E2TIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:08:42 -0400
Message-ID: <1369854520.5109.79.camel@edumazet-glaptop>
Subject: Re: [PATCH v6 net-next 2/5] net: implement support for low latency
 socket polling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 29 May 2013 12:08:40 -0700
In-Reply-To: <CAJZOPZLC=drE9dTpnj2hLdDmfnL+T4gOU1j1xYwbmYy-J9HaAQ@mail.gmail.com>
References: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com>
	 <20130529063935.27486.18610.stgit@ladj378.jer.intel.com>
	 <CAJZOPZJqF1FTLH3a3ZKUTA4ViesAZEkRi=dgd-ux8eRu9TyhBw@mail.gmail.com>
	 <51A617D7.6000406@linux.intel.com>
	 <CAJZOPZLC=drE9dTpnj2hLdDmfnL+T4gOU1j1xYwbmYy-J9HaAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 21:52 +0300, Or Gerlitz wrote:
> Eliezer Tamir <eliezer.tamir@linux.intel.com> wrote:
> > Or Gerlitz wrote:
> 
> >> Unlike with TCP sockets, UDP sockets may receive packets from multiple
> >> sources and hence the receiving context may be steered to be executed
> >> on different cores through RSS or other Flow-Steering HW mechanisms
> >> which could mean different napi contexts for the same socket, is that
> >> a problem here? what's the severity?
> 
> > Nothing will break if you poll on the wrong queue.
> > Your data will come through normal NAPI processing of the right queue.
> 
> Can you elaborate a little further, why you call this "wrong" and "right"?
> --

This definitely need some documentation, because before llpoll, device
RX path was serviced by the cpu receiving the harwdare interrupt.

So the "wrong" queue could add false sharing, and wrong NUMA
allocations.



