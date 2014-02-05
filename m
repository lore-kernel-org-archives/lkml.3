Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaBEJXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:23:53 -0500
Received: from mx0.aculab.com ([213.249.233.131]:52164 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751182AbaBEJXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:23:50 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Dan Williams'" <dan.j.williams@intel.com>
CC: Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFCv2 00/10] xhci: re-work command queue management
Thread-Topic: [RFCv2 00/10] xhci: re-work command queue management
Thread-Index: AQHPHcSK9atdaSRCp0qab+MyU9T1kJqdUXswgAiotwCAAG6swA==
Date: Wed, 5 Feb 2014 09:22:57 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6B8B7E@AcuExch.aculab.com>
References: <1391091027-31783-1-git-send-email-mathias.nyman@linux.intel.com>
	<063D6719AE5E284EB5DD2968C1650D6D0F6B532A@AcuExch.aculab.com>
 <CAPcyv4gWnaK+s5zSu58Kue2ZiTTr4YC6pJG0n_Tu2Cm4RXOR=A@mail.gmail.com>
In-Reply-To: <CAPcyv4gWnaK+s5zSu58Kue2ZiTTr4YC6pJG0n_Tu2Cm4RXOR=A@mail.gmail.com>
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

From: Dan Williams 
> > Adding another list that will have its own set of bugs seems retrograde top me.
> 
> What bugs?  Please be specific.  The problem to be addressed is not
> the allocation of commands, but that timeouts of one command eat the
> timeout periods of subsequent commands.  I'm thinking a
> single-threaded workqueue better models what the hardware is doing.
> See my comments in patch 1, but that is orthogonal to how the command
> contexts are allocated.

No software is bug free.
The best way to get reasonably bug-free software is the KISS principle
(Keep It Simple Stupid).
You just seem to be adding a lot of additional complexity.
Maybe it would look better if more of the code was factored out of the
call sites.

IIRC at the moment every call site has to:
1) find the trb address that will be used (massive layer break).
2) actually write the trb (through several layers of function call).
3) sort out any timeout (I didn't really look into this bit).
4) ring the bell.

ISTM that the call site should just be a single function call.
If you do that the implementation of the timeouts/completions is
removed from the callers.

	David



