Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3CVKoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:44:06 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:54483 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3CVKoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:44:04 -0400
Date: Fri, 22 Mar 2013 13:42:48 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [-next] fs/eventpoll.c:545 suspicious rcu_dereference_check() usage
Message-ID: <20130322104248.GA2589@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

got this with today's linux-next

[    3.163894] ===============================
[    3.163895] [ INFO: suspicious RCU usage. ]
[    3.163897] 3.9.0-rc3-next-20130322-dbg-dirty #1 Not tainted
[    3.163898] -------------------------------
[    3.163900] fs/eventpoll.c:545 suspicious rcu_dereference_check() usage!
[    3.163900] other info that might help us debug this:
[    3.163902] rcu_scheduler_active = 1, debug_locks = 1
[    3.163903] 2 locks held by ata_id/763:
[    3.163915]  #0:  (&pipe->wait){......}, at: [<ffffffff810757a7>] __wake_up_sync_key+0x37/0x80
[    3.163923]  #1:  (&(&ep->lock)->rlock){......}, at: [<ffffffff811bb4a9>] ep_poll_callback+0x59/0x1f0
[    3.163924] 	stack backtrace:
[    3.163927] Pid: 763, comm: ata_id Not tainted 3.9.0-rc3-next-20130322-dbg-dirty #1
[    3.163929] Call Trace:
[    3.163940]  [<ffffffff810a7c66>] lockdep_rcu_suspicious+0xe6/0x130
[    3.163945]  [<ffffffff811bb61f>] ep_poll_callback+0x1cf/0x1f0
[    3.163949]  [<ffffffff81074765>] __wake_up_common+0x55/0x90
[    3.163952]  [<ffffffff810757c3>] __wake_up_sync_key+0x53/0x80
[    3.163957]  [<ffffffff811775f8>] pipe_write+0x448/0x590
[    3.163962]  [<ffffffff8116df70>] do_sync_write+0x80/0xb0
[    3.163965]  [<ffffffff8116e938>] vfs_write+0xa8/0x180
[    3.163968]  [<ffffffff8116ec95>] SyS_write+0x55/0xb0
[    3.163975]  [<ffffffff81620506>] system_call_fastpath+0x1a/0x1f



	-ss
