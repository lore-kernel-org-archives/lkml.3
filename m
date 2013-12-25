Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab3LYTcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 14:32:16 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:45429
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293Ab3LYTcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 14:32:15 -0500
X-IronPort-AV: E=Sophos;i="4.95,549,1384297200"; 
   d="scan'208";a="42284532"
Date: Wed, 25 Dec 2013 20:32:12 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: a.zummo@towertech.it, grant.likely@linaro.org, robh+dt@kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: question about drivers/rtc/rtc-cmos.c
Message-ID: <alpine.DEB.2.02.1312252028170.2020@localhost6.localdomain6>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function cmos_do_probe contains the code:

		if (is_hpet_enabled()) {
                        int err;

                        rtc_cmos_int_handler = hpet_rtc_interrupt;
			err = hpet_register_irq_handler(cmos_interrupt);
                        if (err != 0) {
                                dev_warn(dev, "hpet_register_irq_handler "
                                                " failed in rtc_init().");
                                goto cleanup1;
                        }
                }

Is it intentional that the error code returned by 
hpet_register_irq_handler is put ina local variable that will not be seen 
at label cleanup1?  The return value is retval, which is 0 at this point.

thanks,
julia
