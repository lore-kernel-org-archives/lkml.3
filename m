Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab3C1BTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 21:19:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39026 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab3C1BTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 21:19:50 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Andrei Epure <epure.andrei@gmail.com>
CC: "cbou@mail.ru" <cbou@mail.ru>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>
Subject: RE: [PATCH] power: pass IRQF_ONESHOT to request_threaded_irq()
Thread-Topic: [PATCH] power: pass IRQF_ONESHOT to request_threaded_irq()
Thread-Index: AQHOK01HcBzuwK+XnUmTBXXijZsHtJi6SyBA
Date: Thu, 28 Mar 2013 01:19:30 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E49C87@DQHE02.ent.ti.com>
References: <1364431370-25029-1-git-send-email-epure.andrei@gmail.com>
In-Reply-To: <1364431370-25029-1-git-send-email-epure.andrei@gmail.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Andrei Epure [mailto:epure.andrei@gmail.com]
> Sent: Thursday, March 28, 2013 9:43 AM
> To: cbou@mail.ru; dwmw2@infradead.org; Kim, Milo;
> broonie@opensource.wolfsonmicro.com; linux-kernel@vger.kernel.org;
> patches@opensource.wolfsonmicro.com
> Cc: Andrei Epure
> Subject: [PATCH] power: pass IRQF_ONESHOT to request_threaded_irq()
> 
> Patch found using coccinelle.
> 
> Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
> ---
>  drivers/power/ab8500_btemp.c     |    2 +-
>  drivers/power/ab8500_charger.c   |    2 +-
>  drivers/power/ab8500_fg.c        |    2 +-
>  drivers/power/lp8788-charger.c   |    2 +-
>  drivers/power/max17042_battery.c |    3 ++-
>  drivers/power/max8903_charger.c  |   12 +++++++++---
>  drivers/power/pm2301_charger.c   |    2 +-
>  drivers/power/smb347-charger.c   |    3 ++-
>  drivers/power/wm831x_power.c     |    8 +++++---
>  9 files changed, 23 insertions(+), 13 deletions(-)

Could you share what will happen without this patch?
Do you mean the IRQF_ONESHOT flag with a primary IRQ handler?
If yes, no need to handle this for lp8788-charger driver because it is
a nested handler rather a default primary handler.
Handler function is replaced with irq_nested_primary_handler() on setting up
the IRQ.

Thanks.

Regards,
Milo
