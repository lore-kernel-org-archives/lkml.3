Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaJTCTy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 22:19:54 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:42155 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaJTCTm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 22:19:42 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s9K2JSf9018604, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: Oliver Neukum <oliver@neukum.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net] r8152: use cancel_delayed_work for runtime suspend
Thread-Topic: [PATCH net] r8152: use cancel_delayed_work for runtime suspend
Thread-Index: AQHP6c77tTFsgey470u4vPnp16ri7Zw1vzSAgAKEQyA=
Date: Mon, 20 Oct 2014 02:19:27 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2EC81CA@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-64-Taiwan-albertk@realtek.com>
 <1413661699.19391.2.camel@linux-0dmf.site>
In-Reply-To: <1413661699.19391.2.camel@linux-0dmf.site>
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

 Oliver Neukum [mailto:oliver@neukum.org] 
> Sent: Sunday, October 19, 2014 3:48 AM
[...]
> The diagnosis is good, the fix is not good. It opens a race
> during which the queued work can touch a suspended device.

The delayed work would wake up the device by
calling usb_autopm_get_interface() before
accessing the device. Besides, there is a mutex
to avoid the race.
 
Best Regards,
Hayes
