Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaKJFXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:23:34 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:34138 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaKJFXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:23:32 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAA5NFKd027500, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: Francois Romieu <romieu@fr.zoreil.com>
CC: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next v2 2/3] r8152: cleartheflagofSCHEDULE_TASKLETintasklet
Thread-Topic: [PATCH net-next v2 2/3] r8152: clear
 theflagofSCHEDULE_TASKLETintasklet
Thread-Index: AQHP+6EFOMyRg2s7CE68j9wQDM6ZR5xZTGAg
Date: Mon, 10 Nov 2014 05:23:14 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2ECE0DF@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-75-Taiwan-albertk@realtek.com>
 <1394712342-15778-79-Taiwan-albertk@realtek.com>
 <1394712342-15778-81-Taiwan-albertk@realtek.com>
 <20141031.161520.3547230591227504.davem@davemloft.net>
 <0835B3720019904CB8F7AA43166CEEB2ECD8A7@RTITMBSV03.realtek.com.tw>
 <20141102225307.GA19900@electric-eye.fr.zoreil.com>
 <0835B3720019904CB8F7AA43166CEEB2ECDFC2@RTITMBSV03.realtek.com.tw>
 <20141108221149.GA26030@electric-eye.fr.zoreil.com>
In-Reply-To: <20141108221149.GA26030@electric-eye.fr.zoreil.com>
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

 Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Sunday, November 09, 2014 6:12 AM
[...]
> The performance explanation leaves me a bit unconvinced. Without any
> figure one could simply go for the always locked clear_bit because of:
> 1. the "I'm racy" message that the open-coded test + set sends
> 2. the extra work needed to avoid 1 (comment, explain, ...).

Thanks. I would modify this patch with clear_bit only.

> The extra time could thus be used to see what happens when napi is
> shoehorned in this tasklet machinery. I'd naively expect it to be
> relevant for efficiency.

I thought about NAPI, but I gave up. The reasons are
1. I don't sure if it would run when autosuspending.
2. There is no hw interrupt for USB device. And I have
   no idea about how to check if the USB transfer is
   completed by polling.
3. I have to control the rx packets numbers in poll().
   However, I couldn't control the packets number for
   each bulk-in transfer. I have to do extra works to
   deal with the rx flow.
4. I don't find much different between tasklet and NAPI.

Best Regards,
Hayes
