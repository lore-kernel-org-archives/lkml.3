Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaAZAYx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 19:24:53 -0500
Received: from top.free-electrons.com ([176.31.233.9]:46426 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750870AbaAZAYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 19:24:52 -0500
Date: Sat, 25 Jan 2014 21:25:01 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Emilio =?utf-8?B?TMOzcGV6?= <emilio@elopez.com.ar>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
Message-ID: <20140126002500.GA13741@localhost>
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <52E42D6A.5050508@elopez.com.ar>
 <52E43046.1030105@gmail.com>
 <52E4367B.3090608@elopez.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52E4367B.3090608@elopez.com.ar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emilio,

Thanks for your help with this.

On Sat, Jan 25, 2014 at 07:11:07PM -0300, Emilio López wrote:
[..]
> >
> > Ok, I'll look if using of_clk_get_parent_name will help here. But again,
> > I can see that clk-gating driver gets registered before core-clk driver.
> > There may be no code to give you the parent name at that time.
> 
> After looking at some of the armada*.dtsi, I see you don't list the 
> clock names on the coreclk node, so of_clk_get_parent_name may not be of 
> much value after all.
> 

IIRC, we faced a similar issue with the Core Divider clock and solved it by
specifying the clock names in the DT.

I meant to complete the core and gating clocks in a similar way
(providing names on the DT), but apparently (as discussed with Gregory Clement)
Mike Turquette and others are planning to remove the clock names from
the DT entirely.

Can you guys explain about this plan a bit further? Or do you think we
should specify the names on the DT for all the clocks instead?

Notice that the latter would remove lots of strings from the kernel
itself (right?)
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
