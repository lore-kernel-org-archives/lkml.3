Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab3IHJDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 05:03:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53955 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab3IHJDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 05:03:14 -0400
Date: Sun, 8 Sep 2013 10:02:06 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Anil Kumar <anilk4.v@gmail.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Benoit Cousson <b-cousson@ti.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Build error in torvalds kernel 3.11 for omap2plus
Message-ID: <20130908090206.GK25647@n2100.arm.linux.org.uk>
References: <CABYxbz7m4GdHFNY3fP1Cpv3a_dNTSozdd7dX9yLG6vQ3zZxu9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABYxbz7m4GdHFNY3fP1Cpv3a_dNTSozdd7dX9yLG6vQ3zZxu9A@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 11:34:10AM +0530, Anil Kumar wrote:
> scripts/kconfig/conf --silentoldconfig Kconfig
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
> make[1]: `include/generated/mach-types.h' is up to date.
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   AS      arch/arm/mm/cache-v7.o
> arch/arm/mm/cache-v7.S: Assembler messages:
> arch/arm/mm/cache-v7.S:285: Error: garbage following instruction -- `dsb ishst'
> arch/arm/mm/cache-v7.S:297: Error: garbage following instruction -- `dsb ishst'
> make[1]: *** [arch/arm/mm/cache-v7.o] Error 1
> make: *** [arch/arm/mm] Error 2

You need a later binutils for these instructions - 2.22 works just fine,
even with gcc 4.5.x.
