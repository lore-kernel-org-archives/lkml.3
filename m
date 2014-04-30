Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbaD3L7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 07:59:30 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:46080 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213AbaD3L73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 07:59:29 -0400
From: "Agarwal, Rohit (NSN - IN/Bangalore)" <rohit.agarwal@nsn.com>
To: "davem@davemloft.net" <davem@davemloft.net>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "hannes@stressinduktion.org" <hannes@stressinduktion.org>,
        "gaofeng@cn.fujitsu.com" <gaofeng@cn.fujitsu.com>,
        "vfalico@redhat.com" <vfalico@redhat.com>,
        "duanj.fnst@cn.fujitsu.com" <duanj.fnst@cn.fujitsu.com>,
        "noureddine@aristanetworks.com" <noureddine@aristanetworks.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "hannes@stressinduktion.org" <hannes@stressinduktion.org>,
        "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wiebe, Wladislav (NSN - DE/Ulm)" <wladislav.wiebe@nsn.com>
Subject: Isse in Arp cache timeout
Thread-Topic: Isse in Arp cache timeout
Thread-Index: Ac9ka2bYXeM63P/hQyezvPqCp7kdIg==
Date: Wed, 30 Apr 2014 11:57:48 +0000
Message-ID: <869C2FE41C1E074D9858305AA6736A072F8A745A@SGSIMBX008.nsn-intra.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.159.225.116]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 986
X-purgate-ID: 151667::1398859143-00001564-B75F297D/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We are facing problem with Arp cache timeout. 

System being used is as below -
Board (having Octeon processor) is running Linux(3.10.34) with one of the Ethernet interface connected to NIC card which is then connected to a Windows PC. 
Default value for base_reachable_time_ms is set to 30000 on board. Traffic(ping) is send from PC to Board. 
"ip neigh" shows the arp being resolved & entry status as reachable. After some time (20-40 sec), the status changes to stale.

Now we change the value of base_reachable_time_ms to 100000. But resulting timeout does not change. The stale status is reached within same 20-40 sec.
This behavior remains forever. Even if we assign different values to base_reachable_time_ms, still no change in time out.

Only when system is restarted the new value is effective.

Can you please let us know if you have some idea about this issue and what may be the probable cause.


~Regards
Rohit Agarwal

