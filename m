Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaKNFOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 00:14:48 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:38083 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaKNFOq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 00:14:46 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAE5Eafl024412, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] r8152: adjust rtl_start_rx
Thread-Topic: [PATCH net-next 2/2] r8152: adjust rtl_start_rx
Thread-Index: AQHP+nD06ZRj/kse50uRMFsgi72OwJxU1qgAgARRxyCAAqOJAIAAqX9g//9+RwCAAIdqwP//gQiAgACRGECAAFtcgIAA7vwg//+SFQAAJWaoAAAgJNaA
Date: Fri, 14 Nov 2014 05:14:36 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2ED1624@RTITMBSV03.realtek.com.tw>
References: <20141112.144949.645590790916569141.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2ECE8EF@RTITMBSV03.realtek.com.tw>
	<20141112.223146.2221136950144767962.davem@davemloft.net>
 <20141113.162240.1823683928052355016.davem@davemloft.net>
In-Reply-To: <20141113.162240.1823683928052355016.davem@davemloft.net>
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
> Sent: Friday, November 14, 2014 5:23 AM
[...]
> What if even the first r8152_submit_rx() fails?  What ever will cause
> any of these retries to trigger at all?

According to the patch #1 "adjust r8152_submit_rx", the
r8152_submit_rx() would add the rx to the list and schedule
the tasklet, when the error occurs. Each time the tasklet is
called, the rx_bottom() would deal with all the rx in the
list. If the actual_length isn't vaild, the rx buffer would be
submitted directly. By this way, the retries would be done.
That is, the retries would be triggered when the tasklet
is called. Therefore, any tx, rx, and tasklet scheduling
would result in the retries.

> Second, why does your patch increment 'i' with 'i++;' in the error
> break path?  You should mark the first failed entry as unallocated
> with actual_length == 0 and place it on the rx_done queue.

Because the r8152_submit_rx() would add the failed rx to
the list, I only have to deal with the remaining ones. That
is why I increase the "i", otherwise the failed one would
be added twice.

I remember the usb_submit_urb() would set actual_length
to 0, so I skip the step. I would check it again.
 
Best Regards,
Hayes
