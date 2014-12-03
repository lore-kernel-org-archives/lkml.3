Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaLCWYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:24:01 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53830 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750730AbaLCWYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:24:00 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-omap@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] hsi / OMAP / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Wed, 03 Dec 2014 23:45:22 +0100
Message-ID: <22524926.vCRamu0d6Y@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2553100.3OLsEPLv6G@wuerfel>
References: <6319344.XVfdONE5DJ@vostro.rjw.lan> <2553100.3OLsEPLv6G@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 03, 2014 08:49:12 PM Arnd Bergmann wrote:
> On Wednesday 03 December 2014 03:02:24 Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> > selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> > depending on CONFIG_PM_RUNTIME may now be changed to depend on
> > CONFIG_PM.
> > 
> > Do that for the omap_ssi driver.
> > 
> 
> Just for clarification: does that mean that PM, PM_RUNTIME, and PM_SLEEP
> are all synonyms now, or is there still some other combination that
> allows a subset to be set?

PM_RUNTIME is always set when PM is, but PM_SLEEP still may not be set then.

The plan is to drop PM_RUNTIME and use PM as a user-visible option instead
of it (which can be selected automatically by PM_SLEEP too).

As stated here:
http://marc.info/?l=linux-kernel&m=141710589711818&w=4
http://marc.info/?l=linux-kernel&m=141712284917133&w=4

> Before we do lots of s/CONFIG_PM_SLEEP/CONFIG_PM/ changes in lots of
> other drivers, it would be nice to come up with a new set of macros
> to replace all the SET_RUNTIME_PM_OPS/SIMPLE_DEV_PM_OPS/..._OPS
> with a version that avoided the #ifdefs altogether.

I don't think we can avoid all of the #ifdefs and the macros still work
(except for one which is redundant, but I have a patch to clean that up).

Rafael

