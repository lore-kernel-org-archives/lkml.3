Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaHKPPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:15:25 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:55814 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbaHKPPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:15:23 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <5215142.eaz1Ajyth6@vostro.rjw.lan>
References: <5215142.eaz1Ajyth6@vostro.rjw.lan>
Date: Mon, 11 Aug 2014 08:15:22 -0700
Message-ID: <CAOesGMiohfNDRo1P58NYdQA6tqSLfuPQV85BEDVVo8UvtW=Ctw@mail.gmail.com>
Subject: Re: [RFC][PATCH] PM / sleep: Rename symbols, functions and variables
 related to sleep
From: Olof Johansson <olof@lixom.net>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Zhang Rui <rui.zhang@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 4:13 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> The names of several symbols, data types, functions and variables
> related to system sleep states are confusing and don't reflect the
> real behavior of those states correctly.
>
> First of all, there generally are two sleep states that require
> platform support and one sleep state that is platform-independent.
> The first two of them are currently known as MEM and STANDBY,
> although these names really only match what the states do on full
> hardware ACPI compliant systems.  MEM in particular is supposed
> to mean "suspend-to-RAM", but in fact it means "the deepest sleep
> state available with platform support".  The definition of STANDBY
> is even more arbitrary.
>
> Moreover, the remaining sleep state that doesn't need platform support
> is currently called FREEZE, which leads to double confusion with the
> process freezer (used during transitions to all sleep states) and
> with the freeze stage of processing devices during hibernation.
>
> For these reasons, rename the PM_SUSPEND_MEM, PM_SUSPEND_STANDBY
> and PM_SUSPEND_FREEZE symbols to PM_SUSPEND_PLATFORM_DEEP,
> PM_SUSPEND_PLATFORM_SHALLOW and PM_SUSPEND_IDLE_SLEEP, respectively,
> everywhere and rename data types, functions and variables related to
> those states to match the new names of the symbols.
>
> This is a semi-mechanical replacement of names and it should not lead
> to any functional differences.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

This showed up in -next over this weekend and broke two ARM builds.
Please don't add new code to -next during a merge window.

>From http://arm-soc.lixom.net/buildlogs/next/next-20140811:

/home/build/work/batch/arch/arm/mach-s5pv210/pm.c:150:12: error:
'suspend_valid_only_mem' undeclared here (not in a function)
  .valid  = suspend_valid_only_mem,

/home/build/work/batch/arch/arm/mach-mmp/pm-pxa910.c: In function
'pxa910_pm_valid':
/home/build/work/batch/arch/arm/mach-mmp/pm-pxa910.c:243:65: error:
expected ')' before ';' token
  return state == PM_SUSPEND_SHALLOW || (state == PM_SUSPEND_DEEP;
                                                                 ^
/home/build/work/batch/arch/arm/mach-mmp/pm-pxa910.c:244:1: error:
expected ';' before '}' token
 }
 ^


-Olof
