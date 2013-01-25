Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab3AYQKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:10:22 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47919 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab3AYQKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:10:19 -0500
Date: Fri, 25 Jan 2013 08:10:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        KY Srinivasan <kys@microsoft.com>
Subject: Re: [PATCH] x86: Hyper-V: register clocksource only if its advertised
Message-ID: <20130125161016.GA9906@kroah.com>
References: <1359121036-16309-1-git-send-email-olaf@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359121036-16309-1-git-send-email-olaf@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 02:37:16PM +0100, Olaf Hering wrote:
> Enable hyperv_clocksource only if its advertised as a feature.
> XenServer 6 returns the signature which is checked in
> ms_hyperv_platform(), but it does not offer all features. Currently the
> clocksource is enabled unconditionally in ms_hyperv_init_platform(), and
> the result is a hanging guest.
> 
> Hyper-V spec Bit 1 indicates the availability of Partition Reference
> Counter.  Register the clocksource only if this bit is set.
> 
> The guest in question prints this in dmesg:
>  [    0.000000] Hypervisor detected: Microsoft HyperV
>  [    0.000000] HyperV: features 0x70, hints 0x0
> 
> This bug can be reproduced easily be setting 'viridian=1' in a HVM domU
> .cfg file. A workaround without this patch is to boot the HVM guest with
> 'clocksource=jiffies'.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> Cc: stable@kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> ---
>  arch/x86/kernel/cpu/mshyperv.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

This needs to go through the x86 maintainers, not me, sorry.

greg k-h
