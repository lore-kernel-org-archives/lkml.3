Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaHaTs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 15:48:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42356 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbaHaTsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 15:48:52 -0400
Message-ID: <54037C07.8060703@zytor.com>
Date: Sun, 31 Aug 2014 12:48:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghua.yu@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: early microcode: how to disable at runtime?
References: <20140809231911.GA4843@khazad-dum.debian.net> <20140831194548.GA12628@khazad-dum.debian.net>
In-Reply-To: <20140831194548.GA12628@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2014 12:45 PM, Henrique de Moraes Holschuh wrote:
> Currently, there is no way to disable early microcode update at runtime.  If
> an early initramfs with microcode update data is available, it will always
> be used.
> 
> This can be a very big deal when things go wrong: it is hard for the regular
> user to recover from an initramfs image that crashes the system, and the
> early initramfs has no "disable" trigger.
> 
> In the general case, booting from rescue media will be required to fix the
> system.
> 
> Unfortunately, the BSP microcode update is handled before early_param() is
> available, so a kernel command line parameter to disable early microcode
> updates for the BSP isn't easily possible.
> 
> Other than duplicating much of the code in parse_early_param/parse_args to
> search for a "noearlymcu" parameter, is there any other way we could add a
> disable switch for the early microcode update system?
> 

Probably more like something more like arch/x86/boot/cmdline.c.  Maybe
we could even make it sharable.

	-hpa


