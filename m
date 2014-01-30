Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaA3XBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 18:01:08 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:35676 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaA3XBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 18:01:05 -0500
Date: Thu, 30 Jan 2014 15:01:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Woodhouse <dwmw2@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH v2] x86, boot: Fix word-size assumptions in has_eflag ()
 inline asm
In-Reply-To: <1391079628.26079.82.camel@shinybook.infradead.org>
Message-ID: <alpine.DEB.2.02.1401301453160.12223@chino.kir.corp.google.com>
References: <1390996897.20153.123.camel@i7.infradead.org> <tip-9b3614ccfa5492f57f743f3856253f285b10a702@git.kernel.org> <20140130090902.GA2749@gmail.com> <1391079628.26079.82.camel@shinybook.infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, David Woodhouse wrote:

> Commit dd78b97367bd575918204cc89107c1479d3fc1a7 ("x86, boot: Move CPU
> flags out of cpucheck") introduced ambiguous inline asm in the
> has_eflag() function. In 16-bit mode want the instruction to be
> 'pushfl', but we just say 'pushf' and hope the compiler does what we
> wanted.
> 
> When building with 'clang -m16', it won't, because clang doesn't use
> the horrid '.code16gcc' hack that even 'gcc -m16' uses internally.
> 
> Say what we mean and don't make the compiler make assumptions.
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

Fixes the x86-build-for-linus build error for me, thanks!
