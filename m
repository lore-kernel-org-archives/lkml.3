Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab3G3SCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:02:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62499 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab3G3SCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:02:34 -0400
Date: Tue, 30 Jul 2013 20:02:30 +0200
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        patches@linaro.org
Subject: Re: [PATCH 1/4] efi: provide a generic efi_config_init()
Message-ID: <20130730180230.GJ18151@rocoto.smurfnet.nu>
References: <1375202858-28470-1-git-send-email-leif.lindholm@linaro.org>
 <1375202858-28470-2-git-send-email-leif.lindholm@linaro.org>
 <CA+8MBbK5S3z+VQhhuT5WT7=7zYy=5zyvZEWfnfTfc1NxXBa=Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbK5S3z+VQhhuT5WT7=7zYy=5zyvZEWfnfTfc1NxXBa=Sg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 10:53:10AM -0700, Tony Luck wrote:
> On Tue, Jul 30, 2013 at 9:47 AM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> > +       /*
> > +        * Let's see what config tables the firmware passed to us.
> > +        */
> > +       config_tables = early_mememap(efi.systab->tables,
> > +                                      efi.systab->nr_tables * sz);
> 
> Breaks bisection on ia64 ... you use early_mememap() here, but don't
> define it on ia64 until patch 3/4.  So I get:

Ugh, OK.

So I guess the clean way to deal with that would be to make the
memremap definition a separate patch?

/
    Leif
