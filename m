Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab3ETJuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:50:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44893 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766Ab3ETJuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:50:22 -0400
Date: Mon, 20 May 2013 10:49:50 +0100
From: Will Deacon <will.deacon@arm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "david.daney@cavium.com" <david.daney@cavium.com>
Subject: Re: [PATCH] arm64: extable: sort the exception table at build time
Message-ID: <20130520094950.GG31359@mudshark.cambridge.arm.com>
References: <1368809021-25130-1-git-send-email-will.deacon@arm.com>
 <20130517184950.GA22304@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130517184950.GA22304@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 07:49:50PM +0100, Sam Ravnborg wrote:
> On Fri, May 17, 2013 at 05:43:41PM +0100, Will Deacon wrote:
> > +	. = ALIGN(8);
> > +	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
> > +		__start___ex_table = .;
> > +		*(__ex_table)
> > +		__stop___ex_table = .;
> > +	}
> 
> Here you could use:
>      EXCEPTION_TABLE(align)
> 
> (From include/asm-generic/vmlinux.lds.h)

Good spot, I'll spin a v2 using that. Looks like we don't use that for
arch/arm/ because we want to discard the section ifdef CONFIG_MMU. Maybe we
could change the generic macro to expand to nothing if !MMU, but I'm not
sure if other MMU-less architectures are playing tricks with this.

Will
