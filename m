Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3BXLpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 06:45:20 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:59474
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067Ab3BXLpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 06:45:17 -0500
X-IronPort-AV: E=Sophos;i="4.84,727,1355094000"; 
   d="scan'208";a="3270555"
Date: Sun, 24 Feb 2013 12:45:11 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: ben-linux@fluff.org, kgene.kim@samsung.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: question about arch/arm/mach-s3c24xx/irq.c
Message-ID: <alpine.DEB.2.02.1302241241440.1943@hadrien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function s3c24xx_irq_map in arch/arm/mach-s3c24xx/irq.c contains the
code:

                parent_irq_data = &parent_intc->irqs[irq_data->parent_irq];
		if (!irq_data) {
                        pr_err("irq-s3c24xx: no irq data found for hwirq %lu\n",
                               hw);
                        goto err;
		}

At this point irq_data has already been tested, so the null test on
irq_data does not look correct.  But I wonder if parent_irq_data could
ever be null here?

julia
