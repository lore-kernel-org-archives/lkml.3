Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab3CSXPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:15:11 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:47779 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab3CSXPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:15:10 -0400
MIME-Version: 1.0
In-Reply-To: <1363705484-27645-1-git-send-email-fenghua.yu@intel.com>
References: <1363705484-27645-1-git-send-email-fenghua.yu@intel.com>
Date: Tue, 19 Mar 2013 16:15:09 -0700
X-Google-Sender-Auth: HIPnNQ9hKGvU_UTlIDBK0flvHIk
Message-ID: <CAE9FiQVhziaB9vEUNw-EBvA1Bfey=uMEw+CERuqSyPgU3qCJUA@mail.gmail.com>
Subject: Re: [PATCH] x86/microcode_intel_early.c: Get 32-bit physical address
 by __pa_nodebug()
From: Yinghai Lu <yinghai@kernel.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        penguin-kernel@i-love.sakura.ne.jp,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 8:04 AM, Fenghua Yu <fenghua.yu@intel.com> wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
>
> In 32-bit, __pa_symbol() in CONFIG_DEBUG_VIRTUAL accesses kernel data (e.g.
> max_low_pfn) that haven't been setup yet in such early boot phase. To fix the
> issue, __pa_nodebug() replaces __pa_symbol() to get a global symbol's physical
> address.

That explanation is not precise.

__phys_addr in 32bit when DEBUG_VIRTUAL is set, it does have check
        /* max_low_pfn is set early, but not _that_ early */
        if (max_low_pfn) {
         ....
        }
the reason should be:
in head_32.S, 32bit flat mode, you need to switch to phys addr to access
global variable max_low_pfn.

Thanks

Yinghai
