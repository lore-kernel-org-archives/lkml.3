Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbaKSLHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 06:07:13 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:51361 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbaKSLHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 06:07:10 -0500
Date: Wed, 19 Nov 2014 13:06:54 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Johan Hedberg <johan.hedberg@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chan-yeol Park <chanyeol.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-11-07
Message-ID: <20141119110654.GA1894@node.dhcp.inet.fi>
References: <20141118133459.GB27428@node.dhcp.inet.fi>
 <20141118180919.GA32128@t440s.P-661HNU-F1>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20141118180919.GA32128@t440s.P-661HNU-F1>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 18, 2014 at 08:09:19PM +0200, Johan Hedberg wrote:
> Hi Kirill,
> 
> On Tue, Nov 18, 2014, Kirill A. Shutemov wrote:
> > On Fri, Nov 07, 2014 at 11:27:54AM +0200, Johan Hedberg wrote:
> > > Chan-yeol Park (1):
> > >       Bluetooth: Fix hci_sync missing wakeup interrupt
> > 
> > Look like this commit causes problem for me:
> > 
> > [    2.018671] ------------[ cut here ]------------
> > [    2.022836] WARNING: CPU: 2 PID: 109 at /home/kas/git/public/linux/kernel/sched/core.c:7323 __might_sleep+0xbd/0xd0()
> > [    2.023166] Freeing unused kernel memory: 944K (ffff880001b14000 - ffff880001c00000)
> > [    2.030362] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff819ab67b>] __hci_req_sync+0x7b/0x2a0
> > [    2.034193] Modules linked in:
> > [    2.036133] CPU: 2 PID: 109 Comm: kworker/u17:0 Not tainted 3.18.0-rc4-next-20141117-07404-g9dad2ab6df8b #66
> > [    2.036383] Freeing unused kernel memory: 1404K (ffff8800020a1000 - ffff880002200000)
> > [    2.038940] Hardware name: LENOVO 3460CC6/3460CC6, BIOS G6ET93WW (2.53 ) 02/04/2013
> > [    2.040233] Workqueue: hci0 hci_power_on
> > [    2.041517]  ffffffff81f51d50 ffff8800d3ecfb28 ffffffff81afc316 0000000000000000
> > [    2.042811]  ffff8800d3ecfb78 ffff8800d3ecfb68 ffffffff810fc11a ffff880000000000
> > [    2.042812]  ffffffff81f52a28 000000000000026d 0000000000000000 ffff8800d3ec9200
> > [    2.042813] Call Trace:
> > [    2.042818]  [<ffffffff81afc316>] dump_stack+0x4c/0x6e
> > [    2.042821]  [<ffffffff810fc11a>] warn_slowpath_common+0x8a/0xc0
> > [    2.042823]  [<ffffffff810fc196>] warn_slowpath_fmt+0x46/0x50
> > [    2.042825]  [<ffffffff819ab67b>] ? __hci_req_sync+0x7b/0x2a0
> > [    2.042827]  [<ffffffff819ab67b>] ? __hci_req_sync+0x7b/0x2a0
> > [    2.042830]  [<ffffffff811295ed>] __might_sleep+0xbd/0xd0
> > [    2.042832]  [<ffffffff81b04b8f>] mutex_lock_nested+0x2f/0x450
> > [    2.042835]  [<ffffffff81b0812b>] ? _raw_spin_unlock+0x2b/0x50
> > [    2.042837]  [<ffffffff81131db0>] ? wake_up_process+0x50/0x50
> > [    2.042840]  [<ffffffff813b9ea1>] __create_file+0x71/0x2c0
> > [    2.042842]  [<ffffffff813ba10f>] debugfs_create_file+0x1f/0x30
> > [    2.042844]  [<ffffffff819ac461>] hci_dev_do_open+0x431/0xa70
> > [    2.042846]  [<ffffffff8111a72c>] ? process_one_work+0x13c/0x810
> > [    2.042847]  [<ffffffff819ad2b1>] hci_power_on+0x31/0x1e0
> > [    2.042849]  [<ffffffff8111a7c8>] process_one_work+0x1d8/0x810
> > [    2.042850]  [<ffffffff8111a72c>] ? process_one_work+0x13c/0x810
> > [    2.042851]  [<ffffffff8111b2db>] worker_thread+0x6b/0x4b0
> > [    2.042852]  [<ffffffff8111b270>] ? init_pwq+0xf0/0xf0
> > [    2.042854]  [<ffffffff81120ef9>] kthread+0x119/0x130
> > [    2.042855]  [<ffffffff8112923d>] ? finish_task_switch+0x4d/0x140
> > [    2.042857]  [<ffffffff81120de0>] ? kthread_create_on_node+0x240/0x240
> > [    2.042859]  [<ffffffff81b08cfc>] ret_from_fork+0x7c/0xb0
> > [    2.042861]  [<ffffffff81120de0>] ? kthread_create_on_node+0x240/0x240
> > [    2.042863] ---[ end trace 3a40e80ec4ca7159 ]---
> 
> At least one obvious bug that the patch in question seems to have is
> that it fails to set the state back to TASK_RUNNING in case
> hci_req_run() fails and we never call schedule_timeout(). This would
> also seem to match the error you're getting.
> 
> The attached patch fixes the missing set_current_state() calls - could
> you please check if it fixes the issue for you? Out of curiosity, which
> HW are you reproducing this with and are there any special steps
> involved? Looking at the code it seems that at least some older
> Bluetooth adapters could cause some hci_req_run() calls to return
> ENODATA, however I wasn't able to get the warning with any of my own
> adapters (I have one for pretty much every Bluetooth version).
> 
> Johan

> From a75be9ae3c163db6a812330b5b50079891e1f7bd Mon Sep 17 00:00:00 2001
> From: Johan Hedberg <johan.hedberg@intel.com>
> Date: Tue, 18 Nov 2014 20:00:15 +0200
> Subject: [PATCH] Bluetooth: Fix setting state back to TASK_RUNNING
> 
> In __hci_cmd_sync_ev() and __hci_req_sync() if the hci_req_run() call
> fails and we return from the functions we should ensure that the state
> doesn't remain in TASK_INTERRUPTIBLE that we just set it to. This patch
> fixes missing calls to set_current_state(TASK_RUNNING) in both places.
> 
> Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>

This patch helps -- warning is gone.

Trace from btmon on 'hciconfig hci0 up' is attached.

-- 
 Kirill A. Shutemov

--9amGYk9869ThD9tj
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=trace
Content-Transfer-Encoding: base64

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

--9amGYk9869ThD9tj--
