Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab3EMIhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:37:35 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:41514 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3EMIhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:37:34 -0400
MIME-Version: 1.0
In-Reply-To: <519013F3.5@infradead.org>
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg>
	<519013F3.5@infradead.org>
Date: Mon, 13 May 2013 10:37:32 +0200
X-Google-Sender-Auth: F-vsKc-Q8-2MQhcU0ZNxXNFCsxw
Message-ID: <CAMuHMdVJwdBnvVDaFwBkL=Qy8faZLWeFDSoPCq+WdFTd6C2Csw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.10-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Mon, May 13, 2013 at 12:13 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 05/12/13 12:30, Geert Uytterhoeven wrote:
>>
>> *** WARNINGS ***
>>
>> 163 regressions:
>>   + mm/slab_common.c: warning: format '%zu' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat]:  => 303:6
>
> How does this happen?  'size' is clearly a size_t in this function so "%zu" is correct.

v3.10-rc1/am33_2.0/asb2364_defconfig v3.10-rc1/am33_2.0/asb2303_defconfig

> Does some arch (or gcc) confuse these?

Yes, mn10300 and h8300 compilers tend to give false positives for them.

Since I know you like fixing these warnings ;-), here's the full remaining list
(ignoring mn10300 and h8300) for v3.10-rc1:

drivers/mtd/maps/solutionengine.c:86:9: warning: format '%lx' expects
argument of type 'long unsigned int', but argument 2 has type
'resource_size_t' [-Wformat]: 2 warnings in 2 logs
        v3.10-rc1/sh4/sh-allyesconfig v3.10-rc1/sh4/sh-allmodconfig
drivers/mtd/maps/solutionengine.c:86:9: warning: format '%lx' expects
argument of type 'long unsigned int', but argument 3 has type
'resource_size_t' [-Wformat]: 2 warnings in 2 logs
        v3.10-rc1/sh4/sh-allyesconfig v3.10-rc1/sh4/sh-allmodconfig
arch/xtensa/kernel/pci.c:82:11: warning: format '%ld' expects argument
of type 'long int', but argument 4 has type 'resource_size_t'
[-Wformat]: 1 warnings in 1 logs
        v3.10-rc1/xtensa/xtensa-allmodconfig
drivers/sh/superhyway/superhyway-sysfs.c:33:1: warning: format '%lx'
expects argument of type 'long unsigned int', but argument 3 has type
'resource_size_t' [-Wformat]: 1 warnings in 1 logs
        v3.10-rc1/sh4/microdev_defconfig

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
