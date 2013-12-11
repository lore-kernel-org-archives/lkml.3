Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab3LKDXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:23:20 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54003 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3LKDXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:23:15 -0500
Date: Tue, 10 Dec 2013 22:23:13 -0500 (EST)
Message-Id: <20131210.222313.694303616856894486.davem@davemloft.net>
To: mchan@broadcom.com
Cc: sergei.shtylyov@cogentembedded.com, natg@google.com, nsujir@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net-tg3: Initialize REG_BASE_ADDR at PCI config offset
 120 to 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386701379.1752.26.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
References: <1386658724.1752.19.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	<20131210.134340.114603867817512238.davem@davemloft.net>
	<1386701379.1752.26.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 10 Dec 2013 19:23:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Chan <mchan@broadcom.com>
Date: Tue, 10 Dec 2013 10:49:39 -0800

> On Tue, 2013-12-10 at 13:43 -0500, David Miller wrote:
> 
>> What if the kernel is booted via kexec, and the driver in the kernel
>> we are kexec'ing from left indirect access enabled in MISC_HOST_CTRL?
> 
> That should be ok.  The driver will only use valid register offsets in
> indirect mode during run time, so register 0x78 should point to a valid
> register.  If indirect mode is never used by the driver, it will point
> to zero with this patch.  So register 0x78 will be valid (or zero) in
> the kexec'ed kernel.

Ok, that may be true, but I'd like to consider the much larger issue
at hand.

If the indirect mechanism is enabled, some of the offsets that may be
in there might be value, but would be entirely undesirable to be read
because the read has side effects.

What if the interrupt status register is what gets read if the user
scans config space at just the wrong moment, and therefore an
interrupt gets lost?

I understand that the patch we are discussing is a serious improvement
from the current situation, so I will apply it and queue it up for
-stable.

However I think we need to do something reasonable to prevent the
kinds of situations I described above.

Thanks.
