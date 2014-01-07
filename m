Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaAGRfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:35:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34541 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbaAGRfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:35:03 -0500
Date: Tue, 7 Jan 2014 18:19:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/6] edac: Don't try to cancel workqueue when it's
 never setup
Message-ID: <20140107171955.GA4164@pd.tnic>
References: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org>
 <1388434457-4194-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1388434457-4194-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 12:14:12PM -0800, Stephen Boyd wrote:
> We only setup a workqueue for edac devices that use the polling
> method. We still try to cancel the workqueue if an edac_device
> uses the irq method though. This causes a warning from debug
> objects when we remove an edac device:
> 
> WARNING: CPU: 0 PID: 56 at lib/debugobjects.c:260 debug_print_object+0x98/0xc0()
> ODEBUG: assert_init not available (active state 0) object type: timer_list hint: stub_timer+0x0/0x28
> Modules linked in: krait_edac(-)
> CPU: 0 PID: 56 Comm: rmmod Not tainted 3.12.0-rc2-00035-g15292a0 #69
> (unwind_backtrace+0x0/0x144)
> (show_stack+0x20/0x24)
> (dump_stack+0x74/0xb4)
> (warn_slowpath_common+0x78/0x9c)
> (warn_slowpath_fmt+0x40/0x48)
> (debug_print_object+0x98/0xc0)
> (debug_object_assert_init+0xdc/0xec)
> (del_timer+0x24/0x7c)
> (try_to_grab_pending+0xc0/0x1b0)
> (cancel_delayed_work+0x2c/0xa0)
> (edac_device_workq_teardown+0x1c/0x38)
> (edac_device_del_device+0xb8/0xe4)
> (krait_edac_remove+0x50/0x70 [krait_edac])
> (platform_drv_remove+0x24/0x28)
> (__device_release_driver+0x68/0xc0)
> (driver_detach+0xc4/0xc8)
> (bus_remove_driver+0xac/0x114)
> (driver_unregister+0x38/0x58)
> (platform_driver_unregister+0x1c/0x20)
> (krait_edac_driver_exit+0x14/0x1c [krait_edac])
> (SyS_delete_module+0x178/0x2b4)
> 
> Fix it by skipping the workqueue teardown for such devices.
> 
> Acked-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
