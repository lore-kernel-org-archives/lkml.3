Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaFZUr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:47:56 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:56760 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaFZUry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:47:54 -0400
MIME-Version: 1.0
In-Reply-To: <7919ae8b-958b-4b12-a5f4-8be2c3df3824@email.android.com>
References: <55466fbd36df1d011876135cf7ca5d40c05029c7.1403809591.git.luto@amacapital.net>
 <20140626195629.GC5714@two.firstfloor.org> <CALCETrVBKno2skh3zR=1GYuojwPhYPLD=1HFcLMXjStS+0SPJQ@mail.gmail.com>
 <CALCETrWJD4kvoCxxb9y19uMakChmxamveKDceDOhyjYzFkJoUA@mail.gmail.com> <7919ae8b-958b-4b12-a5f4-8be2c3df3824@email.android.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 26 Jun 2014 13:47:32 -0700
Message-ID: <CALCETrVkeTd4UJNm2ir3AMo1eLEr6CKK0Cf9_-NCO+DP+iTRxg@mail.gmail.com>
Subject: Re: [PATCH] x86_64,entry: Fix RCX for traced syscalls
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, X86 ML <x86@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 1:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> The real question is if we care that sysret and iter don't match.  On 32 bits the situation is even more complex.

At least for 64 bits, iret vs sysret is purely a kernel implementation
detail (except where a tracer modifies things that are inaccessible to
sysret), so ISTM it's worth one instruction to make them match.

I noticed this thing while fiddling with moving some of the syscall
tracing logic to C.  This isn't a real problem, but it at least made
me scratch my head.

--Andy
