Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965793AbaFTUAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:00:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47485 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbaFTUAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:00:33 -0400
Date: Fri, 20 Jun 2014 22:00:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, Dave Jones <davej@redhat.com>
Subject: Re: [RFC][PATCH 3/3] x86: make MP  a required-feature on 64-bit
Message-ID: <20140620200024.GJ11391@pd.tnic>
References: <20140620161736.D6AC16FD@viggo.jf.intel.com>
 <20140620161740.BFB00798@viggo.jf.intel.com>
 <53A46008.5060509@zytor.com>
 <53A4619C.8020100@sr71.net>
 <53A46365.6090101@zytor.com>
 <20140620174345.GD11391@pd.tnic>
 <53A473AA.7050301@zytor.com>
 <20140620180523.GF11391@pd.tnic>
 <53A48356.5080109@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53A48356.5080109@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 11:54:14AM -0700, H. Peter Anvin wrote:
> No, it has to be cpu_has() -- the dynamic, CPU-specific version.

Ok, sry, but I have to ask: why cpu_has? Why not boot_cpu_has and thus
static_cpu_has_safe?

At
	if (this_cpu->c_init)
		this_cpu->c_init(c)

time in identify_cpu() when we execute init_amd(), we have run
generic_identify(c) which would have done get_cpu_cap() already and
boot_cpu_data.x86_capability[1] would have cpuid_edx(0x80000001) where
X86_FEATURE_MP bit would be set too.

Oh, and this happens after the first clearing

	/* Clear/Set all flags overriden by options, after probe */

but this won't clear it. And we're before the building of the common
feature set at the end of identify_cpu(). But even that doesn't matter
in this case because this bit will be set in CPUID on every core and
thus remain set in boot_cpu_data.

Bah, so what am I missing?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
