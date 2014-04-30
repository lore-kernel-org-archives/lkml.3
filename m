Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833AbaD3N20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:28:26 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:44519 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaD3N2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:28:24 -0400
From: "Agarwal, Rohit (NSN - IN/Bangalore)" <rohit.agarwal@nsn.com>
To: "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
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
Subject: RE: Isse in Arp cache timeout
Thread-Topic: Isse in Arp cache timeout
Thread-Index: Ac9ka2bYXeM63P/hQyezvPqCp7kdIv//kXwA//94iYA=
Date: Wed, 30 Apr 2014 13:27:53 +0000
Message-ID: <869C2FE41C1E074D9858305AA6736A072F8A75B1@SGSIMBX008.nsn-intra.net>
References: <869C2FE41C1E074D9858305AA6736A072F8A745A@SGSIMBX008.nsn-intra.net>
 <5360F906.2080809@6wind.com>
In-Reply-To: <5360F906.2080809@6wind.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.159.225.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 2197
X-purgate-ID: 151667::1398864477-00001564-7ACCE134/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

I use below command and change this value for all interface.

for d in $(/bin/ls /proc/sys/net/ipv4/neigh); do
 echo 30000 > /proc/sys/net/ipv4/neigh/$d/base_reachable_time_ms
done


~Regards
Rohit Agarwal


-----Original Message-----
From: ext Nicolas Dichtel [mailto:nicolas.dichtel@6wind.com] 
Sent: Wednesday, April 30, 2014 6:52 PM
To: Agarwal, Rohit (NSN - IN/Bangalore); davem@davemloft.net; jiri@resnulli.us; hannes@stressinduktion.org; gaofeng@cn.fujitsu.com; vfalico@redhat.com; duanj.fnst@cn.fujitsu.com; noureddine@aristanetworks.com; ebiederm@xmission.com; tim.gardner@canonical.com; stephen@networkplumber.org
Cc: linux-kernel@vger.kernel.org; Wiebe, Wladislav (NSN - DE/Ulm)
Subject: Re: Isse in Arp cache timeout

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
