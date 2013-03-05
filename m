Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3CEKfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:35:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:1573 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab3CEKfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:35:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,787,1355126400"; 
   d="scan'208";a="294991742"
Date: Tue, 5 Mar 2013 18:35:13 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/gadget: initialize gadget functions helper befor
 functions & gadgets
Message-ID: <20130305103513.GA31454@localhost>
References: <20130206020424.GB1175@localhost>
 <1362432489-6325-1-git-send-email-sebastian@breakpoint.cc>
 <20130305095734.GA30166@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130305095734.GA30166@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 05:57:34PM +0800, Fengguang Wu wrote:
> On Mon, Mar 04, 2013 at 10:28:09PM +0100, Sebastian Andrzej Siewior wrote:
> > Fengguang Wu run into a kernel ops after he complied dummy_hcd and g_cdc
> > into the kernel. The problem was that u_serial was used by g_cdc before
> > u_serial was initialized. In the module case eveything is initialized in
> > the correct order but if we compile it into the kernel we rely on
> > Makefile order which I did wrong and now I correct this.
> > 
> > Cc: Fengguang Wu <fengguang.wu@intel.com>
> > Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> 
> Tested-by: Fengguang Wu <fengguang.wu@intel.com>

Note that I still get this warning, however looks like an unrelated
issue:

[  602.536679] [ INFO: possible circular locking dependency detected ]
[  602.536672] 
[  602.536679] ======================================================
[  602.536679] [ INFO: possible circular locking dependency detected ]
[  602.536693] 3.8.0-bisect-next-20130301-dirty #212 Not tainted
[  602.536694] -------------------------------------------------------
[  602.536698] kworker/0:1/27 is trying to acquire lock:
[  602.536750]  (&fb_info->lock){+.+.+.}, at: [<ffffffff814c0176>] lock_fb_info+0x26/0x60
[  602.536751] 
[  602.536751] but task is already holding lock:
[  602.536773]  (console_lock){+.+.+.}, at: [<ffffffff815a6a13>] console_callback+0x13/0x150
[  602.536774]                 
[  602.536774] which lock already depends on the new lock.

Thanks,
Fengguang
