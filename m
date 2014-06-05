Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaFEPz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:55:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:32873 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaFEPzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:55:25 -0400
Date: Thu, 5 Jun 2014 17:53:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/efi] x86/efi: Check for unsafe dealing with FPU state
 in irq ctxt
Message-ID: <20140605155307.GD16642@pd.tnic>
References: <tip-baa916f39b50ad91661534652110df40396acda0@git.kernel.org>
 <538F9AFA.5050806@zytor.com>
 <20140604224920.GB4126@pd.tnic>
 <538FB775.8070405@amacapital.net>
 <20140605071805.GA16647@pd.tnic>
 <CAL01qpuj6jvH4XLvhHAszbqmSPXfW=VOdv+TqMwBuDnArL=ofw@mail.gmail.com>
 <20140605090206.GA16642@pd.tnic>
 <CALCETrU2TZhxOZyCvBd1nLDiU4ceiSx_Sd2bsDUCX5arOFidBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrU2TZhxOZyCvBd1nLDiU4ceiSx_Sd2bsDUCX5arOFidBg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 08:44:20AM -0700, Andy Lutomirski wrote:
> Are there weird contexts from which EFI calls can happen? It looks
> like the current code isn't necessarily safe in things that aren't
> normal process context but aren't interrupts either (e.g. debug traps,
> #GP, etc).

The efi-pstore thing registers as a kmsg dumper which can be run in NMI
context and efi can be called there.

> I wonder if it would make sense at some point to maintain an explicit
> stack of kernel entries. There doesn't seem to be a reliable way to
> answer the question of "what context am I in" from C code right now.

So that you can ask int ctxt = what_context_Im_in() and then that
context can go and change right underneath you. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
