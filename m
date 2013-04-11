Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab3DKRMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:12:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52399 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab3DKRMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:12:52 -0400
Date: Thu, 11 Apr 2013 19:12:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave@sr71.net>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 4/5] break up slow_virt_to_phys()
Message-ID: <20130411171246.GF27062@pd.tnic>
References: <20130410233249.7FFCB63B@viggo.jf.intel.com>
 <20130410233254.EF273179@viggo.jf.intel.com>
 <20130411122944.GA27062@pd.tnic>
 <5166E4CB.2060700@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5166E4CB.2060700@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 09:28:59AM -0700, Dave Hansen wrote:
> It's harsh for the cases where __pa()'s result never gets used
> directly, like for checking against 'high_memory'. If it gets used
> (like in /dev/mem's case) the kernel really is doing something it does
> not intend to do. It's essentially reading or writing garbage.
>
> On the other hand, I guess if we've been letting it do that bad thing
> for years, we might as well continue. We're not causing any _more_
> damage.

Well, if it wasn't an already used interface I'd say we forbid accesses
which are void of sense and issue a WARN_ON but who knows who'll come
screaming if we did that.

> I'm leaning toward making it a WARN_ON() at the moment. :)

Right, well, yeah, people would still be able to shoot themselves in the
foot over /dev/mem but now they'll at least be warned about it. Kernel's
job's done. :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
