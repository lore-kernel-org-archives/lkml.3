Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbaHEQPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:15:33 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:39279 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaHEQPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:15:32 -0400
MIME-Version: 1.0
In-Reply-To: <1407233482-11642-2-git-send-email-rogerq@ti.com>
References: <1407233482-11642-1-git-send-email-rogerq@ti.com>
	<1407233482-11642-2-git-send-email-rogerq@ti.com>
Date: Tue, 5 Aug 2014 19:15:31 +0300
Message-ID: <CANOLnOM-Q4b8N5T522Vc_gXTSj2C-mxV6GV0hRTDPscpPgXO6A@mail.gmail.com>
Subject: Re: [PATCH 1/3] mtd: nand: omap: Revert to using software ECC by default
From: Grazvydas Ignotas <notasas@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        pekon.gupta@gmail.com, artem.bityutskiy@linux.intel.com,
        dwmw2@infradead.org, jg1.han@samsung.com,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 1:11 PM, Roger Quadros <rogerq@ti.com> wrote:
> For v3.12 and prior, 1-bit Hamming code ECC via software was the
> default choice. Commit c66d039197e4 in v3.13 changed the behaviour
> to use 1-bit Hamming code via Hardware using a different ECC layout
> i.e. (ROM code layout) than what is used by software ECC.
>
> This ECC layout change causes NAND filesystems created in v3.12
> and prior to be unusable in v3.13 and later. So revert back to
> using software ECC by default if an ECC scheme is not explicitely
> specified.
>
> This defect can be observed on the following boards during legacy boot
>
> -omap3beagle
> -omap3touchbook
> -overo
> -am3517crane
> -devkit8000
> -ldp
> -3430sdp

omap3pandora is also using sw ecc, with ubifs. Some time ago I tried
booting mainline (I think it was 3.14) with rootfs on NAND, and while
it did boot and reached a shell, there were lots of ubifs errors, fs
got corrupted and I lost all my data. I used to be able to boot
mainline this way fine sometime ~3.8 release. It's interesting that
3.14 was able to read the data, even with wrong ecc setup.

Do you think it's safe again to boot ubifs created on 3.2 after
applying this series?

-- 
Gražvydas
