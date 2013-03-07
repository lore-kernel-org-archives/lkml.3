Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3CGLyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:54:38 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:19016
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843Ab3CGLyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:54:37 -0500
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 5
X-BigFish: VPS5(z1346pz98dI936eI1432I1453Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ahbe9i1155h)
Subject: Re: virtual irq isssue - regmap_irq
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, David Dajun Chen <dchen@diasemi.com>
In-Reply-To: <20130307071349.GF22554@opensource.wolfsonmicro.com>
References: <1362639472.484.22.camel@dhruva>
	 <20130307071349.GF22554@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 7 Mar 2013 17:22:35 +0530
Message-ID: <1362657155.1796.4.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 15:13 +0800, Mark Brown wrote:
> On Thu, Mar 07, 2013 at 12:27:52PM +0530, Ashish Jangam wrote:
> 
> > In regmap_irq if irq_base is unknown then regmap creates virq starting from 0
> > and it seems that in kernel 3.8 virq 0 usage is not permitted, since during irq
> > registration kernel throws a message "error: irq_desc already associated".
> 
> > I'm not sure if this requires fix in regmap_irq or kernel, can you please
> > comment on this?
> 
> This is a bug in your platform which will affect anything using a linear
> domain.  The platform isn't setting up its interrupts correctly so that
> the core knows that those interrupts are reserved, ideally the platform
> would just use domains for everything but at least irq_alloc_decs()
> needs to know what is going on.
Thanks I got this, however in this case should regmap handle such
condition where domain is unknown?
By the way, I was testing on smdkv6410 where Dialog device is not a
component of the board.


