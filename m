Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761AbaD3NWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:22:21 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50774 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371AbaD3NWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:22:19 -0400
Message-ID: <5360F906.2080809@6wind.com>
Date: Wed, 30 Apr 2014 15:22:14 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Agarwal, Rohit (NSN - IN/Bangalore)" <rohit.agarwal@nsn.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "hannes@stressinduktion.org" <hannes@stressinduktion.org>,
        "gaofeng@cn.fujitsu.com" <gaofeng@cn.fujitsu.com>,
        "vfalico@redhat.com" <vfalico@redhat.com>,
        "duanj.fnst@cn.fujitsu.com" <duanj.fnst@cn.fujitsu.com>,
        "noureddine@aristanetworks.com" <noureddine@aristanetworks.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wiebe, Wladislav (NSN - DE/Ulm)" <wladislav.wiebe@nsn.com>
Subject: Re: Isse in Arp cache timeout
References: <869C2FE41C1E074D9858305AA6736A072F8A745A@SGSIMBX008.nsn-intra.net>
In-Reply-To: <869C2FE41C1E074D9858305AA6736A072F8A745A@SGSIMBX008.nsn-intra.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 30/04/2014 13:57, Agarwal, Rohit (NSN - IN/Bangalore) a écrit :
> Hi,
>
> We are facing problem with Arp cache timeout.
>
> System being used is as below -
> Board (having Octeon processor) is running Linux(3.10.34) with one of the Ethernet interface connected to NIC card which is then connected to a Windows PC.
> Default value for base_reachable_time_ms is set to 30000 on board. Traffic(ping) is send from PC to Board.
> "ip neigh" shows the arp being resolved & entry status as reachable. After some time (20-40 sec), the status changes to stale.
>
> Now we change the value of base_reachable_time_ms to 100000. But resulting timeout does not change. The stale status is reached within same 20-40 sec.
> This behavior remains forever. Even if we assign different values to base_reachable_time_ms, still no change in time out.
Did you change only the default value
(/proc/sys/net/ipv[4|6]/neigh/default/base_reachable_time_ms) or the value of
the interface (/proc/sys/net/ipv[4|6]/neigh/mynetdev/base_reachable_time_ms)?

>
> Only when system is restarted the new value is effective.
In you change the default value, only interfaces that didn't have an IPv4 (or
an IPv6) address will "get" this new value, but all interfaces that already
have an IPv4 (or IPv6) address will keep the previous value, ie the one set in
their own entries.


Regards,
Nicolas
