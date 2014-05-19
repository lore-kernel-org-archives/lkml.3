Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbaESJIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:08:48 -0400
Received: from mx0.aculab.com ([213.249.233.131]:59801 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750890AbaESJIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:08:47 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Parag Warudkar'" <parag.lkml@gmail.com>,
        "mathias.nyman@intel.com" <mathias.nyman@intel.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: xhci dmesg flood on short packet
Thread-Topic: xhci dmesg flood on short packet
Thread-Index: AQHPcghkpacnn2WCnEmlfcLSvWtLpZtHni4w
Date: Mon, 19 May 2014 09:08:19 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17248D54@AcuExch.aculab.com>
References: <alpine.DEB.2.10.1405171530140.17496@parag-Z230>
In-Reply-To: <alpine.DEB.2.10.1405171530140.17496@parag-Z230>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Of Parag Warudkar
> I see a continuous flood of below messages on plugging in/using my USB
> token. (The comp code wasn't in the original message - I added it.) From
> what I can tell the device continues to work as expected.
> 
> Should the warning be disabled for COMP_SHORT_TX like it is for COMP_STOP
> and COMP_STOP_INVAL?
> 
> Parag
> 
> [104692.771649] xhci_hcd 0000:00:14.0: WARN Event TRB comp code 13 for
> slot 2 ep 10 with no TDs queued?

A completion event with nothing queued looks like something horrid.
I'd do some further analysis to find which TRB have been queued and
the completion (or other) events that removed them.

IIRC the COMP_SHORT_TX completion usually means that the received USB packet
is shorter than the buffer (it is really a short RX!).
This is completely normal for many devices.
There is a slight fubar with some host controllers that fail to report
it exactly as per the standard - but that gives a different message.

	David

> [104692.777279] xhci_hcd 0000:00:14.0: WARN Event TRB comp code 13 for
> slot 2 ep 10 with no TDs queued?
> [104692.793894] xhci_hcd 0000:00:14.0: WARN Event TRB comp code 13 for
> slot 2 ep 10 with no TDs queued?
> [104692.813033] xhci_hcd 0000:00:14.0: WARN Event TRB comp code 13 for
> slot 2 ep 10 with no TDs queued?
> [104692.823476] xhci_hcd 0000:00:14.0: WARN Event TRB comp code 13 for
> slot 2 ep 10 with no TDs queued?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


