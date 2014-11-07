Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaKGR4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:56:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39036 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaKGR4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:56:49 -0500
Date: Fri, 7 Nov 2014 18:56:45 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 6/8] x86, microcode, intel: use cpuid explicitly instead
 of sync_core
Message-ID: <20141107175645.GC5180@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-7-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1410197875-19252-7-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 02:37:52PM -0300, Henrique de Moraes Holschuh wrote:
> The protocol to safely read MSR 8BH, described in the Intel SDM vol 3A,
> section 9.11.7.1, explicitly determines that cpuid with EAX=1 must be
> used between the wrmsr(0x8B, 0); and the rdmsr(0x8B).
> 
> The microcode driver was abusing sync_core() to do this, probably
> because it predates by nearly a decade the current "asm volatile
> (:::"memory")" implementation of native_cpuid(), which is required for
> the Intel MSR 8BH access protocol.

Huh, what? Have you taken a look at sync_core() first?

> sync_core() semanthics are that of being a speculative execution
> barrier, and not "run cpuid with EAX=1".

Again, what?

Hmm, let's see:

static inline void sync_core(void)
{
 ...

        asm volatile("cpuid"
                     : "=a" (tmp)
                     : "0" (1)
                     : "ebx", "ecx", "edx", "memory");

What is the problem again?

I'm sorry but I don't understand what you're trying to fix here...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
