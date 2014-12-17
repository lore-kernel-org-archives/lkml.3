Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaLQIPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:15:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbaLQIPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:15:40 -0500
Date: Wed, 17 Dec 2014 09:15:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        aduggan@synaptics.com
Subject: Re: [PATCH] HID: i2c-hid: Do not free buffers in i2c_hid_stop()
In-Reply-To: <1418385709-223977-1-git-send-email-mika.westerberg@linux.intel.com>
Message-ID: <alpine.LNX.2.00.1412170915120.1680@pobox.suse.cz>
References: <1418385709-223977-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2014, Mika Westerberg wrote:

> When a hid driver that uses i2c-hid as transport is unloaded, the hid core
> will call i2c_hid_stop() which releases all the buffers associated with the
> device. This includes also the command buffer.
> 
> Now, when the i2c-hid driver itself is unloaded it tries to power down the
> device by sending it PWR_SLEEP command. Since the command buffer is already
> released we get following crash:
> 
>  [   79.691459] BUG: unable to handle kernel NULL pointer dereference at           (null)
>  [   79.691532] IP: [<ffffffffa05bc049>] __i2c_hid_command+0x49/0x310 [i2c_hid]
>  ...
>  [   79.693467] Call Trace:
>  [   79.693494]  [<ffffffff810424e1>] ? __unmask_ioapic+0x21/0x30
>  [   79.693537]  [<ffffffff81042855>] ? unmask_ioapic+0x25/0x40
>  [   79.693581]  [<ffffffffa05bc35b>] ? i2c_hid_set_power+0x4b/0xa0 [i2c_hid]
>  [   79.693632]  [<ffffffffa05bc3cf>] ? i2c_hid_runtime_resume+0x1f/0x30 [i2c_hid]
>  [   79.693689]  [<ffffffff814c08fb>] ? __rpm_callback+0x2b/0x70
>  [   79.693733]  [<ffffffff814c0961>] ? rpm_callback+0x21/0x90
>  [   79.693776]  [<ffffffff814c0dec>] ? rpm_resume+0x41c/0x600
>  [   79.693820]  [<ffffffff814c1e1c>] ? __pm_runtime_resume+0x4c/0x80
>  [   79.693868]  [<ffffffff814b8588>] ? __device_release_driver+0x28/0x100
>  [   79.693917]  [<ffffffff814b8d90>] ? driver_detach+0xa0/0xb0
>  [   79.693959]  [<ffffffff814b82cc>] ? bus_remove_driver+0x4c/0xb0
>  [   79.694006]  [<ffffffff810d1cfd>] ? SyS_delete_module+0x11d/0x1d0
>  [   79.694054]  [<ffffffff8165f107>] ? int_signal+0x12/0x17
>  [   79.694095]  [<ffffffff8165ee69>] ? system_call_fastpath+0x12/0x17
> 
> Fix this so that we only free buffers when the i2c-hid driver itself is
> removed.

Applied to for-3.19/upstream-fixes, thanks for fixing it.

-- 
Jiri Kosina
SUSE Labs
