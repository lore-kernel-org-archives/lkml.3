Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3AORoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 12:44:46 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:54995 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab3AORop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 12:44:45 -0500
Message-ID: <1358271907.31593.1.camel@gitbox>
Subject: Re: [PATCH v2] mtd: vt8500: Add support for Wondermedia Serial
 Flash Controller
From: Tony Prisk <linux@prisktech.co.nz>
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 16 Jan 2013 06:45:07 +1300
In-Reply-To: <1358261750.2731.148.camel@sauron.fi.intel.com>
References: <1356901207-13536-1-git-send-email-linux@prisktech.co.nz>
	 <1358261750.2731.148.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-15 at 16:55 +0200, Artem Bityutskiy wrote:
> On Mon, 2012-12-31 at 10:00 +1300, Tony Prisk wrote:
> > This patch adds support for the Wondermedia serial flash controller
> > found on WM8505, WM8650 and WM8850 SoCs.
> > 
> > Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> > ---
> > v2: Whitespace tidyup
> 
> Hi, would you please take a look at these warings, identified by aiaiai:
> 
> Successfully built configuration "x86_64_defconfig,x86_64,", results:
> 
> --- before_patching.log
> +++ after_patching.log
> @@ @@
> +drivers/mtd/devices/wmt_sflash.c: In function ‘sf_read’:
> +drivers/mtd/devices/wmt_sflash.c:425:9: warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘size_t’ [-Wformat]
> +drivers/mtd/devices/wmt_sflash.c: In function ‘sf_sector_write’:
> +drivers/mtd/devices/wmt_sflash.c:442:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> +drivers/mtd/devices/wmt_sflash.c:442:24: warning: cast removes address space of expression [sparse]
> +drivers/mtd/devices/wmt_sflash.c:458:16: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> +drivers/mtd/devices/wmt_sflash.c:458:31: warning: incorrect type in argument 1 (different address spaces) [sparse]
> +drivers/mtd/devices/wmt_sflash.c:458:31:    expected void volatile [noderef] <asn:2>*dst [sparse]
> +drivers/mtd/devices/wmt_sflash.c:458:31:    got unsigned char [usertype] *<noident> [sparse]
> +drivers/mtd/devices/wmt_sflash.c:465:17: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> +drivers/mtd/devices/wmt_sflash.c:465:39: warning: incorrect type in argument 1 (different address spaces) [sparse]
> +drivers/mtd/devices/wmt_sflash.c:465:39:    expected void volatile [noderef] <asn:2>*dst [sparse]
> +drivers/mtd/devices/wmt_sflash.c:465:39:    got unsigned char [usertype] *<noident> [sparse]
> 

Apologies - This driver shouldn't be selectable for x86_64.
It is an ARM driver for an embedded device. Will fix.

Regards
Tony P

