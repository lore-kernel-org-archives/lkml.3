Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3GEXtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 19:49:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:47344 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3GEXtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 19:49:51 -0400
Date: Sat, 6 Jul 2013 01:49:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Heiko_St=FCbner?= <heiko@sntech.de>
cc: John Stultz <john.stultz@linaro.org>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>
Subject: Re: [PATCH 5/9] clocksource: dw_apb_timer: quirk for variants without
 EOI register
In-Reply-To: <201307060054.07784.heiko@sntech.de>
Message-ID: <alpine.DEB.2.02.1307060147070.32106@ionos.tec.linutronix.de>
References: <201307060051.09716.heiko@sntech.de> <201307060054.07784.heiko@sntech.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-569905278-1373068186=:32106"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-569905278-1373068186=:32106
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sat, 6 Jul 2013, Heiko Stübner wrote:
> -	dw_ced->eoi = apbt_eoi;
> +	if (quirks & APBTMR_QUIRK_NO_EOI)
> +		dw_ced->eoi = apbt_eoi_int_status;
> +	else
> +		dw_ced->eoi = apbt_eoi;

No again. This has nothing to do with quirks. We use quirks for
workarounds and not for refactoring of code.

Thanks,

	tglx
--8323329-569905278-1373068186=:32106--
