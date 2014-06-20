Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbaFTRnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:43:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37791 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbaFTRnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:43:53 -0400
Date: Fri, 20 Jun 2014 19:43:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC][PATCH 3/3] x86: make MP  a required-feature on 64-bit
Message-ID: <20140620174345.GD11391@pd.tnic>
References: <20140620161736.D6AC16FD@viggo.jf.intel.com>
 <20140620161740.BFB00798@viggo.jf.intel.com>
 <53A46008.5060509@zytor.com>
 <53A4619C.8020100@sr71.net>
 <53A46365.6090101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53A46365.6090101@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 09:37:57AM -0700, H. Peter Anvin wrote:
> We probably should just the cpu_has_mp macro entirely.  All it is used
> for is printing a warning in amd_k7_smp_check().
> 
> Andi, Borislav -- as far as I can tell, we have *never* enforced this on
> the 64-bit kernel, although we have enforced it on 64-bit processors
> running the 32-bit kernel.  We should either enforce it on both or just
> drop it.  What is your opinion?

Well, my AMD CPUID guide says CPUID Fn8000_0001_EDX[19] is reserved,
i.e. that X86_FEATURE_MP bit will be probably cleared.

And so it is, on my F15h AMD it is not set:

eax in: 0x80000001, eax = 00600f20 ebx = 10000000 ecx = 01ebbfff edx = 2fd3fbff
									  ^
								----------|

So I don't think we should enforce it on 64-bit.

I guess we can leave the check in amd_k7_smp_check() though but remove that
nasty cpu_has_mp macro and do static_cpu_has() instead.

My 2¢ only.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
