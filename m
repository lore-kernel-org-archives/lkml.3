Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab3KHQwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:52:38 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42508 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab3KHQwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:52:37 -0500
Date: Fri, 8 Nov 2013 16:52:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Use udiv/sdiv for __aeabi_{u}idiv library
	functions
Message-ID: <20131108165223.GL16735@n2100.arm.linux.org.uk>
References: <1383852042-10780-1-git-send-email-sboyd@codeaurora.org> <20131108095842.GG28304@ns203013.ovh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108095842.GG28304@ns203013.ovh.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 10:58:42AM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 11:20 Thu 07 Nov     , Stephen Boyd wrote:
> > @@ -381,6 +384,13 @@ static void __init cpuid_init_hwcaps(void)
> >  		elf_hwcap |= HWCAP_IDIVT;
> >  	}
> >  
> > +#ifdef CONFIG_THUMB2_KERNEL
> if (IS_ENABLED(CONFIG_THUMB2_KERNEL) && elf_hwcap & HWCAP_IDIVT)
> > +	if (elf_hwcap & HWCAP_IDIVT)
> > +#else
> > +	if (elf_hwcap & HWCAP_IDIVA)
> > +#endif

Take another look, and you'll see the change that you're suggesting is
wrong.  Instead, the following may be a more reasonable suggestion as
a suitable replacement:

	if (elf_hwcap & (IS_ENABLED(CONFIG_THUMB2_KERNEL) ?
				HWCAP_IDIVT : HWCAP_IDIVA))
