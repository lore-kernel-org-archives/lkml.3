Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaLCTtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:49:22 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:58215 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaLCTtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:49:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-omap@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] hsi / OMAP / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Wed, 03 Dec 2014 20:49:12 +0100
Message-ID: <2553100.3OLsEPLv6G@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <6319344.XVfdONE5DJ@vostro.rjw.lan>
References: <6319344.XVfdONE5DJ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ddGrHQaAuwO6CzjcWS2qDpizgizBLvYhbIOuITQqS9V
 C2yKZCfUfUupW5narSwR5hvUU/i+WXb8+vJJB++SIFWPFXpzyA
 l7n/fc3ILYtIunYMpGDBIGCBrEGC0zc5/qypmSHp2A6hEURXiR
 wFaUyXQ/v9NY0LUmWGppVp0iYjZ6+UQ+ES5UVs4sv+qcr/Gx+4
 SOhkE5Yst2XymBMA7I8Zu6p4fI3ZoNwNTlnuT1eL0wasEza8d7
 atmB3WP17z3AxERfN5qLYS+ojNGkn6k24eqHjXzStg5XJVzdWc
 3MaomfFDF6VcbqDaJbNGvleUsUc5jWS4aoOX/k3CPuTCoIp3g8
 cZzXIbW2Ju4HjalP7HWM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 03:02:24 Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> Do that for the omap_ssi driver.
> 

Just for clarification: does that mean that PM, PM_RUNTIME, and PM_SLEEP
are all synonyms now, or is there still some other combination that
allows a subset to be set?

Before we do lots of s/CONFIG_PM_SLEEP/CONFIG_PM/ changes in lots of
other drivers, it would be nice to come up with a new set of macros
to replace all the SET_RUNTIME_PM_OPS/SIMPLE_DEV_PM_OPS/..._OPS
with a version that avoided the #ifdefs altogether.

	Arnd
