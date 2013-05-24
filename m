Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3EXLXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:23:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56780 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3EXLXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:23:30 -0400
Date: Fri, 24 May 2013 12:20:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux@maxim.org.za" <linux@maxim.org.za>
Subject: Re: [PATCH] ARM: at91: Fix: Change internal SRAM memory type to
	"MT_MEMORY_SO"
Message-ID: <20130524112029.GW18614@n2100.arm.linux.org.uk>
References: <1369011911-21282-1-git-send-email-wenyou.yang@atmel.com> <1369011979-21354-1-git-send-email-wenyou.yang@atmel.com> <20130522001457.GA18614@n2100.arm.linux.org.uk> <B256D81BAE5131468A838E5D7A243641687BB93C@penmbx01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B256D81BAE5131468A838E5D7A243641687BB93C@penmbx01>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 07:11:04AM +0000, Yang, Wenyou wrote:
> The story is: for sama5d3x with Cortex-A5 core, if not so, when copying
> code snippet to the internal SRAM, then jump to run this code, but fail
> to run.

And that is where your mistake is - you forgot that you're working with
a CPU with harvard caches which will require some cache maintanence
between copying the code and executing it.

You want to look at flush_icache_range() rather than making this memory
strongly ordered.
