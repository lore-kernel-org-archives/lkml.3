Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbbAMXpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 18:45:12 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:49143 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbbAMXpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 18:45:10 -0500
Date: Tue, 13 Jan 2015 23:45:09 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Suman Anna <s-anna@ti.com>
cc: Lokesh Vutla <lokeshvutla@ti.com>, Roger Quadros <rogerq@ti.com>,
        tony@atomide.com, santosh.shilimkar@oracle.com, t-kristo@ti.com,
        nm@ti.com, nsekhar@ti.com, bcousson@baylibre.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: hwmod: Fix _wait_target_ready() for hwmods
 without sysc
In-Reply-To: <54AC1AFB.4070504@ti.com>
Message-ID: <alpine.DEB.2.02.1501132330460.28034@utopia.booyaka.com>
References: <1418917790-1791-1-git-send-email-rogerq@ti.com> <5492F84E.7020706@ti.com> <alpine.DEB.2.02.1501020654050.27058@utopia.booyaka.com> <54AA4CD4.40105@ti.com> <alpine.DEB.2.02.1501060202540.28771@utopia.booyaka.com> <54AB9983.1040703@ti.com>
 <54AC1800.1020406@ti.com> <54AC1AFB.4070504@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman

On Tue, 6 Jan 2015, Suman Anna wrote:

> Looking at your rc3 log @
> http://www.pwsan.com/omap/testlogs/test_v3.19-rc3/20150105224749/boot/4460varsomom/,
> I do see a missing reg entry for mailbox, and that's the reason for your
> hang because of the missing bail out in your new patch.
> 
> [    0.261932] ------------[ cut here ]------------
> [    0.261962] WARNING: CPU: 0 PID: 1 at
> arch/arm/mach-omap2/omap_hwmod.c:2458 _init+0x3a0/0x3f0()
> [    0.261962] omap_hwmod: mailbox: doesn't have mpu register target base
> ...
> ...
> [    0.262329] ---[ end trace a1be72591db4662e ]---
> 
> Now that said, this is weird, since the reg property for mailbox is
> defined in the base omap4.dtsi and should be inherited by the 4460
> VAR-SOM-OM, unless you are booting with an old dtb.

Yeah, it doesn't make sense.  I'm pretty sure I'm using the right DTB 
here, since that board is booting with a concatenated uImage + DTB.  
Well, at least there's a good test platform here.


- Paul
