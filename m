Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab3EBJ6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 05:58:06 -0400
Received: from mail.nanl.de ([217.115.11.12]:40112 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab3EBJ6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 05:58:04 -0400
MIME-Version: 1.0
In-Reply-To: <6623143.198271367486832742.JavaMail.weblogic@epml20>
References: <6623143.198271367486832742.JavaMail.weblogic@epml20>
From: Jonas Gorski <jogo@openwrt.org>
Date: Thu, 2 May 2013 11:57:35 +0200
Message-ID: <CAOiHx==2EGhRU9AwvkK_+9FpWpCDSHLsfwBnoK8_9UgWkLAXZA@mail.gmail.com>
Subject: Re: Re: [PATCH] MIPS: remove USB_EHCI_BIG_ENDIAN_{DESC,MMIO} depends
 on architecture symbol
To: eunb.song@samsung.com
Cc: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "florian@openwrt.org" <florian@openwrt.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 11:27 AM, EUNBONG SONG <eunb.song@samsung.com> wrote:
>
>>These are selects and don't prevent anyone else from also selecting
>> them. If you look at your referenced commit, you see it removed the
>>/depends/, not the selects. It actually added selects to several
>> platforms. Platforms are supposed to select them if they need them.
>
> Hello.
> Every time i config with arch/mips/configs/cavium_octeon_defconfig, the following warning messages
> are showed.
> warning: (MIPS_SEAD3 && PMC_MSP && CPU_CAVIUM_OCTEON) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB && USB_EHCI_HCD)
> warning: (MIPS_SEAD3 && PMC_MSP && CPU_CAVIUM_OCTEON) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB && USB_EHCI_HCD)
>
> And after applying this patch, the warning messages were disappeared.

But after this patch likely EHCI is also broken on these platforms.
The solution is to either guard the USB_EHCI_BIG_ENDIAN_MMIO/DESC
selects with if USB_EHCI_HCD etc, or make
USB_EHCI_BIG_ENDIAN_MMIO/DESC not depend on USB_EHCI_HCD etc.

As far as I can tell, USB_EHCI_BIG_ENDIAN_MMIO/DESC only have any
effect on the ehci_hcd code anyway, so removing the dependencies of
these symbols should be fine and without any side effects, thus allow
platforms/drivers to select them unconditionally.

Greg, what do you think?


Jonas
