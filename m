Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaKEAMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 19:12:46 -0500
Received: from dovecot.logic.tuwien.ac.at ([128.130.175.61]:50871 "EHLO
	mail.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaKEAMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 19:12:45 -0500
Date: Wed, 5 Nov 2014 09:12:43 +0900
From: Norbert Preining <preining@logic.at>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: khugepaged / firefox going wild in 3.18-rc
Message-ID: <20141105001243.GR13232@auth.logic.tuwien.ac.at>
References: <20141104232027.GO13232@auth.logic.tuwien.ac.at>
 <alpine.DEB.2.10.1411041559170.2720@chino.kir.corp.google.com>
 <20141105001026.GQ13232@auth.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20141105001026.GQ13232@auth.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi David,

one more thing, attached dmesg output with some page faults,
maybe this is connected?

On Wed, 05 Nov 2014, Norbert Preining wrote:
> Hi David,
> 
> thanks for your answer.
> 
> On Tue, 04 Nov 2014, David Rientjes wrote:
> > If you have the ability to kill your X session, then you presumably are 
> > able to capture /proc/pid/stack for these pids to see where it is busy.  
> 
> Yes I can do that, I can even reproduce it on *every* start of iceweasel
> after it happened the first time.
> 
> There is no /proc/PID/stack, though .....
> 
> > It might also be helpful to see how the grep ^thp_ /proc/vmstat and 
> > grep ^compact_ /proc/vmstat counters change over time.
> 
> I captured that over timne, as well as the contents of
> 	/proc/PID/stat
> for iceweasel and khugepaged. There are some numbers steadily
> increasing.
> 
> Here is what I got:
> 
> START
> thp_fault_alloc 9092
> thp_fault_fallback 87
> thp_collapse_alloc 5003
> thp_collapse_alloc_failed 19
> thp_split 2889
> thp_zero_page_alloc 2
> thp_zero_page_alloc_failed 0
> compact_migrate_scanned 400301
> compact_free_scanned 8634053
> compact_isolated 687993
> compact_stall 567
> compact_fail 101
> compact_success 466
> 
> 
> thp_fault_alloc 9127
> thp_fault_fallback 100
> thp_collapse_alloc 5008
> thp_collapse_alloc_failed 19
> thp_split 2892
> thp_zero_page_alloc 2
> thp_zero_page_alloc_failed 0
> compact_migrate_scanned 430094
> compact_free_scanned 10444689
> compact_isolated 709843
> compact_stall 603
> compact_fail 130
> compact_success 473
> ===
> thp_fault_alloc 9127
> thp_fault_fallback 100
> thp_collapse_alloc 5008
> thp_collapse_alloc_failed 19
> thp_split 2892
> thp_zero_page_alloc 2
> thp_zero_page_alloc_failed 0
> compact_migrate_scanned 430094
> compact_free_scanned 10444689
> compact_isolated 709843
> compact_stall 603
> compact_fail 130
> compact_success 473
> ===
> thp_fault_alloc 9127
> thp_fault_fallback 100
> thp_collapse_alloc 5008
> thp_collapse_alloc_failed 19
> thp_split 2892
> thp_zero_page_alloc 2
> thp_zero_page_alloc_failed 0
> compact_migrate_scanned 430094
> compact_free_scanned 10444689
> compact_isolated 709843
> compact_stall 603
> compact_fail 130
> compact_success 473
> ===
> thp_fault_alloc 9127
> thp_fault_fallback 100
> thp_collapse_alloc 5008
> thp_collapse_alloc_failed 19
> thp_split 2892
> thp_zero_page_alloc 2
> thp_zero_page_alloc_failed 0
> compact_migrate_scanned 430094
> compact_free_scanned 10444689
> compact_isolated 709843
> compact_stall 603
> compact_fail 130
> compact_success 473
> ===
> 
> 
> /proc/PID/stat for iceweasel over some time:
> 8927 (iceweasel) R 27016 26901 26901 0 -1 4204544 100479 2248 5 0 565 14849 1 0 20 0 47 0 38224838 1134931968 84204 18446744073709551615 139840244875264 139840244981188 140737356374240 140737356331656 139840166756100 0 0 4096 17583 18446744073709551615 0 0 17 2 0 0 1 0 0 139840247078912 139840247080712 139840278519808 140737356376815 140737356376825 140737356376825 140737356378085 0
> 8927 (iceweasel) R 27016 26901 26901 0 -1 4204544 100479 2248 5 0 565 15130 1 0 20 0 47 0 38224838 1134931968 84204 18446744073709551615 139840244875264 139840244981188 140737356374240 140737356331656 139840166756100 0 0 4096 17583 18446744073709551615 0 0 17 1 0 0 1 0 0 139840247078912 139840247080712 139840278519808 140737356376815 140737356376825 140737356376825 140737356378085 0
> 8927 (iceweasel) R 27016 26901 26901 0 -1 4204544 100479 2248 5 0 565 15460 1 0 20 0 47 0 38224838 1134931968 84204 18446744073709551615 139840244875264 139840244981188 140737356374240 140737356331656 139840166756100 0 0 4096 17583 18446744073709551615 0 0 17 1 0 0 1 0 0 139840247078912 139840247080712 139840278519808 140737356376815 140737356376825 140737356376825 140737356378085 0
> 8927 (iceweasel) R 27016 26901 26901 0 -1 4204544 100479 2248 5 0 565 15724 1 0 20 0 47 0 38224838 1134931968 84204 18446744073709551615 139840244875264 139840244981188 140737356374240 140737356331656 139840166756100 0 0 4096 17583 18446744073709551615 0 0 17 1 0 0 1 0 0 139840247078912 139840247080712 139840278519808 140737356376815 140737356376825 140737356376825 140737356378085 0
> 
> 
> /proc/PID/stat for khugepaged over some time:
> 35 (khugepaged) R 2 0 0 0 -1 2107456 0 0 0 0 0 39779 0 0 39 19 1 0 22 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 0 0 0 17 0 0 0 0 0 0 0 0 0 0 0 0 0 0
> 35 (khugepaged) R 2 0 0 0 -1 2107456 0 0 0 0 0 40104 0 0 39 19 1 0 22 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 0 0 0 17 2 0 0 0 0 0 0 0 0 0 0 0 0 0
> 35 (khugepaged) R 2 0 0 0 -1 2107456 0 0 0 0 0 40516 0 0 39 19 1 0 22 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 0 0 0 17 2 0 0 0 0 0 0 0 0 0 0 0 0 0
> 35 (khugepaged) R 2 0 0 0 -1 2107456 0 0 0 0 0 40797 0 0 39 19 1 0 22 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 0 0 0 17 0 0 0 0 0 0 0 0 0 0 0 0 0 0
> 
> 

Norbert

------------------------------------------------------------------------
PREINING, Norbert                               http://www.preining.info
JAIST, Japan                                 TeX Live & Debian Developer
GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
------------------------------------------------------------------------

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

[28664.834183] INFO: task Socket Thread:8931 blocked for more than 120 seconds.
[28664.834190]       Tainted: G           O   3.18.0-rc2+ #47
[28664.834193] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[28664.834196] Socket Thread   D ffff8800ccc775e8     0  8931  27016 0x00000000
[28664.834203]  ffff88020de53d50 0000000000000082 ffff880215162048 ffff88020de53fd8
[28664.834209]  ffff8800ccc771a8 0000000000011c40 ffffffff814f33d5 ffff8802090f5be0
[28664.834215]  ffff8800ccc771a8 0000000000000000 00000000000000a9 ffff8800ccc771a8
[28664.834220] Call Trace:
[28664.834231]  [<ffffffff814f33d5>] ? sock_recvmsg+0x55/0x76
[28664.834238]  [<ffffffff815b9313>] schedule+0x64/0x66
[28664.834243]  [<ffffffff815bad67>] rwsem_down_read_failed+0xc7/0xdf
[28664.834249]  [<ffffffff81055c14>] ? try_to_wake_up+0x1a1/0x1b3
[28664.834256]  [<ffffffff812592e4>] call_rwsem_down_read_failed+0x14/0x30
[28664.834261]  [<ffffffff815ba85a>] ? down_read+0x12/0x14
[28664.834267]  [<ffffffff81030433>] __do_page_fault+0x1ba/0x34a
[28664.834272]  [<ffffffff814f6553>] ? release_sock+0x112/0x11b
[28664.834279]  [<ffffffff81538ba2>] ? do_tcp_setsockopt.isra.23+0x60e/0x674
[28664.834286]  [<ffffffff810f8186>] ? fput+0x12/0x86
[28664.834290]  [<ffffffff810305f0>] do_page_fault+0xc/0xe
[28664.834295]  [<ffffffff815bd692>] page_fault+0x22/0x30
[28664.834299] INFO: task JS Watchdog:8933 blocked for more than 120 seconds.
[28664.834302]       Tainted: G           O   3.18.0-rc2+ #47
[28664.834305] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[28664.834307] JS Watchdog     D ffff8801f22d3768     0  8933  27016 0x00000000
[28664.834312]  ffff880207243e48 0000000000000082 ffff8802151788b8 ffff880207243fd8
[28664.834317]  ffff8801f22d3328 0000000000011c40 ffff880207243ee8 ffff8802090f5be0
[28664.834322]  ffffffff00000001 ffff8802090f5bf8 ffff8801f22d3328 00007f2efa914000
[28664.834328] Call Trace:
[28664.834333]  [<ffffffff815b9313>] schedule+0x64/0x66
[28664.834338]  [<ffffffff815bb013>] rwsem_down_write_failed+0x294/0x2d2
[28664.834344]  [<ffffffff81259313>] call_rwsem_down_write_failed+0x13/0x20
[28664.834349]  [<ffffffff815ba87b>] ? down_write+0x1f/0x2e
[28664.834355]  [<ffffffff810da3aa>] SyS_mprotect+0xbe/0x1d7
[28664.834360]  [<ffffffff815bbf96>] system_call_fastpath+0x16/0x1b
[28664.834364] INFO: task pool:8937 blocked for more than 120 seconds.
[28664.834367]       Tainted: G           O   3.18.0-rc2+ #47
[28664.834369] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[28664.834371] pool            D ffff8801e8947238     0  8937  27016 0x00000000
[28664.834376]  ffff880207e8bd50 0000000000000082 ffff880215162048 ffff880207e8bfd8
[28664.834381]  ffff8801e8946df8 0000000000011c40 ffff880207e8bd20 ffff8802090f5be0
[28664.834386]  ffff8801e8946df8 0000000000000000 00000000000000a9 ffff8801e8946df8
[28664.834391] Call Trace:
[28664.834397]  [<ffffffff815b9313>] schedule+0x64/0x66
[28664.834411]  [<ffffffff815bad67>] rwsem_down_read_failed+0xc7/0xdf
[28664.834416]  [<ffffffff8107945b>] ? hrtimer_get_res+0x3f/0x3f
[28664.834421]  [<ffffffff812592e4>] call_rwsem_down_read_failed+0x14/0x30
[28664.834426]  [<ffffffff815ba85a>] ? down_read+0x12/0x14
[28664.834430]  [<ffffffff81030433>] __do_page_fault+0x1ba/0x34a
[28664.834435]  [<ffffffff81107d5f>] ? __dentry_kill+0x198/0x1a0
[28664.834441]  [<ffffffff8110eb3d>] ? mntput_no_expire+0x2a/0x10c
[28664.834445]  [<ffffffff8110ec47>] ? mntput+0x28/0x2a
[28664.834450]  [<ffffffff810f837e>] ? __fput+0x184/0x193
[28664.834456]  [<ffffffff810091ad>] ? read_tsc+0x9/0xb
[28664.834462]  [<ffffffff810882c5>] ? SyS_futex+0xb9/0x120
[28664.834467]  [<ffffffff810305f0>] do_page_fault+0xc/0xe
[28664.834471]  [<ffffffff815bd692>] page_fault+0x22/0x30
[28664.834474] INFO: task Timer:8939 blocked for more than 120 seconds.
[28664.834477]       Tainted: G           O   3.18.0-rc2+ #47
[28664.834479] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[28664.834481] Timer           D ffff8800cffa25c8     0  8939  27016 0x00000000
[28664.834486]  ffff8801cd9c3d50 0000000000000082 ffff8802151788b8 ffff8801cd9c3fd8
[28664.834490]  ffff8800cffa2188 0000000000011c40 ffff8801cd9c3d20 ffff8802090f5be0
[28664.834495]  ffff8800cffa2188 0000000000000000 00000000000000a9 ffff8800cffa2188
[28664.834500] Call Trace:
[28664.834505]  [<ffffffff815b9313>] schedule+0x64/0x66
[28664.834509]  [<ffffffff815bad67>] rwsem_down_read_failed+0xc7/0xdf
[28664.834515]  [<ffffffff812592e4>] call_rwsem_down_read_failed+0x14/0x30
[28664.834520]  [<ffffffff815ba85a>] ? down_read+0x12/0x14
[28664.834524]  [<ffffffff81030433>] __do_page_fault+0x1ba/0x34a
[28664.834530]  [<ffffffff81122141>] ? fsnotify+0x228/0x24d
[28664.834535]  [<ffffffff81058f22>] ? calc_delta_fair+0x1d/0x1f
[28664.834540]  [<ffffffff810882c5>] ? SyS_futex+0xb9/0x120
[28664.834545]  [<ffffffff815b913a>] ? __schedule+0x322/0x497
[28664.834549]  [<ffffffff810305f0>] do_page_fault+0xc/0xe
[28664.834553]  [<ffffffff815bd692>] page_fault+0x22/0x30
[28695.709435] Chrome_ChildThr[8990]: segfault at 0 ip 00007fc42ea9c3da sp 00007fc4260b9450 error 6 in libmozalloc.so[7fc42ea9b000+2000]

--sdtB3X0nJg68CQEu--
