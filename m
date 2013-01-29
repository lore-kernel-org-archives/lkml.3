Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3A2Rmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 12:42:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55823 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab3A2Rmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 12:42:51 -0500
Date: Tue, 29 Jan 2013 18:42:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: Kim Phillips <kim.phillips@freescale.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] arm: use built-in byte swap function
Message-ID: <20130129174249.GB25415@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Woodhouse, David" <david.woodhouse@intel.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Russell King <linux@arm.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Santos <daniel.santos@pobox.com>,
	David Rientjes <rientjes@google.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20130128193033.8a0b0a871150c99247f05a95@freescale.com>
 <20130129083522.GA14302@pd.tnic>
 <1359478014.3529.157.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1359478014.3529.157.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 04:46:58PM +0000, Woodhouse, David wrote:
> If we're really going to have many different architectures depending
> on different versions of GCC for this (if it wasn't sane to use
> it from 4.4/4.8 when it got introduced, and depends on some later
> arch-specific optimisation), then perhaps we'll have the arch
> provide the corresponding required GCC_VERSION for using each of
> 64/32/16 bit builtins, instead of just a yes/no flag? Or just define
> __HAVE_BUILTIN_BSWAPxx__ for itself, perhaps?

Damn, there's already the __powerpc__ thing in there.

Yeah, something like defininig __HAVE_BUILTIN_BSWAPxx__ makes sense and
can keep the header arch-agnostic without growing all those different
arch defines.

But I liked your other suggestion better to get the offending compilers
fixed.

I dunno though, how generically is stuff like that getting implemented
for every arch so probably single arches doing __HAVE* defines is
probably going to be the realizable solution in the end.

Hmmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
