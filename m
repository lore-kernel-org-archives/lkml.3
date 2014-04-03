Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaDCI7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:59:08 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:52818 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751215AbaDCI67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:58:59 -0400
Date: Thu, 3 Apr 2014 09:58:35 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Joe Sylve <joe.sylve@gmail.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] AArch64: TCR_TG1_64K incorrectly sets TCR_EL1 bits
 [31:30]
Message-ID: <20140403085835.GC17022@arm.com>
References: <CAHWCVW+cH6MwhQj-JGWN63AqseFYuDPoftv+zGJU8UDfAgueEQ@mail.gmail.com>
 <20140402123844.GE31892@arm.com>
 <20140402170747.GC24018@arm.com>
 <CAHWCVWJKiQxBBR43A3beG9f7dEw4JpkFGZ6V-Es8EAn0uW3WJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHWCVWJKiQxBBR43A3beG9f7dEw4JpkFGZ6V-Es8EAn0uW3WJw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 06:21:29PM +0100, Joe Sylve wrote:
> That makes sense and I agree, it's better to fix it now so that it
> will be easier to add 16K paging later (on a side note is there any
> reason not to add it now if someone was willing to do the work?).

See another thread with the Samsung folks about the adding 4-levels of
page tables. We need a bit of refactoring first to decouple the page
size from the number of levels, after that 16K would be relatively easy
(it's easy now as well but I don't see the point on doing it before the
refactoring).

> There was talk in another thread about the possibility of adding a
> pagetable-4K-hwdef.h and pagetable-64K-hwdef.h.  I think this is
> another example of why that might be a good idea as this stuff could
> be moved out of proc.S as to be bit more clean:
> 
> +#ifdef CONFIG_ARM64_64K_PAGES
> +#define TCR_TG_FLAGS   TCR_TG0_64K | TCR_TG1_64K
> +#else
> +#define TCR_TG_FLAGS   TCR_TG0_4K | TCR_TG1_4K
> +#endif

Yes, we could do this when we create the pgtable-*k-hwdef.h files.

-- 
Catalin
