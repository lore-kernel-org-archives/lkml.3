Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab3BIKsB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 05:48:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44174 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab3BIKsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 05:48:00 -0500
Date: Sat, 9 Feb 2013 11:47:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 1/2] add helper for highmem checks
Message-ID: <20130209104751.GC17728@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, hpa@zytor.com, mingo@kernel.org,
	tglx@linutronix.de
References: <20130208202813.62965F25@kernel.stglabs.ibm.com>
 <20130209094121.GB17728@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130209094121.GB17728@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2013 at 10:41:21AM +0100, Borislav Petkov wrote:
> > +static inline bool phys_addr_is_highmem(phys_addr_t addr)
> > +{
> > +	return addr > last_lowmem_paddr();
> 
> I think you mean last_lowmem_phys_addr() here:
> 
> include/linux/mm.h: In function ‘phys_addr_is_highmem’:
> include/linux/mm.h:1764:2: error: implicit declaration of function ‘last_lowmem_paddr’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> 
> Changed.

With this change, they definitely fix something because I even get X on
the box started. Previously, it would spit out the warning and wouldn't
start X with the login window. And my suspicion is that wdm (WINGs
display manager) I'm using, does /dev/mem accesses when it starts and it
obviously failed. Now not so much :-)

Tested-by: Borislav Petkov <bp@suse.de>

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
