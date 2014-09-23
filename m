Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaIWCuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:50:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaIWCuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:50:01 -0400
Date: Mon, 22 Sep 2014 22:49:47 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: axboe@kernel.dk
Subject: sleeping while atomic in blk_free_devt
Message-ID: <20140923024947.GA4760@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, axboe@kernel.dk
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just got this when removing a USB memory stick.

BUG: sleeping function called from invalid context at block/genhd.c:448
in_atomic(): 1, irqs_disabled(): 0, pid: 13, name: rcuop/3
1 lock held by rcuop/3/13:
 #0:  (rcu_callback){......}, at: [<ffffffffa80f4270>] rcu_nocb_kthread+0x260/0x1070
Preemption disabled at:[<ffffffffa83a99ef>] debug_object_deactivate+0x8f/0x160

CPU: 1 PID: 13 Comm: rcuop/3 Not tainted 3.17.0-rc6+ #55 
 ffffffffa8c980f7 00000000325b7c43 ffff8802430b7c80 ffffffffa8819400
 0000000000000000 ffff8802430b7ca8 ffffffffa80a8be3 0000000000800011
 ffff88023d8a4150 ffff8800a08d0920 ffff8802430b7cc0 ffffffffa8370b2f
Call Trace:
 [<ffffffffa8819400>] dump_stack+0x4e/0x7a
 [<ffffffffa80a8be3>] __might_sleep+0x1a3/0x290
 [<ffffffffa8370b2f>] blk_free_devt+0x1f/0x70
 [<ffffffffa83725f8>] part_release+0x18/0x40
 [<ffffffffa8569342>] device_release+0x32/0xa0
 [<ffffffffa838f36a>] kobject_release+0x7a/0x1c0
 [<ffffffffa838f21d>] kobject_put+0x2d/0x60
 [<ffffffffa85696a7>] put_device+0x17/0x20
 [<ffffffffa83727f4>] delete_partition_rcu_cb+0xc4/0xd0
 [<ffffffffa8372730>] ? read_dev_sector+0xa0/0xa0
 [<ffffffffa80f474f>] rcu_nocb_kthread+0x73f/0x1070
 [<ffffffffa80f4270>] ? rcu_nocb_kthread+0x260/0x1070
 [<ffffffffa881c8b6>] ? __schedule+0x3a6/0xc30
 [<ffffffffa80c99a0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffffa80f4010>] ? rcu_read_unlock_special.part.61+0x510/0x510
 [<ffffffffa80a1aa8>] kthread+0x108/0x120
 [<ffffffffa83a8c67>] ? debug_smp_processor_id+0x17/0x20
 [<ffffffffa80a19a0>] ? kthread_create_on_node+0x250/0x250
 [<ffffffffa882426c>] ret_from_fork+0x7c/0xb0
 [<ffffffffa80a19a0>] ? kthread_create_on_node+0x250/0x250

