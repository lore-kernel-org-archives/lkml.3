Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934480Ab3BSTAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:00:52 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:52283 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933525Ab3BSSxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:53:54 -0500
MIME-Version: 1.0
In-Reply-To: <5123C5A5.4000106@suse.cz>
References: <5123C5A5.4000106@suse.cz>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 19 Feb 2013 11:53:34 -0700
Message-ID: <CAErSpo4MBSAt=oD=TajZXHXCwm12rrJswiVCyW2+On9NfmrkPg@mail.gmail.com>
Subject: Re: WARNING: at drivers/pci/pci.c:1397 pci_disable_device
To: Jiri Slaby <jslaby@suse.cz>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 11:34 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> Hi,
>
> so I hit that one:
> +       dev_WARN_ONCE(&dev->dev, atomic_read(&dev->enable_cnt) <= 0,
> +                     "disabling already-disabled device");
>
> during suspend (to ram):
> WARNING: at drivers/pci/pci.c:1397 pci_disable_device+0x90/0xa0()
> Hardware name: To Be Filled By O.E.M.
> Device e1000e
> disabling already-disabled device
> Modules linked in: dvb_usb_dib0700 dib0090 dib7000p dib7000m dib0070
> dib8000 dib3000mc dibx000_common microcode
> Pid: 31027, comm: kworker/u:35 Not tainted 3.8.0-rc7-next-20130218_64+ #1768
> Call Trace:
>  [<ffffffff81313b00>] ? do_pci_disable_device+0x30/0x60
>  [<ffffffff8107f2ff>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff8107f3f6>] warn_slowpath_fmt+0x46/0x50
>  [<ffffffff81313bc0>] pci_disable_device+0x90/0xa0
>  [<ffffffff814c8152>] __e1000_shutdown+0x262/0x8b0
>  [<ffffffff814c8813>] e1000_suspend+0x23/0x50
>  [<ffffffff816be581>] ? wait_for_completion+0x31/0x100
>  [<ffffffff81316337>] pci_pm_suspend+0x77/0x140
>  [<ffffffff8144aa6a>] ? __pm_runtime_barrier+0x1a/0x130
>  [<ffffffff813162c0>] ? pci_pm_poweroff+0xf0/0xf0
>  [<ffffffff81447838>] dpm_run_callback+0x58/0x90
>  [<ffffffff8144795b>] __device_suspend+0xeb/0x280
>  [<ffffffff814482af>] async_suspend+0x1f/0xa0
>  [<ffffffff810a9c9b>] async_run_entry_fn+0x3b/0x140
>  [<ffffffff8109b9a4>] process_one_work+0x174/0x410
>  [<ffffffff8109d426>] worker_thread+0x116/0x400
>  [<ffffffff8109d310>] ? busy_worker_rebind_fn+0xc0/0xc0
>  [<ffffffff810a3340>] kthread+0xc0/0xd0
>  [<ffffffff810a3280>] ? kthread_create_on_node+0x130/0x130
>  [<ffffffff816c089c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff810a3280>] ? kthread_create_on_node+0x130/0x130
> ---[ end trace 6c5060f8b8fb9175 ]---
> e1000e 0000:00:19.0: System wakeup enabled by ACPI

I think Konstantin posted an e1000e patch that would fix this, but
it's going via the e1000e folks.  Hopefully both my tree and the
e1000e patch will be merged soon.

Bjorn
