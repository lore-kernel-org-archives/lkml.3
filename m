Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965874Ab3E2SwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:52:25 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:60359 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965789Ab3E2SwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:52:16 -0400
MIME-Version: 1.0
In-Reply-To: <51A617D7.6000406@linux.intel.com>
References: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com>
	<20130529063935.27486.18610.stgit@ladj378.jer.intel.com>
	<CAJZOPZJqF1FTLH3a3ZKUTA4ViesAZEkRi=dgd-ux8eRu9TyhBw@mail.gmail.com>
	<51A617D7.6000406@linux.intel.com>
Date: Wed, 29 May 2013 21:52:16 +0300
Message-ID: <CAJZOPZLC=drE9dTpnj2hLdDmfnL+T4gOU1j1xYwbmYy-J9HaAQ@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 2/5] net: implement support for low latency
 socket polling
From: Or Gerlitz <or.gerlitz@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Eric Dumazet <erdnetdev@gmail.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
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

Eliezer Tamir <eliezer.tamir@linux.intel.com> wrote:
> Or Gerlitz wrote:

>> Unlike with TCP sockets, UDP sockets may receive packets from multiple
>> sources and hence the receiving context may be steered to be executed
>> on different cores through RSS or other Flow-Steering HW mechanisms
>> which could mean different napi contexts for the same socket, is that
>> a problem here? what's the severity?

> Nothing will break if you poll on the wrong queue.
> Your data will come through normal NAPI processing of the right queue.

Can you elaborate a little further, why you call this "wrong" and "right"?
