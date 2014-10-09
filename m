Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaJIIAD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:00:03 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:43238 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaJIH7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:59:42 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s997xZc9007731, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next] r8152: use mutex for hw settings
Thread-Topic: [PATCH net-next] r8152: use mutex for hw settings
Thread-Index: AQHP4fCyj4IT/KDtfkmwGKakNlDPqZwmFsKAgAFPMJA=
Date: Thu, 9 Oct 2014 07:59:35 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2EC397B@RTITMBSTEMP01.realtek.com.tw>
References: <1394712342-15778-58-Taiwan-albertk@realtek.com>
 <20141008.154513.1944594723904521723.davem@davemloft.net>
In-Reply-To: <20141008.154513.1944594723904521723.davem@davemloft.net>
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

 David Miller [mailto:davem@davemloft.net] 
> Sent: Thursday, October 09, 2014 3:45 AM
[..]
> I think a much simpler fix is to take rtnl_lock() in the workqueue
> function and suspend/resume ops.
> 
> Every other place you are adding the mutex already holds the RTNL
> mutex.

If I use the rtnl_lock(), I get a dead lock when enabling autosuspend.

Case 1:
   autosuspend before calling open.
   rtnl_lock()
   call open
   try to autoresume and rtl8152_resume is called.
   dead lock occurs.

Case 2:
   autosuspend occurs.
   rtnl_lock()
   call close
   try to autoresume and rtl8152_resume is called.
   dead lock occurs.
 
Best Regards,
Hayes
