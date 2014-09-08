Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbaIHXEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:04:24 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:44710 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbaIHXEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:04:23 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Osly/ex1VRQdMCEoCyyDq
Date: Mon, 8 Sep 2014 16:04:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd.bergmann@linaro.org>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v9 5/9] arm: omap1: Migrate debug_ll macros to use 8250.S
Message-ID: <20140908230411.GQ3238@atomide.com>
References: <1408459715-10151-1-git-send-email-daniel.thompson@linaro.org>
 <1408461407-10429-1-git-send-email-daniel.thompson@linaro.org>
 <1408461407-10429-6-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408461407-10429-6-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Thompson <daniel.thompson@linaro.org> [140819 08:19]:
> The omap1's debug-macro.S is similar to the generic 8250 code. Compared to
> the 8520 code the omap1 macro automatically determines what UART to use
> based on breadcrumbs left by the bootloader and automatically copes with
> the eccentric register layout on OMAP7XX.
> 
> This patch drops both these features and relies instead on the generic
> 8250 macros:
> 
> 1. Dropping support for the bootloader breadcrumbs is identical to the
>    way the migration was handled for OMAP2 (see 808b7e07464d...).
> 
> 2. Support for OMAP7XX still exists but it must be configured by hand
>    (DEBUG_OMAP7XXUART1/2/3) rather than handled at runtime.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
> Cc: linux-omap@vger.kernel.org
> Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>

This should be safe to queue together with your other debug_ll
patches, so:

Acked-by: Tony Lindgren <tony@atomide.com>

If you want me to queue this one instead, please let me know.

Regards,

Tony
