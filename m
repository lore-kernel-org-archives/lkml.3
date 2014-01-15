Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaAONgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:36:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbaAONg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:36:27 -0500
Date: Wed, 15 Jan 2014 14:36:19 +0100
From: Borislav Petkov <bp@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        aravind.gopalakrishnan@amd.com, tglx@linutronix.de, bp@suse.de,
        hpa@linux.intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, cpu, amd: Add workaround for family 16h,
 erratum 793
Message-ID: <20140115133619.GA32051@pd.tnic>
References: <20140114230711.GS29865@pd.tnic>
 <tip-3b56496865f9f7d9bcb2f93b44c63f274f08e3b6@git.kernel.org>
 <52D5DC51.9010606@zytor.com>
 <20140115062817.GA11869@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140115062817.GA11869@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 07:28:17AM +0100, Ingo Molnar wrote:
> > The perhaps only question is if it should be "set/clear_bit_in_msr()"
> > rather than having to haul a full 64-bit mask in the common case.

I'd prefer the _bit() variant because it is easy to use in all those
set-chicken-bit cases.

> I'd suggest the introduction of a standard set of methods operating on 
> MSRs:
> 
> 	msr_read()
> 	msr_write()
> 	msr_set_bit()
> 	msr_clear_bit()
> 	msr_set_mask()
> 	msr_clear_mask()
> 
> etc.
> 
> msr_read() would essentially map to rdmsr_safe(). Each method has a
> return value that can be checked for failure.

I'm not sure we want to use the _safe() variants by default as it would
generate the exception tables even in cases where they're clearly not
needed.

> Note that the naming of 'msr_set_bit()' and 'msr_clear_bit()' mirrors
> that of bitops, and set_mask/clear_mask is named along a similar
> pattern, so that it's more immediately obvious what's going on.

Yes, I completely agree - this is something I will do after the merge
window.

The question about the need for the _mask() variants will be best
answered after going over the sources and checking whether there
actually is a need for setting more than one bit in an MSR.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
