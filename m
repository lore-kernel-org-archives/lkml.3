Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbaKRNfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:35:20 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:36088 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595AbaKRNfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:35:18 -0500
Date: Tue, 18 Nov 2014 15:34:59 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chan-yeol Park <chanyeol.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Johan Hedberg <johan.hedberg@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-11-07
Message-ID: <20141118133459.GB27428@node.dhcp.inet.fi>
References: <20141107092754.GA6995@t440s.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107092754.GA6995@t440s.lan>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 11:27:54AM +0200, Johan Hedberg wrote:
> Chan-yeol Park (1):
>       Bluetooth: Fix hci_sync missing wakeup interrupt

Look like this commit causes problem for me:

[    2.018671] ------------[ cut here ]------------
[    2.022836] WARNING: CPU: 2 PID: 109 at /home/kas/git/public/linux/kernel/sched/core.c:7323 __might_sleep+0xbd/0xd0()
[    2.023166] Freeing unused kernel memory: 944K (ffff880001b14000 - ffff880001c00000)
[    2.030362] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff819ab67b>] __hci_req_sync+0x7b/0x2a0
[    2.034193] Modules linked in:
[    2.036133] CPU: 2 PID: 109 Comm: kworker/u17:0 Not tainted 3.18.0-rc4-next-20141117-07404-g9dad2ab6df8b #66
[    2.036383] Freeing unused kernel memory: 1404K (ffff8800020a1000 - ffff880002200000)
[    2.038940] Hardware name: LENOVO 3460CC6/3460CC6, BIOS G6ET93WW (2.53 ) 02/04/2013
[    2.040233] Workqueue: hci0 hci_power_on
[    2.041517]  ffffffff81f51d50 ffff8800d3ecfb28 ffffffff81afc316 0000000000000000
[    2.042811]  ffff8800d3ecfb78 ffff8800d3ecfb68 ffffffff810fc11a ffff880000000000
[    2.042812]  ffffffff81f52a28 000000000000026d 0000000000000000 ffff8800d3ec9200
[    2.042813] Call Trace:
[    2.042818]  [<ffffffff81afc316>] dump_stack+0x4c/0x6e
[    2.042821]  [<ffffffff810fc11a>] warn_slowpath_common+0x8a/0xc0
[    2.042823]  [<ffffffff810fc196>] warn_slowpath_fmt+0x46/0x50
[    2.042825]  [<ffffffff819ab67b>] ? __hci_req_sync+0x7b/0x2a0
[    2.042827]  [<ffffffff819ab67b>] ? __hci_req_sync+0x7b/0x2a0
[    2.042830]  [<ffffffff811295ed>] __might_sleep+0xbd/0xd0
[    2.042832]  [<ffffffff81b04b8f>] mutex_lock_nested+0x2f/0x450
[    2.042835]  [<ffffffff81b0812b>] ? _raw_spin_unlock+0x2b/0x50
[    2.042837]  [<ffffffff81131db0>] ? wake_up_process+0x50/0x50
[    2.042840]  [<ffffffff813b9ea1>] __create_file+0x71/0x2c0
[    2.042842]  [<ffffffff813ba10f>] debugfs_create_file+0x1f/0x30
[    2.042844]  [<ffffffff819ac461>] hci_dev_do_open+0x431/0xa70
[    2.042846]  [<ffffffff8111a72c>] ? process_one_work+0x13c/0x810
[    2.042847]  [<ffffffff819ad2b1>] hci_power_on+0x31/0x1e0
[    2.042849]  [<ffffffff8111a7c8>] process_one_work+0x1d8/0x810
[    2.042850]  [<ffffffff8111a72c>] ? process_one_work+0x13c/0x810
[    2.042851]  [<ffffffff8111b2db>] worker_thread+0x6b/0x4b0
[    2.042852]  [<ffffffff8111b270>] ? init_pwq+0xf0/0xf0
[    2.042854]  [<ffffffff81120ef9>] kthread+0x119/0x130
[    2.042855]  [<ffffffff8112923d>] ? finish_task_switch+0x4d/0x140
[    2.042857]  [<ffffffff81120de0>] ? kthread_create_on_node+0x240/0x240
[    2.042859]  [<ffffffff81b08cfc>] ret_from_fork+0x7c/0xb0
[    2.042861]  [<ffffffff81120de0>] ? kthread_create_on_node+0x240/0x240
[    2.042863] ---[ end trace 3a40e80ec4ca7159 ]---

-- 
 Kirill A. Shutemov
