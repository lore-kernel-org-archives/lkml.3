Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaEZO7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:59:40 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:65114 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaEZO7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:59:14 -0400
MIME-Version: 1.0
In-Reply-To: <CALJ65z=AYx9i-zU6AjZ2E519J4FzhF1QP7T2YivQcvcR-WTFMg@mail.gmail.com>
References: <CACiqTEMeRiaio55cj0dc_ErCZe5XTGsQUwqBb90Jg22uN=FvLQ@mail.gmail.com>
	<CALJ65z=AYx9i-zU6AjZ2E519J4FzhF1QP7T2YivQcvcR-WTFMg@mail.gmail.com>
Date: Mon, 26 May 2014 17:59:13 +0300
Message-ID: <CACiqTENEOaTEGKwYzgTvTGVxPpnRyD3w4=tR_MUTA+uSM9VbRQ@mail.gmail.com>
Subject: Re: bcache errors
From: roma1390 <roma1390@gmail.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Neil Brown <neilb@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        linux-raid@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

can You resend it, I still waiting, and possible missed Your delivery.

Thank You.

On Mon, May 19, 2014 at 6:29 PM, Kent Overstreet <kmo@daterainc.com> wrote:
> I'll be sending the fix out in the next pull request, in the next day or so.
>
> On Mon, May 19, 2014 at 8:10 AM, roma1390 <roma1390@gmail.com> wrote:
>> Hello
>>
>> tryed bcache on 3.13-1-amd64 (from debian)
>>
>> Steps:
>>
>> git clone https://github.com/g2p/bcache-tools.git
>> cd bcache-tools/
>> make
>>
>> dd if=/dev/zero of=data bs=1M count=64
>> losetup -d /dev/loop0; losetup /dev/loop0 /tmp/bb/bcache-tools/data
>> make-bcache -C /dev/ram0 -B /dev/ram1
>> modprobe bcache
>> echo /dev/ram0 > /sys/fs/bcache/register
>> echo /dev/loop0 > /sys/fs/bcache/register
>>
>> Got:
>> May 19 17:32:55 bump kernel: [670838.280487] bcache: register_bdev()
>> registered backing device ram0
>> May 19 17:33:02 bump kernel: [670845.209612] bcache: run_cache_set()
>> invalidating existing data
>> May 19 17:33:02 bump kernel: [670845.277214] bcache:
>> bch_cached_dev_attach() Caching ram0 as bcache0 on set
>> d01c215c-f038-4e85-9f7f-d1133f080b55
>> May 19 17:33:02 bump kernel: [670845.277230] bcache: register_cache()
>> registered cache device loop0
>> May 19 17:35:28 bump kernel: [670991.228242] INFO: task
>> bcache_writebac:6378 blocked for more than 120 seconds.
>> May 19 17:35:28 bump kernel: [670991.228246]       Tainted: G
>> C   3.13-1-amd64 #1
>> May 19 17:35:28 bump kernel: [670991.228247] "echo 0 >
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> May 19 17:35:28 bump kernel: [670991.228248] bcache_writebac D
>> ffff8804f2ab2350     0  6378      2 0x00000000
>> May 19 17:35:28 bump kernel: [670991.228251]  ffff8804f2ab2010
>> 0000000000000046 0000000000014280 0000000000014280
>> May 19 17:35:28 bump kernel: [670991.228252]  ffff880725423fd8
>> ffff8804f2ab2010 ffff8805de3bba40 ffff8807f8410000
>> May 19 17:35:28 bump kernel: [670991.228254]  ffffffffa0866790
>> 0000000000000000 0000000000000000 0000000000000000
>> May 19 17:35:28 bump kernel: [670991.228255] Call Trace:
>> May 19 17:35:28 bump kernel: [670991.228262]  [<ffffffffa0866790>] ?
>> write_dirty_finish+0x210/0x210 [bcache]
>> May 19 17:35:28 bump kernel: [670991.228265]  [<ffffffff8107bb2d>] ?
>> kthread+0x9d/0xe0
>> May 19 17:35:28 bump kernel: [670991.228266]  [<ffffffff8107ba90>] ?
>> kthread_create_on_node+0x180/0x180
>> May 19 17:35:28 bump kernel: [670991.228270]  [<ffffffff814aeacc>] ?
>> ret_from_fork+0x7c/0xb0
>> May 19 17:35:28 bump kernel: [670991.228271]  [<ffffffff8107ba90>] ?
>> kthread_create_on_node+0x180/0x180
>> May 19 17:37:28 bump kernel: [671111.112160] INFO: task
>> bcache_writebac:6378 blocked for more than 120 seconds.
>> May 19 17:37:28 bump kernel: [671111.112165]       Tainted: G
>> C   3.13-1-amd64 #1
>> May 19 17:37:28 bump kernel: [671111.112166] "echo 0 >
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> May 19 17:37:28 bump kernel: [671111.112167] bcache_writebac D
>> ffff8804f2ab2350     0  6378      2 0x00000000
>> May 19 17:37:28 bump kernel: [671111.112170]  ffff8804f2ab2010
>> 0000000000000046 0000000000014280 0000000000014280
>> May 19 17:37:28 bump kernel: [671111.112172]  ffff880725423fd8
>> ffff8804f2ab2010 ffff8805de3bba40 ffff8807f8410000
>> May 19 17:37:28 bump kernel: [671111.112174]  ffffffffa0866790
>> 0000000000000000 0000000000000000 0000000000000000
>> May 19 17:37:28 bump kernel: [671111.112175] Call Trace:
>> May 19 17:37:28 bump kernel: [671111.112183]  [<ffffffffa0866790>] ?
>> write_dirty_finish+0x210/0x210 [bcache]
>> May 19 17:37:28 bump kernel: [671111.112186]  [<ffffffff8107bb2d>] ?
>> kthread+0x9d/0xe0
>> May 19 17:37:28 bump kernel: [671111.112188]  [<ffffffff8107ba90>] ?
>> kthread_create_on_node+0x180/0x180
>> May 19 17:37:28 bump kernel: [671111.112191]  [<ffffffff814aeacc>] ?
>> ret_from_fork+0x7c/0xb0
>> May 19 17:37:28 bump kernel: [671111.112193]  [<ffffffff8107ba90>] ?
>> kthread_create_on_node+0x180/0x180
>> May 19 17:39:28 bump kernel: [671230.996097] INFO: task
>> bcache_writebac:6378 blocked for more than 120 seconds.
>> May 19 17:39:28 bump kernel: [671230.996101]       Tainted: G
>> C   3.13-1-amd64 #1
>> May 19 17:39:28 bump kernel: [671230.996102] "echo 0 >
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> May 19 17:39:28 bump kernel: [671230.996103] bcache_writebac D
>> ffff8804f2ab2350     0  6378      2 0x00000000
>> May 19 17:39:28 bump kernel: [671230.996106]  ffff8804f2ab2010
>> 0000000000000046 0000000000014280 0000000000014280
>> May 19 17:39:28 bump kernel: [671230.996108]  ffff880725423fd8
>> ffff8804f2ab2010 ffff8805de3bba40 ffff8807f8410000
>> May 19 17:39:28 bump kernel: [671230.996109]  ffffffffa0866790
>> 0000000000000000 0000000000000000 0000000000000000
>> May 19 17:39:28 bump kernel: [671230.996111] Call Trace:
>> May 19 17:39:28 bump kernel: [671230.996118]  [<ffffffffa0866790>] ?
>> write_dirty_finish+0x210/0x210 [bcache]
>> May 19 17:39:28 bump kernel: [671230.996121]  [<ffffffff8107bb2d>] ?
>> kthread+0x9d/0xe0
>> May 19 17:39:28 bump kernel: [671230.996123]  [<ffffffff8107ba90>] ?
>> kthread_create_on_node+0x180/0x180
>> May 19 17:39:28 bump kernel: [671230.996126]  [<ffffffff814aeacc>] ?
>> ret_from_fork+0x7c/0xb0
>> May 19 17:39:28 bump kernel: [671230.996127]  [<ffffffff8107ba90>] ?
>> kthread_create_on_node+0x180/0x180
>> May 19 17:41:28 bump kernel: [671350.880041] INFO: task
>> bcache_writebac:6378 blocked for more than 120 seconds.
>> May 19 17:41:28 bump kernel: [671350.880045]       Tainted: G
>> C   3.13-1-amd64 #1
>> May 19 17:41:28 bump kernel: [671350.880046] "echo 0 >
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> May 19 17:41:28 bump kernel: [671350.880047] bcache_writebac D
>> ffff8804f2ab2350     0  6378      2 0x00000000
>> May 19 17:41:28 bump kernel: [671350.880050]  ffff8804f2ab2010
>> 0000000000000046 0000000000014280 0000000000014280
>> May 19 17:41:28 bump kernel: [671350.880051]  ffff880725423fd8
>> ffff8804f2ab2010 ffff8805de3bba40 ffff8807f8410000
>> May 19 17:41:28 bump kernel: [671350.880060]  ffffffffa0866790
>> 0000000000000000 0000000000000000 0000000000000000
>> May 19 17:41:28 bump kernel: [671350.880062] Call Trace:
>> May 19 17:41:28 bump kernel: [671350.880069]  [<ffffffffa0866790>] ?
>> write_dirty_finish+0x210/0x210 [bcache]
>> May 19 17:41:28 bump kernel: [671350.880073]  [<ffffffff8107bb2d>] ?
>> kthread+0x9d/0xe0
>> May 19 17:41:28 bump kernel: [671350.880074]  [<ffffffff8107ba90>] ?
>> kthread_create_on_node+0x180/0x180
>> May 19 17:41:28 bump kernel: [671350.880078]  [<ffffffff814aeacc>] ?
>> ret_from_fork+0x7c/0xb0
>> May 19 17:41:28 bump kernel: [671350.880079]  [<ffffffff8107ba90>] ?
>> kthread_create_on_node+0x180/0x180
