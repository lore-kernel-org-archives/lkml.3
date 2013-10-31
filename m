Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab3JaPO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:14:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36080 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab3JaPOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:14:24 -0400
Date: Thu, 31 Oct 2013 16:14:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: emulate SAHF instruction
Message-ID: <20131031151416.GB9818@pd.tnic>
References: <1383215382-10072-1-git-send-email-pbonzini@redhat.com>
 <20131031142119.GS4651@redhat.com>
 <527268E4.2070505@redhat.com>
 <20131031143405.GT4651@redhat.com>
 <52726DE0.3060207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52726DE0.3060207@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 03:49:04PM +0100, Paolo Bonzini wrote:
> Il 31/10/2013 15:34, Gleb Natapov ha scritto:
> > I haven't checked AMD doc, but if it is documented that lahf/sahf #UDs at 64
> > bit we should emulate it correctly.
> 
> It says "The LAHF instruction can only be executed in 64-bit mode if
> supported by the processor implementation. Check the status of ECX bit 0
> returned by CPUID function 8000_0001h to verify that the processor
> supports LAHF in 64-bit mode".  Same as Intel---in fact 80000001h is an
> "AMD leaf" so to speak.

Yes, we #UD if L/SAHF are not supported:

Invalid opcode,			The LAHF instruction is not supported, as indicated by CPUID
#UD				Fn8000_0001_ECX[LahfSahf] = 0.

> I found "AMD introduced support for the instructions with their Athlon
> 64, Opteron and Turion 64 revision D processors in March 2005 and Intel
> introduced support for the instructions with the Pentium 4 G1 stepping
> in December 2005".  I think we can for all practical purposes ignore the
> lahf_lm CPUID flag.
> 
> > Who knows what code depends on it.

I remember an issue where we had to turn off the LAHF_LM CPUID bit for
certain K8s because otherwise the flashplayer would SIGSEGV as it was
trying to execute LAHF but the CPU was not really supporting it although
CPUID said so :). See fbd8b1819e80a and 6b0f43ddfa358.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
