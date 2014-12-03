Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaLCHFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:05:20 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:54013 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaLCHFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:05:18 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sB375ASB021284, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next] r8152: reduce memory copy for rx
Thread-Topic: [PATCH net-next] r8152: reduce memory copy for rx
Thread-Index: AQHQDrgS8Vmh5UfiJ0iekivC5Eu1N5x821QAgACRkiA=
Date: Wed, 3 Dec 2014 07:05:10 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2ED360A@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-105-Taiwan-albertk@realtek.com>
 <1417586858.5303.118.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1417586858.5303.118.camel@edumazet-glaptop2.roam.corp.google.com>
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
> Sent: Wednesday, December 03, 2014 2:08 PM
[...]
> Better performance for what workload exactly ?

I test it by using Chariot with 4 Tx and 4 Rx.
It has about 4% improvement.

> cloning in rx path has many drawbacks, with skb->truesize 
> being usually wrong.

Excuse me. I find the skb_clone() would copy the
truesize from original skb. Do you mean the value
may not be suitable for the cloned skb?

Could other method do the same thing? Or, do you
think keeping the original one is better?
 
Best Regards,
Hayes
