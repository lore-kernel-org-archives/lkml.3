Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaGUJ35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:29:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50041 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbaGUJ34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:29:56 -0400
Date: Mon, 21 Jul 2014 11:29:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>, Andreas Mohr <andi@lisas.de>,
        Borislav Petkov <bp@suse.de>, Javi Merino <javi.merino@arm.com>
Subject: Re: [PATCH v4 3/6] thermal: Added Bang-bang thermal governor
Message-ID: <20140721092950.GB10016@pd.tnic>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1405817480-25347-1-git-send-email-peter@piie.net>
 <1405817480-25347-4-git-send-email-peter@piie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1405817480-25347-4-git-send-email-peter@piie.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 02:51:17AM +0200, Peter Feuerer wrote:
> The bang-bang thermal governor uses a hysteresis to switch abruptly on
> or off a cooling device.  It is intended to control fans, which can
> not be throttled but just switched on or off.
> Bang-bang cannot be set as default governor as it is intended for
> special devices only.  For those special devices the driver needs to
> explicitely request it.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Andreas Mohr <andi@lisas.de>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Javi Merino <javi.merino@arm.com>
> Signed-off-by: Peter Feuerer <peter@piie.net>
> ---
>  drivers/thermal/Kconfig         |  10 +++
>  drivers/thermal/Makefile        |   1 +
>  drivers/thermal/gov_bang_bang.c | 131 ++++++++++++++++++++++++++++++++++++++++
>  drivers/thermal/thermal_core.c  |   5 ++
>  drivers/thermal/thermal_core.h  |   8 +++
>  5 files changed, 155 insertions(+)
>  create mode 100644 drivers/thermal/gov_bang_bang.c
> 
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index f9a1386..cdddf09 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -84,6 +84,16 @@ config THERMAL_GOV_STEP_WISE
>  	  Enable this to manage platform thermals using a simple linear
>  	  governor.
>  
> +config THERMAL_GOV_BANG_BANG
> +	bool "Bang Bang thermal governor"
> +	default y

Right, this is problematic.

When people are faced with the new selection after doing oldconfig, they
can say yes or no.

However, as acerhdf depends on it now, prompting the user to
unconditionally says yes is kinda redundant. Especially as this governor
is not supposed to be default anyway.

Actually you don't need the Kconfig prompt at all as this is a sort-of
"internal" governor and devices select it. IOW, it should be "default n"
and ACERHDF will do "select THERMAL_GOV_BANG_BANG". Something like that
at least.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
