Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab3GLCTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 22:19:20 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:33085 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab3GLCTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 22:19:18 -0400
MIME-Version: 1.0
In-Reply-To: <51D9EAF3.4050804@tlinx.org>
References: <51D9EAF3.4050804@tlinx.org>
Date: Fri, 12 Jul 2013 10:19:17 +0800
Message-ID: <CACVXFVPRwakzB6vtqRqL49StHKdugCpxDyNvx3VzcDC7GggFMQ@mail.gmail.com>
Subject: Re: BUG: key ffff880c1148c478 not in .data! (V3.10.0)
From: Ming Lei <tom.leiming@gmail.com>
To: Linda Walsh <lkml@tlinx.org>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 8, 2013 at 6:25 AM, Linda Walsh <lkml@tlinx.org> wrote:
> Also am seeing this for the first time:
>
> (don't know, but seems unlikely to be related to
> https://patchwork.kernel.org/patch/87359/
> Yet it is the only hit I found for the same message.
>
>
> Looks like it's back to a more stable 3.9.8...
> (*sigh*)
>
>
> BUG: key ffff880c1148c478 not in .data!
> [    4.429474] ------------[ cut here ]------------
> [    4.434236] WARNING: at kernel/lockdep.c:2987
> lockdep_init_map+0x45e/0x490()
> [    4.441414] DEBUG_LOCKS_WARN_ON(1)
> [    4.444684] Modules linked in:
> [    4.448168] usb 1-3.2: new low-speed USB device number 3 using ehci-pci
> [    4.454975] CPU: 10 PID: 1 Comm: swapper/0 Tainted: G          I
> 3.10.0-Isht-Van #1
> [    4.462862] Hardware name: Dell Inc. PowerEdge T610/0CX0R0, BIOS 6.3.0
> 07/24/2012
> [    4.470475]  0000000000000009 ffff880c13175a70 ffffffff815bb279
> ffff880c13175aa8
> [    4.478221]  ffffffff8104641c ffff880c11c12130 ffff880c1148c478
> 0000000000000000
> [    4.485988]  ffff880c11c12058 ffff880c12386180 ffff880c13175b08
> ffffffff81046487
> [    4.493800] Call Trace:
> [    4.496472]  [<ffffffff815bb279>] dump_stack+0x19/0x1b
> [    4.501776]  [<ffffffff8104641c>] warn_slowpath_common+0x5c/0x80
> [    4.507917]  [<ffffffff81046487>] warn_slowpath_fmt+0x47/0x50
> [    4.513790]  [<ffffffff8109c1fe>] lockdep_init_map+0x45e/0x490
> [    4.519775]  [<ffffffff8109b12d>] debug_mutex_init+0x2d/0x40
> [    4.525567]  [<ffffffff8106ef61>] __mutex_init+0x51/0x60
> [    4.531017]  [<ffffffff813a1618>] bus_register+0x158/0x2c0
> [    4.536646]  [<ffffffff814c6dc3>] edac_create_sysfs_mci_device+0x53/0x540

Looks because that bus_type of 'struct mem_ctl_info' is allocated dynamically
instead of being kept it in .data statically.

Thanks,
-- 
Ming Lei
