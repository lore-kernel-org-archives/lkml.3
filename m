Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751040AbaCGHcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 02:32:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:10672 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaCGHcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 02:32:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,606,1389772800"; 
   d="scan'208";a="495686987"
Message-ID: <531975F7.9070602@intel.com>
Date: Fri, 07 Mar 2014 15:32:07 +0800
From: "xinhui.pan" <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
        sarah.a.sharp@linux.intel.com, dan.j.williams@intel.com,
        burzalodowa@gmail.com, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] usb/core/hub.c: return immediately when hub_port_init
 hits timedout
References: <53196414.8090703@intel.com> <20140307064718.GA20065@kroah.com>
In-Reply-To: <20140307064718.GA20065@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



于 2014年03月07日 14:47, Greg KH 写道:
> On Fri, Mar 07, 2014 at 02:15:48PM +0800, xinhui.pan wrote:
>> From: "xinhui.pan" <xinhuiX.pan@intel.com>
> 
> I doubt your name as a "." in it, right?
> 

yes :)

>> some devices go crasy, we can't resume it even after reset.
> 
> I don't understand, what do you mean by this?  What exactly does a
> device do, and why does it do it?  And what happens?
> 

the device(modem) did not response.
below is the call trace.

[ 2950.647310] usb 1-1: reset high-speed USB device number 2 using ehci-intel-hsic
[ 2957.535127] usb 1-1: **** DPM device timeout ****
[ 2957.535153] ffff88003a1df930 0000000000000046 0000000000000001 ffff88003a1dffd8
[ 2957.535170] ffff88003a140000 ffff88003a1dffd8 ffff88003a1dffd8 ffffffff830cb440
[ 2957.535187] ffff88003a140000 ffffffff833964c0 ffff88003a1df960 000000010003e2df
[ 2957.535192] Call Trace:
[ 2957.535221] [<ffffffff82843289>] schedule+0x29/0x70
[ 2957.535237] [<ffffffff828404bb>] schedule_timeout+0x15b/0x300
[ 2957.535255] [<ffffffff8207d190>] ? __internal_add_timer+0x130/0x130
[ 2957.535271] [<ffffffff828423d7>] wait_for_completion_timeout+0xd7/0x120
[ 2957.535286] [<ffffffff820a3130>] ? try_to_wake_up+0x2d0/0x2d0
[ 2957.535303] [<ffffffff824f756e>] usb_start_wait_urb+0x7e/0x150
[ 2957.535318] [<ffffffff824f7872>] usb_control_msg+0xc2/0x100
[ 2957.535334] [<ffffffff824ed268>] hub_port_init+0x4d8/0xa90
[ 2957.535351] [<ffffffff824ed982>] usb_reset_and_verify_device+0x102/0x430
[ 2957.535364] [<ffffffff824f79bc>] ? usb_get_status+0x8c/0xb0
[ 2957.535379] [<ffffffff824f00d8>] usb_port_resume+0x408/0x660
[ 2957.535393] [<ffffffff82843289>] ? schedule+0x29/0x70
[ 2957.535406] [<ffffffff824ea1a0>] ? usb_dev_thaw+0x20/0x20
[ 2957.535419] [<ffffffff8250356e>] generic_resume+0x1e/0x50
[ 2957.535431] [<ffffffff820a11ad>] ? get_parent_ip+0xd/0x50
[ 2957.535445] [<ffffffff824f9ed5>] usb_resume_both+0x105/0x150
[ 2957.535458] [<ffffffff824facff>] usb_resume+0x1f/0xd0
[ 2957.535471] [<ffffffff824ea1a0>] ? usb_dev_thaw+0x20/0x20
[ 2957.535484] [<ffffffff824ea1b3>] usb_dev_resume+0x13/0x20
[ 2957.535499] [<ffffffff823fa86e>] dpm_run_callback+0x4e/0x80
[ 2957.535513] [<ffffffff823fb373>] device_resume+0xf3/0x260
[ 2957.535526] [<ffffffff823fa770>] ? dpm_wd_set+0x60/0x60
[ 2957.535541] [<ffffffff823fb4fd>] async_resume+0x1d/0x50
[ 2957.535555] [<ffffffff8209a439>] async_run_entry_fn+0x39/0x120
[ 2957.535572] [<ffffffff8208c767>] process_one_work+0x177/0x490
[ 2957.535585] [<ffffffff8208cef3>] worker_thread+0x123/0x380
[ 2957.535599] [<ffffffff8208cdd0>] ? rescuer_thread+0x310/0x310
[ 2957.535613] [<ffffffff82093a63>] kthread+0xd3/0xe0
[ 2957.535625] [<ffffffff820a11ad>] ? get_parent_ip+0xd/0x50
[ 2957.535642] [<ffffffff82093990>] ? kthread_create_on_node+0x110/0x110
[ 2957.535657] [<ffffffff8284a59c>] ret_from_fork+0x7c/0xb0
[ 2957.535672] [<ffffffff82093990>] ? kthread_create_on_node+0x110/0x110

the device can't resume during the kernel resume progress.
perhaps it has some issue to deal with and has to reset itself.
waiting for it to be completed seems wasting time.

>> This case will cause timeout again and again. What is worse, if there
>> is a watchdog, panic will be generated as timer expires.
> 
> A watchdog where?
> 

[ 2957.535526] [<ffffffff823fa770>] ? dpm_wd_set+0x60/0x60

I also doubt the use of watchdog. but we really know some not good devices make
the kernel in risk.

>> To prevent this, we just return -ENODEV immediately. Later it will be
>> re-enumerated.
> 
> What will cause it to be re-enumerated?
> 
> confused,
> 

after return, hub_port_logical_disconnect will be called.
to my knowledge it will re-enumerate if there actually is a device attached.

> greg k-h
> 

thanks :)
