Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab3DWNaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:30:08 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:53877 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab3DWNaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:30:07 -0400
MIME-Version: 1.0
In-Reply-To: <CA+xJJ19G3kLMXbdA3Ac5O-J+B3wpUHf-M0b-A4Cgq=ROdsrtHQ@mail.gmail.com>
References: <CA+xJJ19G3kLMXbdA3Ac5O-J+B3wpUHf-M0b-A4Cgq=ROdsrtHQ@mail.gmail.com>
Date: Tue, 23 Apr 2013 15:30:05 +0200
Message-ID: <CA+xJJ1_CE5kEVY=5-_0_ebjEj4aDruTzfg2BHFvNPfeyvUjH9Q@mail.gmail.com>
Subject: Re: Testing timers/nohz-help-testing
From: Mats Liljegren <liljegren.mats2@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 2:40 PM, Mats Liljegren
<liljegren.mats2@gmail.com> wrote:
> I'm trying to test your new branch timers/nohz-help-testing.
>
> Since I'm using ARM, I cherry-picket a few of Kevin's commits from his
> arm-nohz-v3/context-tracking branch. It is based on an older version
> of NOHZ, but I think the context tracking and virtual CPU accounting
> should be pretty much the same. If not, then that might be the reason
> for my problems below...
>
> I'm unable to select CONFIG_NO_HZ_FULL. It misses
> CONFIG_VIRT_CPU_ACCOUNTING_GEN. I have CONFIG_VIRT_CPU_ACCOUNTING set
> by CONFIG_VIRT_CPU_ACCOUNTING_NATIVE though, but this didn't help.
>
> With below change I could at least go on with fixing compile errors:
>
> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> index e1ac129..cd00820 100644
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -106,7 +106,7 @@ config NO_HZ_FULL
>         depends on HAVE_CONTEXT_TRACKING
>         # RCU_NOCB_CPU dependency
>         depends on TREE_RCU || TREE_PREEMPT_RCU
> -       depends on VIRT_CPU_ACCOUNTING_GEN
> +       depends on VIRT_CPU_ACCOUNTING
>         select NO_HZ_COMMON
>         select RCU_USER_QS
>         select RCU_NOCB_CPU
>
> /Mats

Forget the above mail, I was too picky in my cherry-picking... When I
applied Kevins 64-bit fixes for VIRT_CPU_ACCOUNTING, I could select
VIRT_CPU_ACCOUNTING_GEN and get NO_HZ_FULL.

I think the naming is somewhat confusing, since
VIRT_CPU_ACCOUNTING_GEN is required by NO_HZ_FULL,
VIRT_CPU_ACCOUNTING_NATIVE is apparently not suitable for some reason.
Both VIRT_CPU_ACCOUNTING_(GEN|NATIVE) selects VIRT_CPU_ACCOUNTING,
making at least my head spin...

Sorry for the confusion...

/Mats
