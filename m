Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474Ab3CVOrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:47:01 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:51498
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724Ab3CVOq7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:46:59 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Mar 2013 10:46:58 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275ch8275bhz2dh2a8h668h839h8e2h8e3h944hd25he5bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Fleming Andy-AFLEMING <afleming@freescale.com>
To: David Miller <davem@davemloft.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: Add support for handling queueing in hardware
Thread-Topic: [PATCH] net: Add support for handling queueing in hardware
Thread-Index: AQHOJwcxFqVu0swusE6Dh4kEFiLneJixxe2/
Date: Fri, 22 Mar 2013 14:31:50 +0000
Message-ID: <A5ACC15C-361D-48E6-BFFF-9AA3966C2A68@freescale.com>
References: <E1UJ1fR-0004hs-4l@swissweb.swissdisk.com>,<20130322.101139.1942128058226201237.davem@davemloft.net>
In-Reply-To: <20130322.101139.1942128058226201237.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mar 22, 2013, at 9:11, "David Miller" <davem@davemloft.net> wrote:

> From: Andy Fleming <afleming@freescale.com>
> Date: Wed, 13 Jul 2011 08:52:04 -0500
> 
>> The QDisc code does a bunch of locking which is unnecessary if
>> you have hardware which handles all of the queueing. Add
>> support for this, and skip over all of the queueing code if
>> the feature is enabled on a given device, which breaks QDisc
>> support on dpaa_eth, and also coopts the FCOE feature bit.
>> 
>> Signed-off-by: Andy Fleming <afleming@freescale.com>
>> Signed-off-by: Ben Collins <ben.c@servergy.com>
> 
> Sorry, no.
> 
> If we are going to support something like this then there needs to
> be full coordination, configuration wise, so that if we enable
> a qdisc that the hardware supports we submit it directly, but if
> we enable a qdisc the HW does not support, we still use the software
> qdisc.
> 
> This also means that we need to have a way to determine if the qdisc
> configuration exceeds that parametorial limits of the device's HW
> capabilities, and fallback to software qdisc in those cases too.


It would appear one of our customers is attempting to upstream our code for us. We are aware that this current solution is unacceptable (which is why we have not submitted it), and we are currently trying to develop a less hacky solution that integrates with qdisc.

Andy

