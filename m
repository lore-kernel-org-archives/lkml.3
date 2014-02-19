Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaBSG4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:56:32 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:24134 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaBSG4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:56:31 -0500
Message-ID: <5304558F.9050605@huawei.com>
Date: Wed, 19 Feb 2014 14:56:15 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: OS boot failed when set command-line kmemcheck=1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

CONFIG_KMEMCHECK=y and set command-line "kmemcheck=1", I find OS 
boot failed. The kernel is v3.14.0-rc3

If set "kmemcheck=1 nowatchdog", OS will boot successfully.

Here is the boot failed log:
[   23.586826] Freeing unused kernel memory: 1160K (ffff8800014de000 - ffff88000
1600000)
[   23.600248] Freeing unused kernel memory: 1696K (ffff880001858000 - ffff88000
1a00000)
[   23.615534] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00
000005
[   23.615534]
[   23.624885] CPU: 0 PID: 1 Comm: init Tainted: G        W    3.14.0-rc3-0.1-de
fault+ #1
[   23.632957] Hardware name: Huawei Technologies Co., Ltd. Tecal RH2285
  /BC11BTSA              , BIOS CTSAV036 04/27/2011
[   23.644661]  ffff880c1dd28000 ffff880c1dd31c48 ffffffff814ca491 ffff880c1dd31
cc8
[   23.652416]  ffffffff814ca1e6 0000000000000010 ffff880c1dd31cd8 ffff880c1dd31
c78
[   23.660171]  0000000000000027 ffff880c1dcb8280 0000000000000005 ffff880c1dd28
000
[   23.667931] Call Trace:
[   23.670482]  [<ffffffff814ca491>] dump_stack+0x6a/0x79
[   23.675712]  [<ffffffff814ca1e6>] panic+0xb9/0x1f4
[   23.680599]  [<ffffffff8104f78e>] forget_original_parent+0x42e/0x430
[   23.687043]  [<ffffffff81107da0>] ? perf_cgroup_switch+0x170/0x170
[   23.693314]  [<ffffffff8104f7a1>] exit_notify+0x11/0x140
[   23.698722]  [<ffffffff8104fb00>] do_exit+0x230/0x490
[   23.703865]  [<ffffffff8104fda3>] do_group_exit+0x43/0xb0
[   23.709357]  [<ffffffff8105fb31>] get_signal_to_deliver+0x241/0x4b0
[   23.715713]  [<ffffffff81002a0c>] do_notify_resume+0xac/0x1a0
[   23.721551]  [<ffffffff814d712a>] int_signal+0x12/0x17
[   23.726786] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xf
fffffff80000000-0xffffffff9fffffff)

