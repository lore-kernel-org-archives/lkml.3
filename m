Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaKKW6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 17:58:21 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56842 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752153AbaKKW6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 17:58:19 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18f1R+RtxneLArJnc29pUVIwat/pAPmtjA=
X-DKIM: OpenDKIM Filter v2.0.1 titan 49838618413
Date: Tue, 11 Nov 2014 17:58:00 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Kevin Cernekee <cernekee@gmail.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Kevin Hilman <khilman@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-sh@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Maxime Bizon <mbizon@freebox.fr>, Jonas Gorski <jogo@openwrt.org>,
        linux-mips@linux-mips.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] irqchip: atmel-aic: fix irqdomain initialization
Message-ID: <20141111225800.GE3698@titan.lakedaemon.net>
References: <20141110230301.GV4068@piout.net>
 <1415712816-9202-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415712816-9202-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 02:33:36PM +0100, Boris Brezillon wrote:
> First of all IRQCHIP_SKIP_SET_WAKE is not a valid irq_gc_flags and thus
> should not be passed as the last argument of
> irq_alloc_domain_generic_chips.
> 
> Then pass the correct handler (handle_fasteoi_irq) to
> irq_alloc_domain_generic_chips instead of manually re-setting it in the
> initialization loop.
> 
> And eventually initialize default irq flags to the pseudo standard:
> IRQ_REQUEST | IRQ_PROBE | IRQ_AUTOEN.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
> Hello Kevin,
> 
> This patch has not been tested yet but it should solve the issue you've
> experienced with the IRQ_GC_BE_IO flag and the atmel-aic driver.
> 
> I'll test it tomorrow and let you know if it actually works.
> 
> Regards,
> 
> Boris
> 
>  drivers/irqchip/irq-atmel-aic-common.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Applied to irqchip/urgent with Kevin's Tested-by.  Also, flagged for
stable, v3.17 and up.

Boris, once this is in mainline, you may want to generate a patch
against older versions (in the arch dir) for the stable team.

thx,

Jason.
