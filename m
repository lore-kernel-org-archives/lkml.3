Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaKXNe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:34:59 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:65366 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaKXNez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:34:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: ralf@linux-mips.org, f.fainelli@gmail.com, jfraser@broadcom.com,
        dtor@chromium.org, tglx@linutronix.de, jason@lakedaemon.net,
        jogo@openwrt.org, computersforpeace@gmail.com,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 00/11] Multiplatform BMIPS kernel
Date: Mon, 24 Nov 2014 14:34:24 +0100
Message-ID: <5143071.8HhdKL6dxp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416796846-28149-1-git-send-email-cernekee@gmail.com>
References: <1416796846-28149-1-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bAmtyKAPHSvSk6e9JeDlWq9vQiruY3myVnvFHGs5ZGI
 hrJT4RAQxXyIUCfi4cUdBA7bJXqnRjNCV0ZCWIqXTsz30ZsOyX
 aGItaXuvzfhOEEoA/w3qNCgdrXM7VltsI5wDKDtDJm85Pel3MI
 MiUiqm3jldOzwz3l8Jff/bmALBjcNt+HgH6NfDKsjKLYMgAsbJ
 uF8Jul8JyCyq922pIIJfd7WbyJXpGY8vyefUkQrER1/U+X6JQq
 zwAxZum9LDwcYkzYmZo2zH14g3l39Y9pefiqqHHqKRySB5NlNv
 L618BrEEiENrCAcDZl2DYFDeR4ZJBrXqymKG0j6+0FxDMa8tS8
 bK1DqmRUfnkYCjNQMeVc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 November 2014 18:40:35 Kevin Cernekee wrote:

> V2->V3:
> 
>  - Omit the BMIPS updates that have already been accepted into Ralf's tree.
>    They are still needed, but not reposted.
> 
>  - Make USB endian swap options conditional on "if CPU_BIG_ENDIAN".
> 
>  - Remove board listing from Documentation/devicetree/bindings/mips/brcm/soc.txt
> 
>  - Remove legacy device autodetection and chip ID decoding.  Legacy
>    boards/bootloaders will be supported by selecting a single DTB file
>    to compile into the kernel.
> 
>  - Refactor quirks code to match against DT "compatible" strings, not chip IDs.
> 
>  - Fix CPU1 boot (missing DT node) on 6329.
> 
>  - Remove @0 / addressing properties on non-reg nodes.
> 
>  - Remove bogus "brcm,bmips" bus registration.
> 
>  - Move UBUS peripherals onto a "simple-bus" and set DMA ranges for this
>    bus on bcm3384_zephyr.
> 
>  - Fix base addresses on 6328/6368 for "periph_intc@10000020".
> 
>  - Change the MIPS_L1_CACHE_SHIFT calculation so as to minimize the impact
>    on other builds (like bcm63xx).

Looks nice to me overall, with the new way of handling the dtb passing,
this seems much more flexible, and I guess it can be turned into an
actual multiplatform build if there is ever a desire to do that.

> Re: dma-ranges
> 
> dma.c implements a minimal remapping scheme just for the current UBUS
> peripherals.  The remapping is global, and it isn't the same mapping
> needed for PCI(e).  A more comprehensive solution will be needed before
> PCI support can be added.
> 
> On chips OTHER than 3384, remapping is only required on PCI (not UBUS or
> "rdb").  Notably, BCM7445, an ARM platform currently supported upstream,
> doesn't require dma-ranges for non-PCI devices.
> 
> I am hoping we can piggyback on top of the ARM dma-ranges code once it
> is merged.  This will allow for eliminating my dma.c.

Sounds good.

	Arnd

