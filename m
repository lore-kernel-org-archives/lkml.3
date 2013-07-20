Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab3GTH2R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 03:28:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44276 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab3GTH2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 03:28:15 -0400
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@linaro.org>
Subject: RE: [PATCH] irqchip: gic: Don't complain in gic_get_cpumask() if UP
 system
Thread-Topic: [PATCH] irqchip: gic: Don't complain in gic_get_cpumask() if
 UP system
Thread-Index: AQHOedkohMh8X6U+iEOl11iYZdcEeZltOz1g
Date: Sat, 20 Jul 2013 07:27:25 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433EEB180B@DBDE04.ent.ti.com>
References: <1373067573-29946-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1373067573-29946-1-git-send-email-sboyd@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 06, 2013 at 05:09:33, Stephen Boyd wrote:
> In a uniprocessor implementation the interrupt processor targets
> registers are read-as-zero/write-ignored (RAZ/WI). Unfortunately
> gic_get_cpumask() will print a critical message saying
> 
>  GIC CPU mask not found - kernel will fail to boot.
> 
> if these registers all read as zero, but there won't actually be
> a problem on uniprocessor systems and the kernel will boot just
> fine. Skip this check if we're running a UP kernel or if we
> detect that the hardware only supports a single processor.
> 
> Cc: Nicolas Pitre <nico@linaro.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> Maybe we should just drop the check entirely? It looks like it may
> just be debug code that won't ever trigger in practice, even on the
> 11MPCore that caused this code to be introduced.
> 

Apologies if I missed v2 of this patch if there was one. I could not
locate it in my inbox or the list archives.

We have a yet to be released single-core A9 MPCore system (AM437x) which
needs to co-exist in omap2plus_defconfig wherein NR_CPUS is set to 2. 
This currently leads to the "GIC CPU mask not found..." being printed
twice during bootup. If the check is really some debug code, can it be
completely dropped?

Regards,
Vaibhav B.

