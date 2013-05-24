Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3EXQlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 12:41:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57016 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab3EXQll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 12:41:41 -0400
Date: Fri, 24 May 2013 17:40:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: "Yang, Wenyou" <Wenyou.Yang@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux@maxim.org.za" <linux@maxim.org.za>
Subject: Re: [PATCH] ARM: at91: Fix: Change internal SRAM memory type to
	"MT_MEMORY_SO"
Message-ID: <20130524164055.GA18614@n2100.arm.linux.org.uk>
References: <1369011911-21282-1-git-send-email-wenyou.yang@atmel.com> <1369011979-21354-1-git-send-email-wenyou.yang@atmel.com> <20130522001457.GA18614@n2100.arm.linux.org.uk> <B256D81BAE5131468A838E5D7A243641687BB93C@penmbx01> <20130524112029.GW18614@n2100.arm.linux.org.uk> <20130524140322.GD24476@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524140322.GD24476@game.jcrosoft.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 04:03:22PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 12:20 Fri 24 May     , Russell King - ARM Linux wrote:
> > On Fri, May 24, 2013 at 07:11:04AM +0000, Yang, Wenyou wrote:
> > > The story is: for sama5d3x with Cortex-A5 core, if not so, when copying
> > > code snippet to the internal SRAM, then jump to run this code, but fail
> > > to run.
> > 
> > And that is where your mistake is - you forgot that you're working with
> > a CPU with harvard caches which will require some cache maintanence
> > between copying the code and executing it.
> > 
> > You want to look at flush_icache_range() rather than making this memory
> > strongly ordered.
> 
> I understand your point but today we map a SRAM as MT_DEVICE

If you map SRAM as MT_DEVICE then you won't be able to execute code from
it.  It needs to be a normal memory mapping.
