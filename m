Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949AbaKRXLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:11:37 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55315 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932525AbaKRXLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:11:35 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, len.brown@intel.com, linux@arm.linux.org.uk,
        ccross@android.com
Subject: Re: [PATCH v2] cpu_pm: fix unmet dependency for CPU_PM
Date: Wed, 19 Nov 2014 00:32:39 +0100
Message-ID: <1978454.Vafaacm06c@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.LFD.2.11.1411170128560.11690@knanqh.ubzr>
References: <1416204764-8912-1-git-send-email-pankaj.dubey@samsung.com> <alpine.LFD.2.11.1411170128560.11690@knanqh.ubzr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 17, 2014 01:29:20 AM Nicolas Pitre wrote:
> On Mon, 17 Nov 2014, Pankaj Dubey wrote:
> 
> > If BL_SWITCHER is enabled but SUSPEND and CPU_IDLE is not enabled
> > we are getting following config warning.
> > 
> > warning: (BL_SWITCHER) selects CPU_PM which has unmet direct
> > dependencies (SUSPEND || CPU_IDLE)
> > 
> > It has been noticed that CPU_PM dependencies in this file are not really
> > required so let's remove these dependencies from CPU_PM.
> > 
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> 
> Acked-by: Nicolas Pitre <nico@linaro.org>

Patch queued up for 3.19-rc1, thanks!

> > ---
> > This patch is second attempt to fix this config issue. Patch v1 and related
> > discussion can be found here [1]
> > 1: https://lkml.org/lkml/2014/11/14/673
> > 
> >  kernel/power/Kconfig |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> > index bbef57f..1eb7da7 100644
> > --- a/kernel/power/Kconfig
> > +++ b/kernel/power/Kconfig
> > @@ -308,4 +308,3 @@ config PM_GENERIC_DOMAINS_OF
> >  
> >  config CPU_PM
> >  	bool
> > -	depends on SUSPEND || CPU_IDLE
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
