Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab3EXREk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 13:04:40 -0400
Received: from 11.mo4.mail-out.ovh.net ([46.105.34.195]:34918 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753132Ab3EXREi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 13:04:38 -0400
X-Greylist: delayed 102298 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 May 2013 13:04:38 EDT
Date: Fri, 24 May 2013 18:52:54 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Yang, Wenyou" <Wenyou.Yang@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux@maxim.org.za" <linux@maxim.org.za>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH] ARM: at91: Fix: Change internal SRAM memory type to
 "MT_MEMORY_SO"
Message-ID: <20130524165254.GF24476@game.jcrosoft.org>
References: <1369011911-21282-1-git-send-email-wenyou.yang@atmel.com>
 <1369011979-21354-1-git-send-email-wenyou.yang@atmel.com>
 <20130522001457.GA18614@n2100.arm.linux.org.uk>
 <B256D81BAE5131468A838E5D7A243641687BB93C@penmbx01>
 <20130524112029.GW18614@n2100.arm.linux.org.uk>
 <20130524140322.GD24476@game.jcrosoft.org>
 <20130524164055.GA18614@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524164055.GA18614@n2100.arm.linux.org.uk>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 11232258947684412339
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:40 Fri 24 May     , Russell King - ARM Linux wrote:
> On Fri, May 24, 2013 at 04:03:22PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > On 12:20 Fri 24 May     , Russell King - ARM Linux wrote:
> > > On Fri, May 24, 2013 at 07:11:04AM +0000, Yang, Wenyou wrote:
> > > > The story is: for sama5d3x with Cortex-A5 core, if not so, when copying
> > > > code snippet to the internal SRAM, then jump to run this code, but fail
> > > > to run.
> > > 
> > > And that is where your mistake is - you forgot that you're working with
> > > a CPU with harvard caches which will require some cache maintanence
> > > between copying the code and executing it.
> > > 
> > > You want to look at flush_icache_range() rather than making this memory
> > > strongly ordered.
> > 
> > I understand your point but today we map a SRAM as MT_DEVICE
> 
> If you map SRAM as MT_DEVICE then you won't be able to execute code from
> it.  It needs to be a normal memory mapping.

Yeah that a bug on AT91, by luck it work on armv3/v4 with MT_DEVICE, I should
have spot it earlier when cleanning the at91 but did not

That's why Yang change the SRAM mapping as MT_MEMORY_SO

I agree the commit message need to be re-done

Best Regards,
J.
