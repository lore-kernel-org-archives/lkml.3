Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbaHVCUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 22:20:10 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:49788 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbaHVCTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 22:19:53 -0400
Date: Thu, 21 Aug 2014 19:19:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc: Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 04/11] arm: Support restart through restart handler
 call chain
Message-ID: <20140822021947.GA17788@roeck-us.net>
References: <1408495538-27480-1-git-send-email-linux@roeck-us.net>
 <1408495538-27480-5-git-send-email-linux@roeck-us.net>
 <53F69DBA.4070806@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F69DBA.4070806@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 03:32:42AM +0200, Andreas Färber wrote:
> Hi,
> 
> Am 20.08.2014 02:45, schrieb Guenter Roeck:
> > The kernel core now supports a restart handler call chain for system
> > restart functions.
> > 
> > With this change, the arm_pm_restart callback is now optional, so
> > drop its initialization and check if it is set before calling it.
> > Only call the kernel restart handler if arm_pm_restart is not set.
> [...]
> > diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> > index 81ef686..ea279f7 100644
> > --- a/arch/arm/kernel/process.c
> > +++ b/arch/arm/kernel/process.c
> > @@ -114,17 +114,13 @@ void soft_restart(unsigned long addr)
> >  	BUG();
> >  }
> >  
> > -static void null_restart(enum reboot_mode reboot_mode, const char *cmd)
> > -{
> > -}
> > -
> >  /*
> >   * Function pointers to optional machine specific functions
> >   */
> >  void (*pm_power_off)(void);
> >  EXPORT_SYMBOL(pm_power_off);
> >  
> > -void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd) = null_restart;
> > +void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
> 
> Stupid newbie question maybe, but isn't this variable uninitialized now,
> like any non-static variable in C99? Or does the kernel assure that all
> such "fields" are zero-initialized?
> 
It is initialized with NULL, like all other global and static variables in the
kernel (and like pm_power_off a few lines above).

Guenter
