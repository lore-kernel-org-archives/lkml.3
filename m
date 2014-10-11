Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaJKIwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 04:52:19 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:8750 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaJKIwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 04:52:17 -0400
Message-ID: <5438EFAF.4020303@huawei.com>
Date: Sat, 11 Oct 2014 16:51:59 +0800
From: Hu Keping <hukeping@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <arnd@arndb.de>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <sdu.liu@huawei.com>,
        <wangnan0@huawei.com>, <peifeiyue@huawei.com>
Subject: Memory trample when using /dev/mem
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.89.121]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Recently, I run a little testcase about using mmap to check
some physical address.What I found was that the different task can
read and write the same physical address at the same time.

For example,
I make proc1 to access 0x20000000, read and write "512" to
that address every 2 seconds. Meanwhile,I make proc2 to access
0x200000000, read and write "1024" to that address every 1 seconds.
The output is a mess, though it needs not be worry on this case,
but what about the proc1 and proc2 are both driver, and they mmap to the
same physical address?

As there are many drivers using /dev/mem and we can not
make sure that the different task will not trample on
each others memory.Shall we add some printk to help locating the problem
when error happened?


Thanks,
Hu Keping

