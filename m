Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab3GVKvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:51:43 -0400
Received: from [65.55.88.12] ([65.55.88.12]:45279 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753078Ab3GVKvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:51:42 -0400
X-Forefront-Antispam-Report: CIP:157.56.250.85;KIP:(null);UIP:(null);IPV:NLI;H:AMXPRD0511HT003.eurprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah1de097h1de096h8275bh8275dhz2fh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19ceh1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1155h)
Message-ID: <51ED0E61.30106@youview.com>
Date: Mon, 22 Jul 2013 11:50:09 +0100
From: William Manley <william.manley@youview.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <davem@davemloft.net>
Subject: IGMP Unsolicited Report Interval too long for IGMPv3?
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [31.221.37.8]
X-OriginatorOrg: youview.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an IGMP join packet is lost you will not receive data sent to the 
multicast group so if no data arrives from that multicast group in a 
period of time after the IGMP join a second IGMP join will be sent.  The 
delay between joins is the "IGMP Unsolicited Report Interval".

In the kernel this seems to be hard coded to be chosen randomly between 
0-10s.  In our use-case (IPTV) this is too long as it can cause channel 
change to be slow in the presence of packet loss.

I would guess that this 10s has come from IGMPv2 RFC2236, which was 
reduced to 1s in IGMPv3 RFC3376.

There was a thread about this on linux-rdma in 2010 in the context of IP 
over Infiniband but it seems no patches got applied as a result of the 
discussion:

http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg05740.html

Would the right patch reducing the unsolicited report interval for 
IGMPv3 be acceptable now?

Thanks

Will


