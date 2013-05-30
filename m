Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967570Ab3E3GF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 02:05:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:34533 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967545Ab3E3GEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 02:04:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,768,1363158000"; 
   d="scan'208";a="321752242"
Message-ID: <51A6EBE2.6050108@linux.intel.com>
Date: Thu, 30 May 2013 09:04:18 +0300
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
References: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com> <20130529063935.27486.18610.stgit@ladj378.jer.intel.com> <CAJZOPZJqF1FTLH3a3ZKUTA4ViesAZEkRi=dgd-ux8eRu9TyhBw@mail.gmail.com> <51A617D7.6000406@linux.intel.com> <CAJZOPZLC=drE9dTpnj2hLdDmfnL+T4gOU1j1xYwbmYy-J9HaAQ@mail.gmail.com>
In-Reply-To: <CAJZOPZLC=drE9dTpnj2hLdDmfnL+T4gOU1j1xYwbmYy-J9HaAQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/2013 21:52, Or Gerlitz wrote:
> Eliezer Tamir <eliezer.tamir@linux.intel.com> wrote:
>> Or Gerlitz wrote:
>
>>> Unlike with TCP sockets, UDP sockets may receive packets from multiple
>>> sources and hence the receiving context may be steered to be executed
>>> on different cores through RSS or other Flow-Steering HW mechanisms
>>> which could mean different napi contexts for the same socket, is that
>>> a problem here? what's the severity?
>
>> Nothing will break if you poll on the wrong queue.
>> Your data will come through normal NAPI processing of the right queue.
>
> Can you elaborate a little further, why you call this "wrong" and "right"?

Right == the queue the packets arrive on.
Wrong == any other queue.

BTW, if you have an application that receives UDP data to an unbound 
socket, wouldn't it be better in any case to steer all of the incoming 
packets for this UDP socket to a single queue disregarding the source 
address? (Can't your hardware do that?)

The general approach is that userspace needs to make sure that threads, 
connections and IRQs are bound to the right CPUs.

-Eliezer

