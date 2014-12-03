Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaLCJJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:09:24 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:37968 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaLCJJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:09:20 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sB399EWa016192, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next] r8152: reduce memory copy for rx
Thread-Topic: [PATCH net-next] r8152: reduce memory copy for rx
Thread-Index: AQHQDrgS8Vmh5UfiJ0iekivC5Eu1N5x821QAgACRkiD//4FegIAAoPyA
Date: Wed, 3 Dec 2014 09:09:12 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2ED364C@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-105-Taiwan-albertk@realtek.com>
	 <1417586858.5303.118.camel@edumazet-glaptop2.roam.corp.google.com>
	 <0835B3720019904CB8F7AA43166CEEB2ED360A@RTITMBSV03.realtek.com.tw>
 <1417590925.5303.127.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1417590925.5303.127.camel@edumazet-glaptop2.roam.corp.google.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.71.143]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet [mailto:eric.dumazet@gmail.com] 
> Sent: Wednesday, December 03, 2014 3:15 PM
[...]
> Have you tried using more concurrent RX flows, in a possibly lossy
> environment (so that TCP is forced to queue packets in out of order
> queue) ?

I don't do the test. I would check it next time.

> skb cloning prevents GRO and TCP coalescing from working.
> 
> netfilter might also be forced to copy whole frame in case a mangle is
> needed (eg with NAT ...)
> 
> I would rather try to implement GRO, and/or using fragments instead of
> pure linear skbs.
> 
> (skb->head would be around 128 or 256 bytes, and you attach to skb the
> frame as a page fragment)

Thanks for your response. I would study the GRO first.
 
Best Regards,
Hayes
