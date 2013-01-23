Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab3AWU7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 15:59:37 -0500
Received: from fold.natur.cuni.cz ([195.113.57.32]:48568 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751167Ab3AWU72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 15:59:28 -0500
Message-ID: <51004F2D.9000405@fold.natur.cuni.cz>
Date: Wed, 23 Jan 2013 21:59:25 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0 SeaMonkey/2.14.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Vlad Yasevich <vyasevich@gmail.com>,
        Sridhar Samudrala <sri@us.ibm.com>, linux-sctp@vger.kernel.org
Subject: linux-3.7.4: kmemleak in sctp_sysctl_net_register()?
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  today I got the following report from the kernel, looks it happened when
I started/used/quit chromium browser. I haven't seen this with 3.7.1 but
I use builtin kmemleak detector only for 2-3 weeks.

unreferenced object 0xffff880402d08000 (size 2048):
  comm "chrome_sandbox", pid 18437, jiffies 4310887172 (age 9097.630s)
  hex dump (first 32 bytes):
    b2 68 89 81 ff ff ff ff 20 04 04 f8 01 88 ff ff  .h...... .......
    04 00 00 00 a4 01 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff815b4aad>] kmemleak_alloc+0x21/0x3e
    [<ffffffff81110352>] slab_post_alloc_hook+0x28/0x2a
    [<ffffffff81113fad>] __kmalloc_track_caller+0xf1/0x104
    [<ffffffff810f10c2>] kmemdup+0x1b/0x30
    [<ffffffff81571e9f>] sctp_sysctl_net_register+0x1f/0x72
    [<ffffffff8155d305>] sctp_net_init+0x100/0x39f
    [<ffffffff814ad53c>] ops_init+0xc6/0xf5
    [<ffffffff814ad5b7>] setup_net+0x4c/0xd0
    [<ffffffff814ada5e>] copy_net_ns+0x6d/0xd6
    [<ffffffff810938b1>] create_new_namespaces+0xd7/0x147
    [<ffffffff810939f4>] copy_namespaces+0x63/0x99
    [<ffffffff81076733>] copy_process+0xa65/0x1233
    [<ffffffff81077030>] do_fork+0x10b/0x271
    [<ffffffff8100a0e9>] sys_clone+0x23/0x25
    [<ffffffff815dda73>] stub_clone+0x13/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff


Please let me know if you need more info, like dmesg, .config or other.
Hope this helps.
Martin
