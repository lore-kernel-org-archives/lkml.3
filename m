Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab3KGEh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:37:29 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:37120 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3KGEh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:37:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAFRkauAdR3=ByE0_B3OsqOBjmbz2a02EXb+6g-vn=1TJ7AZc8Q@mail.gmail.com>
References: <1383789208.5970.1.camel@phoenix>
	<CACVXFVMn6RSXchQ8u47F35_J+YSnp1bwF1tr-8uCEYwvFsOfgQ@mail.gmail.com>
	<CAFRkauAEt-YhBt11opj_GVCLrxGsTSd2LowWGmukTSmGuJkd3A@mail.gmail.com>
	<CACVXFVO=QA-R1+twCL9fc_3vASg6Ap-3ezi=tU1MV1pdPYrfWw@mail.gmail.com>
	<CAFRkauAdR3=ByE0_B3OsqOBjmbz2a02EXb+6g-vn=1TJ7AZc8Q@mail.gmail.com>
Date: Thu, 7 Nov 2013 12:37:27 +0800
Message-ID: <CACVXFVMaLOfDvzdn_1NryQY59cgtLdMMqHL-_ZAa95MPz4p56Q@mail.gmail.com>
Subject: Re: kernel BUG at kernel/kallsyms.c:222!
From: Ming Lei <tom.leiming@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 7, 2013 at 10:47 AM, Axel Lin <axel.lin@ingics.com> wrote:
>
> hi Ming,
> Seems CONFIG_PAGE_OFFSET is not configurabe in "make menuconfig".
> And I found CONFIG_PAGE_OFFSET=0xC0000000 for all below configs...
> $ make at91_dt_defconfig; grep  CONFIG_PAGE_OFFSET .config
> $ make ep93xx_defconfig; grep  CONFIG_PAGE_OFFSET .config
> $ make imx_v4_v5_defconfig; grep CONFIG_PAGE_OFFSET .config
> $ make mxs_defconfig; grep CONFIG_PAGE_OFFSET .config
> $ make omap2plus_defconfig; grep CONFIG_PAGE_OFFSET .config
> $ make s3c6400_defconfig; grep CONFIG_PAGE_OFFSET .config
> $ make at91x40_defconfig; grep CONFIG_PAGE_OFFSET .config
> ( at91x40_defconfig is also arm7tdmi )

Firstly it can be configured via VMSPLIT_3GVMSPLIT_2G/VMSPLIT_1G.

Secondly, configurable or not isn't the point, and maybe some uclinux
platforms do not use CONFIG_PAGE_OFFSET at all, but they should
set it as a reasonable value or at least be below than the start link
address of vmlinux.


Thanks,
-- 
Ming Lei
