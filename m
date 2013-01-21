Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab3AUIhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:37:39 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:4659 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab3AUIhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:37:38 -0500
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898hbe9i1155h)
Subject: Re: [patch v1 2/5] regulator: da9055 change irq state to default
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, David Dajun Chen <dchen@diasemi.com>
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED4313C7F1@KCHJEXMB03.kpit.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED4313C7F1@KCHJEXMB03.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jan 2013 14:05:12 +0530
Message-ID: <1358757312.11746.11.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> > > > This patch changes the irq state from high to the now default low
> > > > state.
> 
> > > > This patch is dependent on the DA9055 MFD.
> 
> > > Why is this change required and why is there a dependency here?
> 
> > It has been decided to have nIRQ therefore the main mfd IRQ state needs
> 
> Won't this break all existing systems?
Since all of the existing users are using nIRQ therefore it was decided
to have the default state as nIRQ.
> 
> > to be changed. And since mfd children follows mfd irq state therefore
> > the dependency; though in case of mfd this may not affect.  
> 
> What makes you say that there is a dependency here?  It's really not at
> all obvious why a change to the primary IRQ signalling mechanism would
> affect the internal interrupts of the device.
Yes, functionally this dependency should not matter.However, if
mfd/primary irq state is low and its components are high then it shall
not look good. Therefore the term dependency was used, probably I should
have written it in a different manner.


