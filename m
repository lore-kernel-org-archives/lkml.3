Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab3LTKlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:41:18 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:34499 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186Ab3LTKlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:41:15 -0500
Message-ID: <52B41EC7.1070704@compulab.co.il>
Date: Fri, 20 Dec 2013 12:41:11 +0200
From: Denis Turischev <denis.turischev@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v1] xhci: Switch Intel Lynx Point ports to EHCI on shutdown
References: <52B31EDA.60908@compulab.co.il> <52B327D5.3080805@compulab.co.il> <20131219182110.GC3573@xanatos>
In-Reply-To: <20131219182110.GC3573@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: -unknown-@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, which kernel are you experiencing this issue on?  In 3.12, I
> queued a separate patch to deal with spurious reboot issues on Lynx
> Point:
> 
> commit 638298dc66ea36623dbc2757a24fc2c4ab41b016
> Author: Takashi Iwai <tiwai@suse.de>
> Date:   Thu Sep 12 08:11:06 2013 +0200
> 
>     xhci: Fix spurious wakeups after S5 on Haswell
>     
>     Haswell LynxPoint and LynxPoint-LP with the recent Intel BIOS show
>     mysterious wakeups after shutdown occasionally.  After discussing with
>     BIOS engineers, they explained that the new BIOS expects that the
>     wakeup sources are cleared and set to D3 for all wakeup devices when
>     the system is going to sleep or power off, but the current xhci driver
>     doesn't do this properly (partly intentionally).
>     
>     This patch introduces a new quirk, XHCI_SPURIOUS_WAKEUP, for
>     fixing the spurious wakeups at S5 by calling xhci_reset() in the xhci
>     shutdown ops as done in xhci_stop(), and setting the device to PCI D3
>     at shutdown and remove ops.
>     
>     The PCI D3 call is based on the initial fix patch by Oliver Neukum.
>     
>     [Note: Sarah changed the quirk name from XHCI_HSW_SPURIOUS_WAKEUP to
>     XHCI_SPURIOUS_WAKEUP, since none of the other quirks have system names
>     in them.  Sarah also fixed a collision with a quirk submitted around the
>     same time, by changing the xhci->quirks bit from 17 to 18.]
>     
>     This patch should be backported to kernels as old as 3.0, that
>     contain the commit 1c12443ab8eba71a658fae4572147e56d1f84f66 "xhci: Add
>     Lynx Point to list of Intel switchable hosts."
>     
>     Cc: Oliver Neukum <oneukum@suse.de>
>     Signed-off-by: Takashi Iwai <tiwai@suse.de>
>     Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
>     Cc: stable@vger.kernel.org
> 
> This patch is in 3.12, but a patch to narrow the quirk to only apply HP systems
> will hit 3.13 shortly:

Sorry, I indeed tested not on the latest kernel version, Ubuntu 3.13-rc3 has this patch and it works
for me.

Denis

