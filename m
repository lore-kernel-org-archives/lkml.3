Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab3G3RxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 13:53:14 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:44237 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab3G3RxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 13:53:11 -0400
MIME-Version: 1.0
In-Reply-To: <1375202858-28470-2-git-send-email-leif.lindholm@linaro.org>
References: <1375202858-28470-1-git-send-email-leif.lindholm@linaro.org>
	<1375202858-28470-2-git-send-email-leif.lindholm@linaro.org>
Date: Tue, 30 Jul 2013 10:53:10 -0700
Message-ID: <CA+8MBbK5S3z+VQhhuT5WT7=7zYy=5zyvZEWfnfTfc1NxXBa=Sg@mail.gmail.com>
Subject: Re: [PATCH 1/4] efi: provide a generic efi_config_init()
From: Tony Luck <tony.luck@gmail.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 9:47 AM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> +       /*
> +        * Let's see what config tables the firmware passed to us.
> +        */
> +       config_tables = early_mememap(efi.systab->tables,
> +                                      efi.systab->nr_tables * sz);

Breaks bisection on ia64 ... you use early_mememap() here, but don't
define it on ia64 until patch 3/4.  So I get:

drivers/firmware/efi/efi.c: In function 'efi_config_init':
drivers/firmware/efi/efi.c:200: error: implicit declaration of
function 'early_memremap'
drivers/firmware/efi/efi.c:201: warning: assignment makes pointer from
integer without a cast

-Tony
