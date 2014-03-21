Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967017AbaCUAyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:54:37 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.113]:6249 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965308AbaCUAye convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:54:34 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2014 20:54:34 EDT
X-Env-Sender: Seth.Bollinger@digi.com
X-Msg-Ref: server-12.tower-200.messagelabs.com!1395362896!12566099!1
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
From: "Bollinger, Seth" <Seth.Bollinger@digi.com>
To: Peter Hurley <peter@hurleysoftware.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>
Subject: Re: Possible software flow problem in serial_core
Thread-Topic: Possible software flow problem in serial_core
Thread-Index: AQHPREKU9KCJrmW7V0KAljYo9hJjt5rq7RmA//+0KoCAAGS3AP//r/qA
Date: Fri, 21 Mar 2014 00:48:14 +0000
Message-ID: <CF50F620.6EC5%seth.bollinger@digi.com>
References: <CF505B08.6E64%seth.bollinger@digi.com>
 <532B743F.2030705@hurleysoftware.com>
 <CF50E0EB.6E95%seth.bollinger@digi.com> <532B891E.80705@hurleysoftware.com>
In-Reply-To: <532B891E.80705@hurleysoftware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
x-originating-ip: [172.26.1.22]
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: Clean
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0040CEEBC5F68448B2A7BF85A466E136@digi.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Yeah, you're right; thanks for catching this.
>(I was busy looking at the ll driver and completely missed the bug in
>the serial core).
>
>uart_start() should not be conditioning the call to start_tx() on
>the ring buffer being empty; ll drivers should already be able to handle
>that because CTS flow control change will start_tx regardless of the ring
>buffer count.
>
>Will you send a patch?

Sure thing.  Just to be clear, you want to remove the ring buffer tests
and leave the tty tests, right?

This will have to wait for the morning though.  :)

Seth

