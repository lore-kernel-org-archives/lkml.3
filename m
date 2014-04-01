Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaDAV6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:58:07 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:61808 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaDAV6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:58:05 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1396198036.git.luto@amacapital.net>
References: <cover.1396198036.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 1 Apr 2014 14:57:43 -0700
Message-ID: <CALCETrX=OCu14inB_v1zTtjVJx3EK5Ar6+QzBVc1seUnTmnz3g@mail.gmail.com>
Subject: Re: [PATCH 0/6] x86: Clean up and unify the vdso
To: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>
Cc: Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 9:53 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> This rewrites a bunch of the vdso code.  After these patches, the vvar
> and hpet pages are mapped directly after the vdso text on all five vdso
> variants.  The fixmaps are gone on 64-bit systems.
>
> It would be possible to build the x32 vdso the normal way on top of
> these patches.
>
> I haven't touched the pvclock code.  I'd want to understand why it
> exists, why it isn't using rdtsc, and why it has two rdtsc_barrier calls
> before rearranging it.
>
> This is most likely 3.16 material.
>
> Andy Lutomirski (6):
>   x86: Clean up 32-bit vs 64-bit vdso params
>   x86: Move syscall and sysenter setup into kernel/cpu/common.c
>   x86: Reimplement vdso.so preparation in build-time C

This breaks gold.  I'll submit a v2 after the merge window with a fix.
 (It's a trivial change to the linker script and shouldn't
meaningfully affect any effort to review this series.)

>   x86: Move the 32-bit vdso special pages after the text
>   x86: Move the vvar and hpet mappings next to the 64-bit vDSO
>   x86: Remove vestiges of VDSO_PRELINK and some outdated comments

--Andy
