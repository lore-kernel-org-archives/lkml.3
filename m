Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaF0IUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:20:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:17857 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbaF0IUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:20:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,559,1400050800"; 
   d="scan'208";a="450662787"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: David Laight <David.Laight@ACULAB.COM>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
CC: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Sergei Shtylyov'" <sergei.shtylyov@cogentembedded.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v2] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Topic: [PATCH v2] USB: ehci-pci: USB host controller support for
 Intel Quark X1000
Thread-Index: Ac+Rt9/9zWiRva72R+WEYUnwzn5RXwABGaNAAAEzYAD//7WYgP//eAsw
Date: Fri, 27 Jun 2014 08:20:00 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E947646@SHSMSX101.ccr.corp.intel.com>
References: <1403868276-12558-1-git-send-email-alvin.chen@intel.com>
 <1403868276-12558-2-git-send-email-alvin.chen@intel.com>
 <000401cf91c0$e3a98600$aafc9200$%han@samsung.com>
 <000601cf91c1$5d25fcc0$1771f640$%han@samsung.com>
 <063D6719AE5E284EB5DD2968C1650D6D17267F31@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D17267F31@AcuExch.aculab.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Laight [mailto:David.Laight@ACULAB.COM]
> Sent: Friday, June 27, 2014 4:08 PM
> ...
> > /* The maximal threshold value is 0x80, which means 512 bytes */
> > #define EHCI_THRESHOLD_512BYTES		0x80
> > #define EHCI_THRESHOLD_508BYTES		0x79
> 
> It would be better to define these using expressions. So:
> #define EHCI_THRESHOLD_512BYTES		(512u / 8u)
> #define EHCI_THRESHOLD_508BYTES		(508u / 8u)
> 
Just to clarify, the threshold value set to register is in dword, so '0x80' means 0x80 dwords (512 bytes), and 508 bytes is not 0x79, it is 0x7F.

> Then you might decide to use:
> #define EHCI_THRESHOLD(size) ((size) / 8u)
> 
> Then realise that the names are not generic EHCI, so need some driver-specific
> prefix (for namespace reasons).
> 
How about the following?
#define INTEL_QUARK_X1000_EHCI_THRESHOLD(size) ((size) / 4u)  /* threshold value is in dword*/

> And that the defines are probably limit values, and should be named as such.
> 
> 	David
> 
> 

