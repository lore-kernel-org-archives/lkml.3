Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3EXOYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:24:40 -0400
Received: from 18.mo4.mail-out.ovh.net ([188.165.54.143]:59516 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751880Ab3EXOYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:24:39 -0400
X-Greylist: delayed 93898 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 May 2013 10:24:39 EDT
Date: Fri, 24 May 2013 16:03:22 +0200
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
Message-ID: <20130524140322.GD24476@game.jcrosoft.org>
References: <1369011911-21282-1-git-send-email-wenyou.yang@atmel.com>
 <1369011979-21354-1-git-send-email-wenyou.yang@atmel.com>
 <20130522001457.GA18614@n2100.arm.linux.org.uk>
 <B256D81BAE5131468A838E5D7A243641687BB93C@penmbx01>
 <20130524112029.GW18614@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524112029.GW18614@n2100.arm.linux.org.uk>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 8368814009572502451
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:20 Fri 24 May     , Russell King - ARM Linux wrote:
> On Fri, May 24, 2013 at 07:11:04AM +0000, Yang, Wenyou wrote:
> > The story is: for sama5d3x with Cortex-A5 core, if not so, when copying
> > code snippet to the internal SRAM, then jump to run this code, but fail
> > to run.
> 
> And that is where your mistake is - you forgot that you're working with
> a CPU with harvard caches which will require some cache maintanence
> between copying the code and executing it.
> 
> You want to look at flush_icache_range() rather than making this memory
> strongly ordered.

I understand your point but today we map a SRAM as MT_DEVICE

I do not think it's the best

Best Regards,
J.
