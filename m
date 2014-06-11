Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaFKIVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:21:09 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:7810 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaFKIVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:21:01 -0400
Message-ID: <53981100.7030404@huawei.com>
Date: Wed, 11 Jun 2014 16:19:12 +0800
From: Weng Meiling <wengmeiling.weng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: <jack@suse.cz>, <akpm@linux-foundation.org>, <adilger.kernel@dilger.ca>,
        Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: [linux 3.4 question] reboot command stall when vdbench test
References: <5397FC71.8020403@huawei.com>
In-Reply-To: <5397FC71.8020403@huawei.com>
X-Forwarded-Message-Id: <5397FC71.8020403@huawei.com>
Content-Type: multipart/mixed;
	boundary="------------050805010707080200000205"
X-Originating-IP: [10.177.24.66]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------050805010707080200000205
Content-Type: text/plain; charset="gb18030"
Content-Transfer-Encoding: 7bit

Hi guys,

We run vdbench test in our suse system with kernel 3.4, the vdbench test is about different
block size seq and rand read/write. Before the vdbench test, we had did some test about: disk
message lookup, raid rebuild(note we use hard raid: SAS2008 RAID).

we used nohup to run the vdbench test script:

#nohup ./vdbench_batch_test &

During test,  we cat the result file:

#cat nohup.out

at this time, the cat command stalled, then try to reboot, but the system
didn't reboot, and the reboot also stalled, shutdown gone to uninterruptible
sleep:

root     21716  0.0  0.0   4276   556 ?        D    18:31   0:00 cat nohup.out
root     21726  0.0  0.0  17880  2876 ?        Ds   18:33   0:00 -bash
root     21868  0.0  0.0   8224   740 ?        D    19:03   0:00 shutdown -r 0 w
root     21892  0.0  0.0  17880  2884 ?        Ds   19:11   0:00 -bash
root     21967  0.0  0.0   8224   740 ?        D    19:19   0:00 shutdown -r 0 w
root     21970  0.0  0.0  86044  3680 ?        Ss   19:19   0:00 sshd: root@pts/4
root     21975  0.0  0.0  17880  2880 pts/4    Ss   19:19   0:00 -bash
root     22000  0.0  0.0  12932  1280 pts/4    T    19:20   0:00 top

after several hours the system gone to dead, all the ssh connect stalled, we can't connect
to this server any more. The status kept for a week, finally we had to reboot the system
by power key. After system reboot, we done the same steps to try to reproduce the problem for
more than a month, but it didn't happen again.

We had analysed the code and lock information according the call trace, also review linux 3.4+
mainline patch to find similar problem fix, but no result.

Many others met the similar problem because use SAN/NFS/multipath devices, but we don't use none of these.

The attachments are our test program and dmesg information we get by sysrq before system dead.
Does anyone met the problem before? Any suggestion is appreciative. Thanks!











--------------050805010707080200000205
Content-Type: application/octet-stream; name="vdbench.rar"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="vdbench.rar"

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
PXsAQAcA
--------------050805010707080200000205
Content-Type: text/plain; charset="gb18030"; name="log_09140514-2-org.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="log_09140514-2-org.log"

# cat /proc/cmdline 
noexec=on rdinit=/sc_init console=ttyS0,115200n8 acpi_enforce_resources=lax quiet pci=lastbus=255 crashkernel=192M reboot=u

# iostat -xk -p 2
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.26    0.00    1.43   18.00    0.00   80.31

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             155.62     1.99  797.02    2.80 50980.97    19.09   127.53    26.65   28.98   1.21  96.69
sda1              0.01     0.00    0.00    0.00     0.01     0.00     8.84     0.77    8.61 254185.34  77.11
sda2              0.01     0.00    0.00    0.00     0.00     0.00    10.77     0.00    0.95   0.90   0.00
sda3              0.01     0.00    0.00    0.00     0.01     0.00     9.08     0.09    6.02 39379.39   9.20
sda4              0.00     0.00    0.00    0.00     0.00     0.00    12.33     0.00  804.67 804.67   0.00
sda5              0.05     0.00    0.01    0.00     0.30     0.03    43.27     0.97 1460.73 62865.33  95.06
sda6              0.00     0.00    0.01    0.00     0.06     0.01    19.20     0.95  700.99 135922.48  94.61
sda7              0.17     0.92    0.03    2.46     1.68    13.54    12.22     0.97  134.74 387.43  96.52
sda8            155.37     1.06  796.97    0.33 50978.90     5.52   127.89    22.91   28.61   1.20  95.54

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.16   18.64    0.00   81.17

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             145.00     0.00  890.00    0.00 56024.00     0.00   125.90    71.00   73.32   1.12 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            145.00     0.00  889.00    0.00 55960.00     0.00   125.89    66.00   73.36   1.12 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.16   18.99    0.00   80.82

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             135.00     0.00  842.50    0.00 52960.00     0.00   125.72    70.84   77.08   1.19 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            135.00     0.00  842.50    0.00 52960.00     0.00   125.72    65.84   77.08   1.19 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.25   18.54    0.00   81.21

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             175.00     0.00  892.00    0.00 55904.00     0.00   125.35    71.08   73.12   1.12 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            175.00     0.00  892.00    0.00 55904.00     0.00   125.35    66.08   73.12   1.12 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.47   18.57    0.00   80.96

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             150.00     0.00  840.50    0.00 52888.00     0.00   125.85    70.79   76.09   1.19 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            150.00     0.00  840.50    0.00 52888.00     0.00   125.85    65.79   76.09   1.19 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.19   18.57    0.00   81.21

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             110.00     0.00  844.00    0.00 53160.00     0.00   125.97    70.78   77.73   1.18 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            110.00     0.00  844.00    0.00 53160.00     0.00   125.97    65.78   77.73   1.18 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.03   18.58    0.00   81.39

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             145.00     0.00  870.50    0.00 54816.00     0.00   125.94    70.66   74.18   1.15 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            145.00     0.00  870.50    0.00 54816.00     0.00   125.94    65.66   74.18   1.15 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.09   18.55    0.00   81.32

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             120.00     0.00  810.50    0.00 51072.00     0.00   126.03    70.78   79.90   1.23 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            120.00     0.00  810.50    0.00 51072.00     0.00   126.03    65.78   79.90   1.23 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.19   18.53    0.00   81.25

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             130.00     0.00  869.00    0.00 54752.00     0.00   126.01    70.59   74.00   1.15 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            130.00     0.00  869.00    0.00 54752.00     0.00   126.01    65.59   74.00   1.15 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.13   18.57    0.00   81.27

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             115.00     0.00  848.50    0.00 53560.00     0.00   126.25    70.37   75.40   1.18 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            115.00     0.00  848.50    0.00 53560.00     0.00   126.25    65.37   75.40   1.18 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.09   18.56    0.00   81.35

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             100.00     0.00  831.00    0.00 52520.00     0.00   126.40    70.98   78.94   1.20 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            100.00     0.00  831.00    0.00 52520.00     0.00   126.40    65.98   78.94   1.20 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.09   18.55    0.00   81.32

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             130.00     0.00  742.50    0.00 46720.00     0.00   125.85    71.14   87.51   1.35 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            130.00     0.00  742.50    0.00 46720.00     0.00   125.85    66.14   87.51   1.35 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.19   18.60    0.00   81.18

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             145.00     0.00  715.50    0.00 44808.00     0.00   125.25    71.00   90.55   1.40 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            145.00     0.00  715.50    0.00 44808.00     0.00   125.25    66.00   90.55   1.40 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.13   18.62    0.00   81.26

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda              85.00     0.00  509.00    0.00 32024.00     0.00   125.83    70.49  124.71   1.96 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8             85.00     0.00  509.00    0.00 32024.00     0.00   125.83    65.49  124.71   1.96 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.16   18.67    0.00   81.14

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             110.00     0.00  828.50    0.00 52256.00     0.00   126.15    70.65   79.53   1.21 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            110.00     0.00  828.50    0.00 52256.00     0.00   126.15    65.65   79.53   1.21 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.06   18.54    0.00   81.37

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             105.00     0.00  854.50    0.00 53952.00     0.00   126.28    70.65   75.36   1.17 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            105.00     0.00  854.50    0.00 53952.00     0.00   126.28    65.65   75.36   1.17 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.06    0.00    0.09   18.59    0.00   81.26

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             140.00     0.00  816.00    0.00 51328.00     0.00   125.80    70.73   79.14   1.23 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            140.00     0.00  816.00    0.00 51328.00     0.00   125.80    65.73   79.14   1.23 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.28   18.54    0.00   81.18

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             120.00     0.00  858.00    0.00 54152.00     0.00   126.23    70.66   75.88   1.17 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            120.00     0.00  858.00    0.00 54152.00     0.00   126.23    65.66   75.88   1.17 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.06    0.00    0.13   18.57    0.00   81.24

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             110.00     0.00  862.50    0.00 54424.00     0.00   126.20    70.72   74.88   1.16 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            110.00     0.00  862.50    0.00 54424.00     0.00   126.20    65.72   74.88   1.16 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.06    0.00    0.16   18.52    0.00   81.26

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             105.00     0.00  848.50    0.00 53664.00     0.00   126.49    70.71   76.66   1.18 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            105.00     0.00  848.50    0.00 53664.00     0.00   126.49    65.71   76.66   1.18 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.19   18.58    0.00   81.23

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             135.00     0.00  867.00    0.00 54560.00     0.00   125.86    70.52   74.73   1.15 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            135.00     0.00  867.50    0.00 54592.00     0.00   125.86    65.52   74.77   1.15 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.19   18.58    0.00   81.20

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             175.00     0.00  856.50    0.00 53664.00     0.00   125.31    70.85   75.15   1.17 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            175.00     0.00  856.00    0.00 53632.00     0.00   125.31    65.85   75.11   1.17 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.09   18.53    0.00   81.35

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda             115.00     0.00  864.50    0.00 54528.00     0.00   126.15    70.58   75.13   1.16 100.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
sda8            115.00     0.00  864.50    0.00 54528.00     0.00   126.15    65.58   75.13   1.16 100.00



# ps -ef | grep bdi
root        74     2  0 Apr08 ?        00:00:00 [bdi-default]
root     28435 23084  0 23:24 pts/13   00:00:00 grep bdi
# ps -ef | grep flush
root      2927     2  0 Apr08 ?        00:00:00 [flush-8:0]
root     28438 23084  0 23:24 pts/13   00:00:00 grep flush
# cat /proc/74/stack
[<ffffffff81123b9b>] bdi_forker_thread+0x20b/0x4a0
[<ffffffff8106556e>] kthread+0x9e/0xb0
[<ffffffff814708d4>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff
# cat /proc/2927
[<ffffffff81103349>] sleep_on_page+0x9/0x10
[<ffffffff81103334>] __lock_page+0x64/0x70
[<ffffffff8110de60>] write_cache_pages+0x370/0x510
[<ffffffff8110e04c>] generic_writepages+0x4c/0x70
[<ffffffff8110e0a5>] do_writepages+0x35/0x40
[<ffffffff8118c4af>] writeback_single_inode+0x1af/0x400
[<ffffffff8118ce83>] writeback_sb_inodes+0x183/0x270
[<ffffffff8118d6ef>] __writeback_inodes_wb+0x9f/0xd0
[<ffffffff8118da4b>] wb_writeback+0x28b/0x2b0
[<ffffffff8118dc8b>] wb_do_writeback+0x21b/0x230
[<ffffffff8118dd7b>] bdi_writeback_thread+0xdb/0x230
[<ffffffff8106556e>] kthread+0x9e/0xb0
[<ffffffff814708d4>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff


The following is message about cpu from sysrq£º

The first 15 cpus are idle like following:

[107375.220757] NMI backtrace for cpu 0
[107375.220759] CPU 0 
[107375.220886] Process swapper/0 (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a13020)
[107375.220887] Stack:
[107375.220889]  0000000000000082 000061a83fc0cd00 ffffffff81a01ea8 ffffffff81374763
[107375.220893]  0000000000000000 0000000001e5cccd 0000000000000000 ffff8808bee18570
[107375.220897]  ffffffff81a6cc40 0000000080000000 0000000000000000 0000000000000001
[107375.220900] Call Trace:
[107375.220907]  [<ffffffff81374763>] ? menu_select+0x1a3/0x3c0
[107375.220911]  [<ffffffff81372d57>] cpuidle_enter+0x17/0x20
[107375.220915]  [<ffffffff81373612>] cpuidle_idle_call+0x102/0x1b0
[107375.220920]  [<ffffffff8100ab3d>] cpu_idle+0x7d/0xd0
[107375.220924]  [<ffffffff8144a78d>] rest_init+0x6d/0x80
[107375.220929]  [<ffffffff81ad8ea5>] start_kernel+0x37e/0x451
[107375.220932]  [<ffffffff81ad891b>] ? kernel_init+0x297/0x297
[107375.220938]  [<ffffffff81462eae>] ? memblock_reserve+0x2e/0x4e
[107375.220941]  [<ffffffff81ad82a5>] x86_64_start_reservations+0xa5/0xc2
[107375.220944]  [<ffffffff81ad83d1>] x86_64_start_kernel+0x10f/0x12a
[107375.220947]  [<ffffffff81ad8140>] ? early_idt_handlers+0x140/0x140
[107375.220949] Code: 8b 75 f0 c9 c3 90 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 0f 85 77 ff ff ff b1 01 4c 89 e0 0f 01 c9 <e9> 6a ff ff ff 66 0f 1f 44 00 00 48 8d 75 cc bf 04 00 00 00 e8 
[107375.220975] Call Trace:
[107375.220978]  [<ffffffff81374763>] ? menu_select+0x1a3/0x3c0
[107375.220981]  [<ffffffff81372d57>] cpuidle_enter+0x17/0x20
[107375.220984]  [<ffffffff81373612>] cpuidle_idle_call+0x102/0x1b0
[107375.220987]  [<ffffffff8100ab3d>] cpu_idle+0x7d/0xd0
[107375.220990]  [<ffffffff8144a78d>] rest_init+0x6d/0x80
[107375.220993]  [<ffffffff81ad8ea5>] start_kernel+0x37e/0x451
[107375.220996]  [<ffffffff81ad891b>] ? kernel_init+0x297/0x297
[107375.220999]  [<ffffffff81462eae>] ? memblock_reserve+0x2e/0x4e
[107375.221002]  [<ffffffff81ad82a5>] x86_64_start_reservations+0xa5/0xc2
[107375.221005]  [<ffffffff81ad83d1>] x86_64_start_kernel+0x10f/0x12a
[107375.221008]  [<ffffffff81ad8140>] ? early_idt_handlers+0x140/0x140

the 15th cpu is doing sysrq:

[107375.218190] NMI backtrace for cpu 15
[107375.218190] CPU 15 
[107375.218190] Process bash (pid: 28219, threadinfo ffff8807d7542000, task ffff8807d7540040)
[107375.218190] Stack:
[107375.218190]  ffff8807d7543e58 ffffffff810241f7 0000000000009230 ffffffff81a735c0
[107375.218190]  ffff8807d7543e68 ffffffff812f3ac9 ffff8807d7543ea8 ffffffff812f3e98
[107375.218190]  0000000000000000 0000000000000002 fffffffffffffffb ffff88083e8c6980
[107375.218190] Call Trace:
[107375.218190]  [<ffffffff810241f7>] arch_trigger_all_cpu_backtrace+0x97/0xb0
[107375.218190]  [<ffffffff812f3ac9>] sysrq_handle_showallcpus+0x9/0x10
[107375.218190]  [<ffffffff812f3e98>] __handle_sysrq+0x128/0x190
[107375.218190]  [<ffffffff812f3f40>] write_sysrq_trigger+0x40/0x50
[107375.218190]  [<ffffffff811c46ba>] proc_reg_write+0x7a/0xb0
[107375.218190]  [<ffffffff8116588b>] vfs_write+0xcb/0x130
[107375.218190]  [<ffffffff811659e0>] sys_write+0x50/0x90
[107375.218190]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[107375.218190] Code: ff ff c9 c3 66 0f 1f 44 00 00 8d 46 3f 85 f6 41 89 f0 55 44 0f 48 c0 31 d2 41 c1 f8 06 48 89 e5 45 85 c0 7e 2a 31 d2 48 83 3f 00 <48> 89 f9 74 17 eb 60 0f 1f 84 00 00 00 00 00 48 8b 41 08 48 83 
[107375.218190] Call Trace:
[107375.218190]  [<ffffffff810241f7>] arch_trigger_all_cpu_backtrace+0x97/0xb0
[107375.218190]  [<ffffffff812f3ac9>] sysrq_handle_showallcpus+0x9/0x10
[107375.218190]  [<ffffffff812f3e98>] __handle_sysrq+0x128/0x190
[107375.218190]  [<ffffffff812f3f40>] write_sysrq_trigger+0x40/0x50
[107375.218190]  [<ffffffff811c46ba>] proc_reg_write+0x7a/0xb0
[107375.218190]  [<ffffffff8116588b>] vfs_write+0xcb/0x130
[107375.218190]  [<ffffffff811659e0>] sys_write+0x50/0x90
[107375.218190]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b

The following is message about cpu and processes from sysrq£º

[112186.818106] java            D ffff88088bba48a8     0 21552  21445 0x00000000
[112186.818106]  ffff8808650db9e8 0000000000000082 ffff8808650da010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8808650dbfd8
[112186.818106]  ffff8808650dbfd8 0000000000012c80 ffff88088bba4300 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8122bd7f>] ? __blk_run_queue+0x2f/0x40
[112186.818106]  [<ffffffff8122c268>] ? queue_unplugged+0x78/0xc0
[112186.818106]  [<ffffffff8122cdb5>] ? blk_flush_plug_list+0x1b5/0x1f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8146605c>] io_schedule+0x9c/0xf0
[112186.818106]  [<ffffffff8119c874>] dio_await_completion+0x54/0xc0
[112186.818106]  [<ffffffff8119e9e5>] do_blockdev_direct_IO+0x665/0x8b0
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff8119ec80>] __blockdev_direct_IO+0x50/0x60
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffffa02ea6d7>] ext3_direct_IO+0x147/0x370 [ext3]
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff81104c61>] generic_file_aio_read+0x261/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff81099fc1>] ? futex_wake_op+0x221/0x4f0
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165be2>] sys_pread64+0x92/0xa0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] java            D ffff88085b5888e8     0 21553  21445 0x00000000
[112186.818106]  ffff88085b7a99e8 0000000000000082 ffff88085b7a8010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88085b7a9fd8
[112186.818106]  ffff88085b7a9fd8 0000000000012c80 ffff88085b588340 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8122bd7f>] ? __blk_run_queue+0x2f/0x40
[112186.818106]  [<ffffffff8122c268>] ? queue_unplugged+0x78/0xc0
[112186.818106]  [<ffffffff8122cdb5>] ? blk_flush_plug_list+0x1b5/0x1f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8146605c>] io_schedule+0x9c/0xf0
[112186.818106]  [<ffffffff8119c874>] dio_await_completion+0x54/0xc0
[112186.818106]  [<ffffffff8119e9e5>] do_blockdev_direct_IO+0x665/0x8b0
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff8119ec80>] __blockdev_direct_IO+0x50/0x60
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffffa02ea6d7>] ext3_direct_IO+0x147/0x370 [ext3]
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff81104c61>] generic_file_aio_read+0x261/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff81099fc1>] ? futex_wake_op+0x221/0x4f0
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165be2>] sys_pread64+0x92/0xa0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] java            D ffff880804c48928     0 21554  21445 0x00000000
[112186.818106]  ffff88087defd9e8 0000000000000082 ffff88087defc010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087defdfd8
[112186.818106]  ffff88087defdfd8 0000000000012c80 ffff880804c48380 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8122bd7f>] ? __blk_run_queue+0x2f/0x40
[112186.818106]  [<ffffffff8122c268>] ? queue_unplugged+0x78/0xc0
[112186.818106]  [<ffffffff8122cdb5>] ? blk_flush_plug_list+0x1b5/0x1f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8146605c>] io_schedule+0x9c/0xf0
[112186.818106]  [<ffffffff8119c874>] dio_await_completion+0x54/0xc0
[112186.818106]  [<ffffffff8119e9e5>] do_blockdev_direct_IO+0x665/0x8b0
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff8119ec80>] __blockdev_direct_IO+0x50/0x60
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffffa02ea6d7>] ext3_direct_IO+0x147/0x370 [ext3]
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff81104c61>] generic_file_aio_read+0x261/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff81099fc1>] ? futex_wake_op+0x221/0x4f0
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165be2>] sys_pread64+0x92/0xa0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] java            D ffff88087d608968     0 21555  21445 0x00000000
[112186.818106]  ffff8808827a79e8 0000000000000082 ffff8808827a6010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8808827a7fd8
[112186.818106]  ffff8808827a7fd8 0000000000012c80 ffff88087d6083c0 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8122bd7f>] ? __blk_run_queue+0x2f/0x40
[112186.818106]  [<ffffffff8122c268>] ? queue_unplugged+0x78/0xc0
[112186.818106]  [<ffffffff8122cdb5>] ? blk_flush_plug_list+0x1b5/0x1f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8146605c>] io_schedule+0x9c/0xf0
[112186.818106]  [<ffffffff8119c874>] dio_await_completion+0x54/0xc0
[112186.818106]  [<ffffffff8119e9e5>] do_blockdev_direct_IO+0x665/0x8b0
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff8119ec80>] __blockdev_direct_IO+0x50/0x60
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffffa02ea6d7>] ext3_direct_IO+0x147/0x370 [ext3]
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff81104c61>] generic_file_aio_read+0x261/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff81099fc1>] ? futex_wake_op+0x221/0x4f0
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165be2>] sys_pread64+0x92/0xa0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] java            D ffff88087b5009a8     0 21556  21445 0x00000000
[112186.818106]  ffff880883e8b9e8 0000000000000082 ffff880883e8a010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880883e8bfd8
[112186.818106]  ffff880883e8bfd8 0000000000012c80 ffff88087b500400 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8122bd7f>] ? __blk_run_queue+0x2f/0x40
[112186.818106]  [<ffffffff8122c268>] ? queue_unplugged+0x78/0xc0
[112186.818106]  [<ffffffff8122cdb5>] ? blk_flush_plug_list+0x1b5/0x1f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8146605c>] io_schedule+0x9c/0xf0
[112186.818106]  [<ffffffff8119c874>] dio_await_completion+0x54/0xc0
[112186.818106]  [<ffffffff8119e9e5>] do_blockdev_direct_IO+0x665/0x8b0
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff8119ec80>] __blockdev_direct_IO+0x50/0x60
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffffa02ea6d7>] ext3_direct_IO+0x147/0x370 [ext3]
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff81104c61>] generic_file_aio_read+0x261/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff81099fc1>] ? futex_wake_op+0x221/0x4f0
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165be2>] sys_pread64+0x92/0xa0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] java            D ffff8808819de9e8     0 21557  21445 0x00000000
[112186.818106]  ffff8808653899e8 0000000000000082 ffff880865388010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880865389fd8
[112186.818106]  ffff880865389fd8 0000000000012c80 ffff8808819de440 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8122bd7f>] ? __blk_run_queue+0x2f/0x40
[112186.818106]  [<ffffffff8122c268>] ? queue_unplugged+0x78/0xc0
[112186.818106]  [<ffffffff8122cdb5>] ? blk_flush_plug_list+0x1b5/0x1f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8146605c>] io_schedule+0x9c/0xf0
[112186.818106]  [<ffffffff8119c874>] dio_await_completion+0x54/0xc0
[112186.818106]  [<ffffffff8119e9e5>] do_blockdev_direct_IO+0x665/0x8b0
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff8119ec80>] __blockdev_direct_IO+0x50/0x60
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffffa02ea6d7>] ext3_direct_IO+0x147/0x370 [ext3]
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff81104c61>] generic_file_aio_read+0x261/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff81099fc1>] ? futex_wake_op+0x221/0x4f0
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165be2>] sys_pread64+0x92/0xa0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] java            D ffff88086525ca28     0 21558  21445 0x00000000
[112186.818106]  ffff88084ff419e8 0000000000000082 ffff88084ff40010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88084ff41fd8
[112186.818106]  ffff88084ff41fd8 0000000000012c80 ffff88086525c480 ffff8808970c6300
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8122bd7f>] ? __blk_run_queue+0x2f/0x40
[112186.818106]  [<ffffffff8122c268>] ? queue_unplugged+0x78/0xc0
[112186.818106]  [<ffffffff8122cdb5>] ? blk_flush_plug_list+0x1b5/0x1f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8146605c>] io_schedule+0x9c/0xf0
[112186.818106]  [<ffffffff8119c874>] dio_await_completion+0x54/0xc0
[112186.818106]  [<ffffffff8119e9e5>] do_blockdev_direct_IO+0x665/0x8b0
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff8119ec80>] __blockdev_direct_IO+0x50/0x60
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffffa02ea6d7>] ext3_direct_IO+0x147/0x370 [ext3]
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff81104c61>] generic_file_aio_read+0x261/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff81099fc1>] ? futex_wake_op+0x221/0x4f0
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165be2>] sys_pread64+0x92/0xa0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] java            D ffff88084fe18a68     0 21559  21445 0x00000000
[112186.818106]  ffff88084fd099e8 0000000000000082 ffff88084fd08010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88084fd09fd8
[112186.818106]  ffff88084fd09fd8 0000000000012c80 ffff88084fe184c0 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8122bd7f>] ? __blk_run_queue+0x2f/0x40
[112186.818106]  [<ffffffff8122c268>] ? queue_unplugged+0x78/0xc0
[112186.818106]  [<ffffffff8122cdb5>] ? blk_flush_plug_list+0x1b5/0x1f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8146605c>] io_schedule+0x9c/0xf0
[112186.818106]  [<ffffffff8119c874>] dio_await_completion+0x54/0xc0
[112186.818106]  [<ffffffff8119e9e5>] do_blockdev_direct_IO+0x665/0x8b0
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff8119ec80>] __blockdev_direct_IO+0x50/0x60
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffffa02ea6d7>] ext3_direct_IO+0x147/0x370 [ext3]
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff81104c61>] generic_file_aio_read+0x261/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff81099fc1>] ? futex_wake_op+0x221/0x4f0
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165be2>] sys_pread64+0x92/0xa0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] java            D ffff88087b83eaa8     0 21560  21445 0x00000000
[112186.818106]  ffff8808675959e8 0000000000000082 ffff880867594010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880867595fd8
[112186.818106]  ffff880867595fd8 0000000000012c80 ffff88087b83e500 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8122bd7f>] ? __blk_run_queue+0x2f/0x40
[112186.818106]  [<ffffffff8122c268>] ? queue_unplugged+0x78/0xc0
[112186.818106]  [<ffffffff8122cdb5>] ? blk_flush_plug_list+0x1b5/0x1f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8146605c>] io_schedule+0x9c/0xf0
[112186.818106]  [<ffffffff8119c874>] dio_await_completion+0x54/0xc0
[112186.818106]  [<ffffffff8119e9e5>] do_blockdev_direct_IO+0x665/0x8b0
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff8119ec80>] __blockdev_direct_IO+0x50/0x60
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffffa02ea6d7>] ext3_direct_IO+0x147/0x370 [ext3]
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff81104c61>] generic_file_aio_read+0x261/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff81099fc1>] ? futex_wake_op+0x221/0x4f0
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165be2>] sys_pread64+0x92/0xa0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] java            D ffff88087a10aae8     0 21561  21445 0x00000000
[112186.818106]  ffff8808676b99e8 0000000000000082 ffff8808676b8010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8808676b9fd8
[112186.818106]  ffff8808676b9fd8 0000000000012c80 ffff88087a10a540 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8122bd7f>] ? __blk_run_queue+0x2f/0x40
[112186.818106]  [<ffffffff8122c268>] ? queue_unplugged+0x78/0xc0
[112186.818106]  [<ffffffff8122cdb5>] ? blk_flush_plug_list+0x1b5/0x1f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8146605c>] io_schedule+0x9c/0xf0
[112186.818106]  [<ffffffff8119c874>] dio_await_completion+0x54/0xc0
[112186.818106]  [<ffffffff8119e9e5>] do_blockdev_direct_IO+0x665/0x8b0
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff8119ec80>] __blockdev_direct_IO+0x50/0x60
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffffa02ea6d7>] ext3_direct_IO+0x147/0x370 [ext3]
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff81104c61>] generic_file_aio_read+0x261/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff81099fc1>] ? futex_wake_op+0x221/0x4f0
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165be2>] sys_pread64+0x92/0xa0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] java            D ffff88083ea2cb28     0 21562  21445 0x00000000
[112186.818106]  ffff88088411d9e8 0000000000000082 ffff88088411c010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88088411dfd8
[112186.818106]  ffff88088411dfd8 0000000000012c80 ffff88083ea2c580 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8122bd7f>] ? __blk_run_queue+0x2f/0x40
[112186.818106]  [<ffffffff8122c268>] ? queue_unplugged+0x78/0xc0
[112186.818106]  [<ffffffff8122cdb5>] ? blk_flush_plug_list+0x1b5/0x1f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8146605c>] io_schedule+0x9c/0xf0
[112186.818106]  [<ffffffff8119c874>] dio_await_completion+0x54/0xc0
[112186.818106]  [<ffffffff8119e9e5>] do_blockdev_direct_IO+0x665/0x8b0
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff8119ec80>] __blockdev_direct_IO+0x50/0x60
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffffa02ea6d7>] ext3_direct_IO+0x147/0x370 [ext3]
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff81104c61>] generic_file_aio_read+0x261/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff81099fc1>] ? futex_wake_op+0x221/0x4f0
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165be2>] sys_pread64+0x92/0xa0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] java            D ffff88087fd86b68     0 21563  21445 0x00000000
[112186.818106]  ffff8808582619e8 0000000000000082 ffff880858260010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880858261fd8
[112186.818106]  ffff880858261fd8 0000000000012c80 ffff88087fd865c0 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8122bd7f>] ? __blk_run_queue+0x2f/0x40
[112186.818106]  [<ffffffff8122c268>] ? queue_unplugged+0x78/0xc0
[112186.818106]  [<ffffffff8122cdb5>] ? blk_flush_plug_list+0x1b5/0x1f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8146605c>] io_schedule+0x9c/0xf0
[112186.818106]  [<ffffffff8119c874>] dio_await_completion+0x54/0xc0
[112186.818106]  [<ffffffff8119e9e5>] do_blockdev_direct_IO+0x665/0x8b0
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff8119ec80>] __blockdev_direct_IO+0x50/0x60
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffffa02ea6d7>] ext3_direct_IO+0x147/0x370 [ext3]
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff81104c61>] generic_file_aio_read+0x261/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff81099fc1>] ? futex_wake_op+0x221/0x4f0
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165be2>] sys_pread64+0x92/0xa0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] java            D ffff8808653a4ba8     0 21564  21445 0x00000000
[112186.818106]  ffff88084fdef9e8 0000000000000082 ffff88084fdee010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88084fdeffd8
[112186.818106]  ffff88084fdeffd8 0000000000012c80 ffff8808653a4600 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8122bd7f>] ? __blk_run_queue+0x2f/0x40
[112186.818106]  [<ffffffff8122c268>] ? queue_unplugged+0x78/0xc0
[112186.818106]  [<ffffffff8122cdb5>] ? blk_flush_plug_list+0x1b5/0x1f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8146605c>] io_schedule+0x9c/0xf0
[112186.818106]  [<ffffffff8119c874>] dio_await_completion+0x54/0xc0
[112186.818106]  [<ffffffff8119e9e5>] do_blockdev_direct_IO+0x665/0x8b0
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff8119ec80>] __blockdev_direct_IO+0x50/0x60
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffffa02ea6d7>] ext3_direct_IO+0x147/0x370 [ext3]
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff81104c61>] generic_file_aio_read+0x261/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff81099fc1>] ? futex_wake_op+0x221/0x4f0
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165be2>] sys_pread64+0x92/0xa0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] java            D ffff88084fc98be8     0 21565  21445 0x00000000
[112186.818106]  ffff88087b7ed9e8 0000000000000082 ffff88087b7ec010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087b7edfd8
[112186.818106]  ffff88087b7edfd8 0000000000012c80 ffff88084fc98640 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8122bd7f>] ? __blk_run_queue+0x2f/0x40
[112186.818106]  [<ffffffff8122c268>] ? queue_unplugged+0x78/0xc0
[112186.818106]  [<ffffffff8122cdb5>] ? blk_flush_plug_list+0x1b5/0x1f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8146605c>] io_schedule+0x9c/0xf0
[112186.818106]  [<ffffffff8119c874>] dio_await_completion+0x54/0xc0
[112186.818106]  [<ffffffff8119e9e5>] do_blockdev_direct_IO+0x665/0x8b0
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff8119ec80>] __blockdev_direct_IO+0x50/0x60
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffffa02ea6d7>] ext3_direct_IO+0x147/0x370 [ext3]
[112186.818106]  [<ffffffffa02e87d0>] ? ext3_get_blocks_handle+0x6c0/0x6c0 [ext3]
[112186.818106]  [<ffffffff81104c61>] generic_file_aio_read+0x261/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff81099fc1>] ? futex_wake_op+0x221/0x4f0
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165be2>] sys_pread64+0x92/0xa0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cat             D ffff88080503781a     0 21716  10153 0x00000004
[112186.818106]  ffff88087db95a08 0000000000000082 ffff88087db94010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087db95fd8
[112186.818106]  ffff88087db95fd8 0000000000012c80 ffff88087b770200 ffff8808970c6300
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff8110422a>] do_generic_file_read+0x1ba/0x460
[112186.818106]  [<ffffffff811027f0>] ? iov_iter_copy_from_user+0x140/0x140
[112186.818106]  [<ffffffff81104b02>] generic_file_aio_read+0x102/0x290
[112186.818106]  [<ffffffff8112ce12>] ? handle_pte_fault+0x92/0x210
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D 0000000000000000     0 21726      1 0x00000000
[112186.818106]  ffff88087ceb5ca8 0000000000000082 ffff88087ceb4010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087ceb5fd8
[112186.818106]  ffff88087ceb5fd8 0000000000012c80 ffff88083ea30480 ffff8808971b22c0
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811bf24f>] ? __dquot_initialize+0x2f/0x1f0
[112186.818106]  [<ffffffff8124c76d>] ? cpumask_any_but+0x2d/0x40
[112186.818106]  [<ffffffff81037bf0>] ? flush_tlb_page+0x40/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466944>] __mutex_lock_slowpath+0xf4/0x170
[112186.818106]  [<ffffffff8146634e>] mutex_lock+0x1e/0x40
[112186.818106]  [<ffffffff811054c8>] generic_file_aio_write+0x48/0xd0
[112186.818106]  [<ffffffff81165221>] do_sync_write+0xe1/0x130
[112186.818106]  [<ffffffff81150cd9>] ? kmem_cache_free+0x149/0x2a0
[112186.818106]  [<ffffffff81218253>] ? apparmor_file_permission+0x13/0x20
[112186.818106]  [<ffffffff811f398d>] ? security_file_permission+0x1d/0xa0
[112186.818106]  [<ffffffff8116588b>] vfs_write+0xcb/0x130
[112186.818106]  [<ffffffff811659e0>] sys_write+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] shutdown        D 0000000000000000     0 21868  21726 0x00000000
[112186.818106]  ffff88085807dcb8 0000000000000086 ffff88085807c010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88085807dfd8
[112186.818106]  ffff88085807dfd8 0000000000012c80 ffff88086517c480 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81065af2>] ? bit_waitqueue+0x12/0xd0
[112186.818106]  [<ffffffff81065c08>] ? wake_up_bit+0x28/0x40
[112186.818106]  [<ffffffffa02c60f9>] ? do_get_write_access+0x329/0x4d0 [jbd]
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff814648a5>] schedule_timeout+0x215/0x2b0
[112186.818106]  [<ffffffff8107af58>] ? enqueue_sleeper+0x228/0x270
[112186.818106]  [<ffffffff81465437>] wait_for_common+0xc7/0x190
[112186.818106]  [<ffffffff81077ea0>] ? try_to_wake_up+0x390/0x390
[112186.818106]  [<ffffffff81192300>] ? __sync_filesystem+0x90/0x90
[112186.818106]  [<ffffffff814655a8>] wait_for_completion+0x18/0x20
[112186.818106]  [<ffffffff8118ca89>] writeback_inodes_sb_nr+0x79/0xa0
[112186.818106]  [<ffffffff8118d04c>] writeback_inodes_sb+0x5c/0x80
[112186.818106]  [<ffffffff811922b9>] __sync_filesystem+0x49/0x90
[112186.818106]  [<ffffffff81192317>] sync_one_sb+0x17/0x20
[112186.818106]  [<ffffffff81168a3b>] iterate_supers+0xab/0xf0
[112186.818106]  [<ffffffff8119234f>] sys_sync+0x2f/0x70
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D 0000000000000000     0 21892      1 0x00000000
[112186.818106]  ffff880881cf1ca8 0000000000000086 ffff880881cf0010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880881cf1fd8
[112186.818106]  ffff880881cf1fd8 0000000000012c80 ffff88087ccb6340 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811bf24f>] ? __dquot_initialize+0x2f/0x1f0
[112186.818106]  [<ffffffff8124c76d>] ? cpumask_any_but+0x2d/0x40
[112186.818106]  [<ffffffff81037bf0>] ? flush_tlb_page+0x40/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466944>] __mutex_lock_slowpath+0xf4/0x170
[112186.818106]  [<ffffffff8146634e>] mutex_lock+0x1e/0x40
[112186.818106]  [<ffffffff811054c8>] generic_file_aio_write+0x48/0xd0
[112186.818106]  [<ffffffff81165221>] do_sync_write+0xe1/0x130
[112186.818106]  [<ffffffff81150cd9>] ? kmem_cache_free+0x149/0x2a0
[112186.818106]  [<ffffffff81218253>] ? apparmor_file_permission+0x13/0x20
[112186.818106]  [<ffffffff811f398d>] ? security_file_permission+0x1d/0xa0
[112186.818106]  [<ffffffff8116588b>] vfs_write+0xcb/0x130
[112186.818106]  [<ffffffff811659e0>] sys_write+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] shutdown        D 0000000000000000     0 21967  21892 0x00000000
[112186.818106]  ffff88084fd35cb8 0000000000000082 ffff88084fd34010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88084fd35fd8
[112186.818106]  ffff88084fd35fd8 0000000000012c80 ffff88085b58c2c0 ffff880897176180
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81065af2>] ? bit_waitqueue+0x12/0xd0
[112186.818106]  [<ffffffff81065c08>] ? wake_up_bit+0x28/0x40
[112186.818106]  [<ffffffffa02c60f9>] ? do_get_write_access+0x329/0x4d0 [jbd]
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff814648a5>] schedule_timeout+0x215/0x2b0
[112186.818106]  [<ffffffff8107af58>] ? enqueue_sleeper+0x228/0x270
[112186.818106]  [<ffffffff81465437>] wait_for_common+0xc7/0x190
[112186.818106]  [<ffffffff81077ea0>] ? try_to_wake_up+0x390/0x390
[112186.818106]  [<ffffffff81192300>] ? __sync_filesystem+0x90/0x90
[112186.818106]  [<ffffffff814655a8>] wait_for_completion+0x18/0x20
[112186.818106]  [<ffffffff8118ca89>] writeback_inodes_sb_nr+0x79/0xa0
[112186.818106]  [<ffffffff8118d04c>] writeback_inodes_sb+0x5c/0x80
[112186.818106]  [<ffffffff811922b9>] __sync_filesystem+0x49/0x90
[112186.818106]  [<ffffffff81192317>] sync_one_sb+0x17/0x20
[112186.818106]  [<ffffffff81168a3b>] iterate_supers+0xab/0xf0
[112186.818106]  [<ffffffff8119234f>] sys_sync+0x2f/0x70
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            S ffff88087c898928     0 21970   8292 0x00000000
[112186.818106]  ffff8808674a38d8 0000000000000082 ffff8808674a2010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8808674a3fd8
[112186.818106]  ffff8808674a3fd8 0000000000012c80 ffff88087c898380 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff813c2f07>] ? sch_direct_xmit+0x77/0x1d0
[112186.818106]  [<ffffffff813a774c>] ? dev_queue_xmit+0x16c/0x3b0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81464d15>] schedule_hrtimeout_range_clock+0x115/0x130
[112186.818106]  [<ffffffff8107105e>] ? __wake_up+0x4e/0x70
[112186.818106]  [<ffffffff812efdba>] ? put_ldisc+0x5a/0xc0
[112186.818106]  [<ffffffff81464d3e>] schedule_hrtimeout_range+0xe/0x10
[112186.818106]  [<ffffffff81177e84>] poll_schedule_timeout+0x44/0x70
[112186.818106]  [<ffffffff81178a63>] do_select+0x603/0x6c0
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff8140a04b>] ? inet_recvmsg+0x4b/0x90
[112186.818106]  [<ffffffff8138dfc4>] ? __sock_recvmsg+0x84/0xa0
[112186.818106]  [<ffffffff811791ec>] core_sys_select+0x17c/0x290
[112186.818106]  [<ffffffff81032898>] ? __bad_area_nosemaphore+0x208/0x220
[112186.818106]  [<ffffffff81165351>] ? do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff810328be>] ? bad_area_nosemaphore+0xe/0x10
[112186.818106]  [<ffffffff8146af20>] ? do_page_fault+0x100/0x4b0
[112186.818106]  [<ffffffff8117955a>] sys_select+0x4a/0x110
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            S ffff88088be904c0     0 21975  21970 0x00000000
[112186.818106]  ffff88083e94de48 0000000000000082 ffff88083e94c010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88083e94dfd8
[112186.818106]  ffff88083e94dfd8 0000000000012c80 ffff88088be904c0 ffff8808867ea040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff810460c7>] ? wait_task_stopped+0x87/0x2e0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] top             T 0000000000060013     0 22000  21975 0x00000000
[112186.818106]  ffff88087b173d78 0000000000000086 ffff88087b172010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087b173fd8
[112186.818106]  ffff88087b173fd8 0000000000012c80 ffff88086507e140 ffff88089715a040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff810578a6>] ? do_notify_parent_cldstop+0x156/0x1a0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81058613>] do_signal_stop+0xe3/0x250
[112186.818106]  [<ffffffff81055f35>] ? dequeue_signal+0x55/0x1c0
[112186.818106]  [<ffffffff81058967>] get_signal_to_deliver+0x1e7/0x4d0
[112186.818106]  [<ffffffff810029bb>] do_notify_resume+0xcb/0x1b0
[112186.818106]  [<ffffffff8146f832>] int_signal+0x12/0x17
[112186.818106] sshd            S ffff880883dbe768     0 22646   8292 0x00000000
[112186.818106]  ffff8808676db8d8 0000000000000082 ffff8808676da010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8808676dbfd8
[112186.818106]  ffff8808676dbfd8 0000000000012c80 ffff880883dbe1c0 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffffa042bfff>] ? igb_xmit_frame+0x5f/0xa0 [igb]
[112186.818106]  [<ffffffff813a46b0>] ? dev_hard_start_xmit+0x2e0/0x4f0
[112186.818106]  [<ffffffff813c2f07>] ? sch_direct_xmit+0x77/0x1d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81464d15>] schedule_hrtimeout_range_clock+0x115/0x130
[112186.818106]  [<ffffffff8107105e>] ? __wake_up+0x4e/0x70
[112186.818106]  [<ffffffff812efdba>] ? put_ldisc+0x5a/0xc0
[112186.818106]  [<ffffffff81464d3e>] schedule_hrtimeout_range+0xe/0x10
[112186.818106]  [<ffffffff81177e84>] poll_schedule_timeout+0x44/0x70
[112186.818106]  [<ffffffff81178a63>] do_select+0x603/0x6c0
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff8140a04b>] ? inet_recvmsg+0x4b/0x90
[112186.818106]  [<ffffffff8138ddca>] ? __sock_sendmsg_nosec+0x6a/0x80
[112186.818106]  [<ffffffff8138dfc4>] ? __sock_recvmsg+0x84/0xa0
[112186.818106]  [<ffffffff811791ec>] core_sys_select+0x17c/0x290
[112186.818106]  [<ffffffff81032898>] ? __bad_area_nosemaphore+0x208/0x220
[112186.818106]  [<ffffffff81165351>] ? do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff810328be>] ? bad_area_nosemaphore+0xe/0x10
[112186.818106]  [<ffffffff8146af20>] ? do_page_fault+0x100/0x4b0
[112186.818106]  [<ffffffff8117955a>] sys_select+0x4a/0x110
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            S ffff88086526a640     0 22670  22646 0x00000000
[112186.818106]  ffff88087ce85e48 0000000000000086 ffff88087ce84010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087ce85fd8
[112186.818106]  ffff88087ce85fd8 0000000000012c80 ffff88086526a640 ffff8808971b22c0
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] df              D ffff880880504a8a     0 22695  22670 0x00000004
[112186.818106]  ffff88087b5bbb18 0000000000000086 ffff88087b5ba010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087b5bbfd8
[112186.818106]  ffff88087b5bbfd8 0000000000012c80 ffff88087e11c340 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8146b07c>] ? do_page_fault+0x25c/0x4b0
[112186.818106]  [<ffffffff8110a6b9>] ? get_page_from_freelist+0x289/0x6f0
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff81173f39>] path_openat+0x229/0x3f0
[112186.818106]  [<ffffffff81174213>] do_filp_open+0x43/0xa0
[112186.818106]  [<ffffffff81180f3a>] ? alloc_fd+0x4a/0x120
[112186.818106]  [<ffffffff81164aa2>] do_sys_open+0x162/0x1f0
[112186.818106]  [<ffffffff81164b6c>] sys_open+0x1c/0x20
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D 0000000000000000     0 22706      1 0x00000000
[112186.818106]  ffff88089747dca8 0000000000000082 ffff88089747c010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88089747dfd8
[112186.818106]  ffff88089747dfd8 0000000000012c80 ffff880858154680 ffff8808971b22c0
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8115facb>] ? __mem_cgroup_commit_charge+0x12b/0x2b0
[112186.818106]  [<ffffffff8124c76d>] ? cpumask_any_but+0x2d/0x40
[112186.818106]  [<ffffffff81037bf0>] ? flush_tlb_page+0x40/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466944>] __mutex_lock_slowpath+0xf4/0x170
[112186.818106]  [<ffffffff8146634e>] mutex_lock+0x1e/0x40
[112186.818106]  [<ffffffff811054c8>] generic_file_aio_write+0x48/0xd0
[112186.818106]  [<ffffffff81165221>] do_sync_write+0xe1/0x130
[112186.818106]  [<ffffffff81150cd9>] ? kmem_cache_free+0x149/0x2a0
[112186.818106]  [<ffffffff81218253>] ? apparmor_file_permission+0x13/0x20
[112186.818106]  [<ffffffff811f398d>] ? security_file_permission+0x1d/0xa0
[112186.818106]  [<ffffffff8116588b>] vfs_write+0xcb/0x130
[112186.818106]  [<ffffffff811659e0>] sys_write+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D ffff880880505542     0 22777      1 0x00000004
[112186.818106]  ffff880882485a58 0000000000000082 ffff880882484010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880882485fd8
[112186.818106]  ffff880882485fd8 0000000000012c80 ffff880881c7a4c0 ffff8808867ea040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8110a6b9>] ? get_page_from_freelist+0x289/0x6f0
[112186.818106]  [<ffffffff8124c76d>] ? cpumask_any_but+0x2d/0x40
[112186.818106]  [<ffffffff81037bf0>] ? flush_tlb_page+0x40/0xa0
[112186.818106]  [<ffffffff8103672d>] ? ptep_set_access_flags+0x4d/0x70
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff81174490>] path_lookupat+0x220/0x680
[112186.818106]  [<ffffffff81174920>] do_path_lookup+0x30/0xd0
[112186.818106]  [<ffffffff8117580b>] user_path_at_empty+0x7b/0xb0
[112186.818106]  [<ffffffff81217de8>] ? apparmor_inode_getattr+0x48/0x50
[112186.818106]  [<ffffffff8116a0b3>] ? cp_new_stat+0xe3/0xf0
[112186.818106]  [<ffffffff8117584c>] user_path_at+0xc/0x10
[112186.818106]  [<ffffffff8116a2d6>] vfs_fstatat+0x46/0x80
[112186.818106]  [<ffffffff8116a436>] vfs_stat+0x16/0x20
[112186.818106]  [<ffffffff8116a45f>] sys_newstat+0x1f/0x50
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D ffff8808820b7472     0 22810  22706 0x00000004
[112186.818106]  ffff880883d7da98 0000000000000082 ffff880883d7c010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880883d7dfd8
[112186.818106]  ffff880883d7dfd8 0000000000012c80 ffff88087f116380 ffff880897352100
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff8119428c>] ? __find_get_block_slow+0xbc/0x140
[112186.818106]  [<ffffffffa02c4318>] ? __journal_file_buffer+0x158/0x260 [jbd]
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffffa02c4286>] ? __journal_file_buffer+0xc6/0x260 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e5265>] ext3_new_inode+0x385/0x7d0 [ext3]
[112186.818106]  [<ffffffffa02c508d>] ? journal_start+0x9d/0xe0 [jbd]
[112186.818106]  [<ffffffffa02ed797>] ext3_create+0xc7/0x130 [ext3]
[112186.818106]  [<ffffffff811f2719>] ? security_inode_permission+0x19/0x20
[112186.818106]  [<ffffffff8117151c>] vfs_create+0xac/0xd0
[112186.818106]  [<ffffffff81173286>] do_last+0x786/0x800
[112186.818106]  [<ffffffff811f2941>] ? security_file_alloc+0x11/0x20
[112186.818106]  [<ffffffff81173de0>] path_openat+0xd0/0x3f0
[112186.818106]  [<ffffffff81174213>] do_filp_open+0x43/0xa0
[112186.818106]  [<ffffffff81180f3a>] ? alloc_fd+0x4a/0x120
[112186.818106]  [<ffffffff81164aa2>] do_sys_open+0x162/0x1f0
[112186.818106]  [<ffffffff81164b6c>] sys_open+0x1c/0x20
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D 0000000000000000     0 22858      1 0x00000000
[112186.818106]  ffff88083e917ca8 0000000000000086 ffff88083e916010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88083e917fd8
[112186.818106]  ffff88083e917fd8 0000000000012c80 ffff880858266500 ffff88089715a040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811bf24f>] ? __dquot_initialize+0x2f/0x1f0
[112186.818106]  [<ffffffff8124c76d>] ? cpumask_any_but+0x2d/0x40
[112186.818106]  [<ffffffff81037bf0>] ? flush_tlb_page+0x40/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466944>] __mutex_lock_slowpath+0xf4/0x170
[112186.818106]  [<ffffffff8146634e>] mutex_lock+0x1e/0x40
[112186.818106]  [<ffffffff811054c8>] generic_file_aio_write+0x48/0xd0
[112186.818106]  [<ffffffff81165221>] do_sync_write+0xe1/0x130
[112186.818106]  [<ffffffff81150cd9>] ? kmem_cache_free+0x149/0x2a0
[112186.818106]  [<ffffffff81218253>] ? apparmor_file_permission+0x13/0x20
[112186.818106]  [<ffffffff811f398d>] ? security_file_permission+0x1d/0xa0
[112186.818106]  [<ffffffff8116588b>] vfs_write+0xcb/0x130
[112186.818106]  [<ffffffff811659e0>] sys_write+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] vi              D 0000000000000000     0 22885  22858 0x00000000
[112186.818106]  ffff8808677a7ba8 0000000000000082 ffff8808677a6010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8808677a7fd8
[112186.818106]  ffff8808677a7fd8 0000000000012c80 ffff88087b660400 ffff8808971b22c0
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff8107af58>] ? enqueue_sleeper+0x228/0x270
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466944>] __mutex_lock_slowpath+0xf4/0x170
[112186.818106]  [<ffffffff8146634e>] mutex_lock+0x1e/0x40
[112186.818106]  [<ffffffff81171f5f>] do_lookup+0x2af/0x310
[112186.818106]  [<ffffffff8117432f>] path_lookupat+0xbf/0x680
[112186.818106]  [<ffffffff81174920>] do_path_lookup+0x30/0xd0
[112186.818106]  [<ffffffff8117580b>] user_path_at_empty+0x7b/0xb0
[112186.818106]  [<ffffffff81217de8>] ? apparmor_inode_getattr+0x48/0x50
[112186.818106]  [<ffffffff8116a0b3>] ? cp_new_stat+0xe3/0xf0
[112186.818106]  [<ffffffff8117584c>] user_path_at+0xc/0x10
[112186.818106]  [<ffffffff8116a2d6>] vfs_fstatat+0x46/0x80
[112186.818106]  [<ffffffff8116a436>] vfs_stat+0x16/0x20
[112186.818106]  [<ffffffff8116a45f>] sys_newstat+0x1f/0x50
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D 0000000000000000     0 22898      1 0x00000000
[112186.818106]  ffff880886161ca8 0000000000000086 ffff880886160010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880886161fd8
[112186.818106]  ffff880886161fd8 0000000000012c80 ffff88087b8780c0 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811bf24f>] ? __dquot_initialize+0x2f/0x1f0
[112186.818106]  [<ffffffff8124c76d>] ? cpumask_any_but+0x2d/0x40
[112186.818106]  [<ffffffff81037bf0>] ? flush_tlb_page+0x40/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466944>] __mutex_lock_slowpath+0xf4/0x170
[112186.818106]  [<ffffffff8146634e>] mutex_lock+0x1e/0x40
[112186.818106]  [<ffffffff811054c8>] generic_file_aio_write+0x48/0xd0
[112186.818106]  [<ffffffff81165221>] do_sync_write+0xe1/0x130
[112186.818106]  [<ffffffff81150cd9>] ? kmem_cache_free+0x149/0x2a0
[112186.818106]  [<ffffffff81218253>] ? apparmor_file_permission+0x13/0x20
[112186.818106]  [<ffffffff811f398d>] ? security_file_permission+0x1d/0xa0
[112186.818106]  [<ffffffff8116588b>] vfs_write+0xcb/0x130
[112186.818106]  [<ffffffff811659e0>] sys_write+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] ls              D 0000000000000000     0 22921  22898 0x00000004
[112186.818106]  ffff8808582a1e28 0000000000000086 ffff8808582a0010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8808582a1fd8
[112186.818106]  ffff8808582a1fd8 0000000000012c80 ffff88087c810280 ffff88088430c180
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112ce12>] ? handle_pte_fault+0x92/0x210
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D 0000000000000000     0 22941      1 0x00000000
[112186.818106]  ffff880865179ca8 0000000000000082 ffff880865178010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880865179fd8
[112186.818106]  ffff880865179fd8 0000000000012c80 ffff88087fd4a1c0 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811bf24f>] ? __dquot_initialize+0x2f/0x1f0
[112186.818106]  [<ffffffff8124c76d>] ? cpumask_any_but+0x2d/0x40
[112186.818106]  [<ffffffff81037bf0>] ? flush_tlb_page+0x40/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466944>] __mutex_lock_slowpath+0xf4/0x170
[112186.818106]  [<ffffffff8146634e>] mutex_lock+0x1e/0x40
[112186.818106]  [<ffffffff811054c8>] generic_file_aio_write+0x48/0xd0
[112186.818106]  [<ffffffff81165221>] do_sync_write+0xe1/0x130
[112186.818106]  [<ffffffff81150cd9>] ? kmem_cache_free+0x149/0x2a0
[112186.818106]  [<ffffffff81218253>] ? apparmor_file_permission+0x13/0x20
[112186.818106]  [<ffffffff811f398d>] ? security_file_permission+0x1d/0xa0
[112186.818106]  [<ffffffff8116588b>] vfs_write+0xcb/0x130
[112186.818106]  [<ffffffff811659e0>] sys_write+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] ls              D 0000000000000000     0 22964  22941 0x00000000
[112186.818106]  ffff88085814de28 0000000000000082 ffff88085814c010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88085814dfd8
[112186.818106]  ffff88085814dfd8 0000000000012c80 ffff880884288480 ffff88089715a040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112ce12>] ? handle_pte_fault+0x92/0x210
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D 0000000000000000     0 22988      1 0x00000004
[112186.818106]  ffff880881fc7e28 0000000000000082 ffff880881fc6010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880881fc7fd8
[112186.818106]  ffff880881fc7fd8 0000000000012c80 ffff88088bd20240 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D 0000000000000000     0 23032      1 0x00000000
[112186.818106]  ffff8808970c3ca8 0000000000000086 ffff8808970c2010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8808970c3fd8
[112186.818106]  ffff8808970c3fd8 0000000000012c80 ffff880883c54340 ffff8808970c6300
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811bf24f>] ? __dquot_initialize+0x2f/0x1f0
[112186.818106]  [<ffffffff8124c76d>] ? cpumask_any_but+0x2d/0x40
[112186.818106]  [<ffffffff81037bf0>] ? flush_tlb_page+0x40/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466944>] __mutex_lock_slowpath+0xf4/0x170
[112186.818106]  [<ffffffff8146634e>] mutex_lock+0x1e/0x40
[112186.818106]  [<ffffffff811054c8>] generic_file_aio_write+0x48/0xd0
[112186.818106]  [<ffffffff81165221>] do_sync_write+0xe1/0x130
[112186.818106]  [<ffffffff81150cd9>] ? kmem_cache_free+0x149/0x2a0
[112186.818106]  [<ffffffff81218253>] ? apparmor_file_permission+0x13/0x20
[112186.818106]  [<ffffffff811f398d>] ? security_file_permission+0x1d/0xa0
[112186.818106]  [<ffffffff8116588b>] vfs_write+0xcb/0x130
[112186.818106]  [<ffffffff811659e0>] sys_write+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] vi              D 0000000000000000     0 23060  23032 0x00000004
[112186.818106]  ffff88087deebba8 0000000000000086 ffff88087deea010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087deebfd8
[112186.818106]  ffff88087deebfd8 0000000000012c80 ffff88087fd66140 ffff8808970c6300
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff8107af58>] ? enqueue_sleeper+0x228/0x270
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466944>] __mutex_lock_slowpath+0xf4/0x170
[112186.818106]  [<ffffffff8146634e>] mutex_lock+0x1e/0x40
[112186.818106]  [<ffffffff81171f5f>] do_lookup+0x2af/0x310
[112186.818106]  [<ffffffff8117432f>] path_lookupat+0xbf/0x680
[112186.818106]  [<ffffffff81174920>] do_path_lookup+0x30/0xd0
[112186.818106]  [<ffffffff8117580b>] user_path_at_empty+0x7b/0xb0
[112186.818106]  [<ffffffff81217de8>] ? apparmor_inode_getattr+0x48/0x50
[112186.818106]  [<ffffffff8116a0b3>] ? cp_new_stat+0xe3/0xf0
[112186.818106]  [<ffffffff8117584c>] user_path_at+0xc/0x10
[112186.818106]  [<ffffffff8116a2d6>] vfs_fstatat+0x46/0x80
[112186.818106]  [<ffffffff8116a436>] vfs_stat+0x16/0x20
[112186.818106]  [<ffffffff8116a45f>] sys_newstat+0x1f/0x50
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            S ffff880880ce8ba8     0 23079   8292 0x00000000
[112186.818106]  ffff8808650dd8d8 0000000000000082 ffff8808650dc010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8808650ddfd8
[112186.818106]  ffff8808650ddfd8 0000000000012c80 ffff880880ce8600 ffff88084fd321c0
[112186.818106] Call Trace:
[112186.818106]  [<ffffffffa042bfff>] ? igb_xmit_frame+0x5f/0xa0 [igb]
[112186.818106]  [<ffffffff813a46b0>] ? dev_hard_start_xmit+0x2e0/0x4f0
[112186.818106]  [<ffffffff813c2f07>] ? sch_direct_xmit+0x77/0x1d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81464d15>] schedule_hrtimeout_range_clock+0x115/0x130
[112186.818106]  [<ffffffff8107105e>] ? __wake_up+0x4e/0x70
[112186.818106]  [<ffffffff812efdba>] ? put_ldisc+0x5a/0xc0
[112186.818106]  [<ffffffff81464d3e>] schedule_hrtimeout_range+0xe/0x10
[112186.818106]  [<ffffffff81177e84>] poll_schedule_timeout+0x44/0x70
[112186.818106]  [<ffffffff81178a63>] do_select+0x603/0x6c0
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff810713b5>] ? check_preempt_curr+0x95/0xa0
[112186.818106]  [<ffffffff81071428>] ? ttwu_do_wakeup+0x68/0xf0
[112186.818106]  [<ffffffff810df485>] ? tracing_is_on+0x15/0x30
[112186.818106]  [<ffffffff810713b5>] ? check_preempt_curr+0x95/0xa0
[112186.818106]  [<ffffffff81071428>] ? ttwu_do_wakeup+0x68/0xf0
[112186.818106]  [<ffffffff81077b6e>] ? try_to_wake_up+0x5e/0x390
[112186.818106]  [<ffffffff811791ec>] core_sys_select+0x17c/0x290
[112186.818106]  [<ffffffff81032898>] ? __bad_area_nosemaphore+0x208/0x220
[112186.818106]  [<ffffffff81065f42>] ? remove_wait_queue+0x52/0x60
[112186.818106]  [<ffffffff810328be>] ? bad_area_nosemaphore+0xe/0x10
[112186.818106]  [<ffffffff8146af20>] ? do_page_fault+0x100/0x4b0
[112186.818106]  [<ffffffff812efdba>] ? put_ldisc+0x5a/0xc0
[112186.818106]  [<ffffffff812efe59>] ? tty_ldisc_deref+0x9/0x10
[112186.818106]  [<ffffffff812e8ba4>] ? tty_write+0x234/0x290
[112186.818106]  [<ffffffff8117955a>] sys_select+0x4a/0x110
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            R  running task        0 23084  23079 0x00000000
[112186.818106]  ffffffffbeeb36c0 ffffffff81255d47 000000007fffffff 0000000000000006
[112186.818106]  ffffffff8177ee03 04cb1cb881cc5744 ffffffff8177ee09 ffff880804cb1d38
[112186.818106]  ffffffff04cb1c58 0000000000000082 ffff880804cb1c18 ffffffff8106afe5
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8106afe5>] ? up+0x35/0x50
[112186.818106]  [<ffffffff8146463f>] ? printk+0x48/0x71
[112186.818106]  [<ffffffff8146463f>] ? printk+0x48/0x71
[112186.818106]  [<ffffffff8109f2cd>] ? __module_text_address+0xd/0x70
[112186.818106]  [<ffffffff8109f339>] ? is_module_text_address+0x9/0x20
[112186.818106]  [<ffffffff81062478>] ? __kernel_text_address+0x58/0x80
[112186.818106]  [<ffffffff81062478>] ? __kernel_text_address+0x58/0x80
[112186.818106]  [<ffffffff81005871>] ? print_context_stack+0x81/0xe0
[112186.818106]  [<ffffffff81004560>] ? dump_trace+0x100/0x2e0
[112186.818106]  [<ffffffff81005697>] show_trace_log_lvl+0x57/0x70
[112186.818106]  [<ffffffff81004850>] show_stack_log_lvl+0xf0/0x150
[112186.818106]  [<ffffffff81005637>] show_stack+0x17/0x20
[112186.818106]  [<ffffffff81073105>] sched_show_task+0x95/0x100
[112186.818106]  [<ffffffff810731e2>] show_state_filter+0x72/0xc0
[112186.818106]  [<ffffffff812f39fb>] sysrq_handle_showstate+0xb/0x10
[112186.818106]  [<ffffffff812f3e98>] __handle_sysrq+0x128/0x190
[112186.818106]  [<ffffffff812f3f40>] write_sysrq_trigger+0x40/0x50
[112186.818106]  [<ffffffff811c46ba>] proc_reg_write+0x7a/0xb0
[112186.818106]  [<ffffffff8116588b>] vfs_write+0xcb/0x130
[112186.818106]  [<ffffffff811659e0>] sys_write+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            S 0000000000000000     0 23212   8292 0x00000000
[112186.818106]  ffff8808813938d8 0000000000000082 ffff880881392010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880881393fd8
[112186.818106]  ffff880881393fd8 0000000000012c80 ffff8808580c2480 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffffa042bfff>] ? igb_xmit_frame+0x5f/0xa0 [igb]
[112186.818106]  [<ffffffff813a46b0>] ? dev_hard_start_xmit+0x2e0/0x4f0
[112186.818106]  [<ffffffff813c2f07>] ? sch_direct_xmit+0x77/0x1d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81464d15>] schedule_hrtimeout_range_clock+0x115/0x130
[112186.818106]  [<ffffffffa016cfe7>] ? bond_dev_queue_xmit+0x27/0x70 [bonding]
[112186.818106]  [<ffffffffa016d4a5>] ? __bond_start_xmit+0x315/0x3a0 [bonding]
[112186.818106]  [<ffffffff81065ff9>] ? add_wait_queue+0x49/0x60
[112186.818106]  [<ffffffff81065ff9>] ? add_wait_queue+0x49/0x60
[112186.818106]  [<ffffffff81464d3e>] schedule_hrtimeout_range+0xe/0x10
[112186.818106]  [<ffffffff81177e84>] poll_schedule_timeout+0x44/0x70
[112186.818106]  [<ffffffff8116dde3>] ? pipe_poll+0x33/0xa0
[112186.818106]  [<ffffffff81178a63>] do_select+0x603/0x6c0
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81077b6e>] ? try_to_wake_up+0x5e/0x390
[112186.818106]  [<ffffffff81077ead>] ? default_wake_function+0xd/0x10
[112186.818106]  [<ffffffff810499a2>] ? current_fs_time+0x22/0x30
[112186.818106]  [<ffffffff81077ea0>] ? try_to_wake_up+0x390/0x390
[112186.818106]  [<ffffffff8117df03>] ? file_update_time+0xf3/0x160
[112186.818106]  [<ffffffff8116ed42>] ? pipe_write+0x362/0x690
[112186.818106]  [<ffffffff811791ec>] core_sys_select+0x17c/0x290
[112186.818106]  [<ffffffff81032898>] ? __bad_area_nosemaphore+0x208/0x220
[112186.818106]  [<ffffffff81165221>] ? do_sync_write+0xe1/0x130
[112186.818106]  [<ffffffff810328be>] ? bad_area_nosemaphore+0xe/0x10
[112186.818106]  [<ffffffff8146af20>] ? do_page_fault+0x100/0x4b0
[112186.818106]  [<ffffffff8117955a>] sys_select+0x4a/0x110
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sftp-server     D 0000000000000000     0 23219  23212 0x00000000
[112186.818106]  ffff880882e39e28 0000000000000086 ffff880882e38010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880882e39fd8
[112186.818106]  ffff880882e39fd8 0000000000012c80 ffff880880cfc640 ffff88089711c580
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112ce12>] ? handle_pte_fault+0x92/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D 0000000000000000     0 23278      1 0x00000004
[112186.818106]  ffff8808653ede28 0000000000000082 ffff8808653ec010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8808653edfd8
[112186.818106]  ffff8808653edfd8 0000000000012c80 ffff880867502300 ffff8808971ce400
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D 0000000000000000     0 23307      1 0x00000000
[112186.818106]  ffff880881f1bca8 0000000000000086 ffff880881f1a010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880881f1bfd8
[112186.818106]  ffff880881f1bfd8 0000000000012c80 ffff88084fc3e100 ffff88089711c580
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811bf24f>] ? __dquot_initialize+0x2f/0x1f0
[112186.818106]  [<ffffffff8124c76d>] ? cpumask_any_but+0x2d/0x40
[112186.818106]  [<ffffffff81037bf0>] ? flush_tlb_page+0x40/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466944>] __mutex_lock_slowpath+0xf4/0x170
[112186.818106]  [<ffffffff8146634e>] mutex_lock+0x1e/0x40
[112186.818106]  [<ffffffff811054c8>] generic_file_aio_write+0x48/0xd0
[112186.818106]  [<ffffffff81165221>] do_sync_write+0xe1/0x130
[112186.818106]  [<ffffffff81150cd9>] ? kmem_cache_free+0x149/0x2a0
[112186.818106]  [<ffffffff81218253>] ? apparmor_file_permission+0x13/0x20
[112186.818106]  [<ffffffff811f398d>] ? security_file_permission+0x1d/0xa0
[112186.818106]  [<ffffffff8116588b>] vfs_write+0xcb/0x130
[112186.818106]  [<ffffffff811659e0>] sys_write+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] iotop           D 0000000000000000     0 23342  23307 0x00000004
[112186.818106]  ffff880881887b28 0000000000000082 ffff880881886010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880881887fd8
[112186.818106]  ffff880881887fd8 0000000000012c80 ffff8808818b2680 ffff880897176180
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8146b07c>] ? do_page_fault+0x25c/0x4b0
[112186.818106]  [<ffffffff811038ce>] ? add_to_page_cache_locked+0xce/0x140
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466944>] __mutex_lock_slowpath+0xf4/0x170
[112186.818106]  [<ffffffff8146634e>] mutex_lock+0x1e/0x40
[112186.818106]  [<ffffffff81171f5f>] do_lookup+0x2af/0x310
[112186.818106]  [<ffffffff811f2719>] ? security_inode_permission+0x19/0x20
[112186.818106]  [<ffffffff811738d2>] link_path_walk+0x192/0x4e0
[112186.818106]  [<ffffffff811742c7>] path_lookupat+0x57/0x680
[112186.818106]  [<ffffffff81174920>] do_path_lookup+0x30/0xd0
[112186.818106]  [<ffffffff8117580b>] user_path_at_empty+0x7b/0xb0
[112186.818106]  [<ffffffff8146b07c>] ? do_page_fault+0x25c/0x4b0
[112186.818106]  [<ffffffff8117584c>] user_path_at+0xc/0x10
[112186.818106]  [<ffffffff8116a2d6>] vfs_fstatat+0x46/0x80
[112186.818106]  [<ffffffff8116a436>] vfs_stat+0x16/0x20
[112186.818106]  [<ffffffff8116a45f>] sys_newstat+0x1f/0x50
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D ffff880880505a22     0 23349      1 0x00000004
[112186.818106]  ffff88087f2a5a08 0000000000000082 ffff88087f2a4010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087f2a5fd8
[112186.818106]  ffff88087f2a5fd8 0000000000012c80 ffff88087c8c0180 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff8110422a>] do_generic_file_read+0x1ba/0x460
[112186.818106]  [<ffffffff811027f0>] ? iov_iter_copy_from_user+0x140/0x140
[112186.818106]  [<ffffffff81104b02>] generic_file_aio_read+0x102/0x290
[112186.818106]  [<ffffffff81172eb9>] ? do_last+0x3b9/0x800
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            D ffff880880560202     0 23363   8292 0x00000000
[112186.818106]  ffff880865215a08 0000000000000082 ffff880865214010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880865215fd8
[112186.818106]  ffff880865215fd8 0000000000012c80 ffff88088735a480 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff8110422a>] do_generic_file_read+0x1ba/0x460
[112186.818106]  [<ffffffff811027f0>] ? iov_iter_copy_from_user+0x140/0x140
[112186.818106]  [<ffffffff81104b02>] generic_file_aio_read+0x102/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D ffff880880505a22     0 23368  23363 0x00000004
[112186.818106]  ffff880880c4fa08 0000000000000086 ffff880880c4e010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880880c4ffd8
[112186.818106]  ffff880880c4ffd8 0000000000012c80 ffff880880dbc580 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff8110422a>] do_generic_file_read+0x1ba/0x460
[112186.818106]  [<ffffffff811027f0>] ? iov_iter_copy_from_user+0x140/0x140
[112186.818106]  [<ffffffff81104b02>] generic_file_aio_read+0x102/0x290
[112186.818106]  [<ffffffff81172eb9>] ? do_last+0x3b9/0x800
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            D ffff880880504a8a     0 23481   8292 0x00000004
[112186.818106]  ffff88088429ba08 0000000000000082 ffff88088429a010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88088429bfd8
[112186.818106]  ffff88088429bfd8 0000000000012c80 ffff8808818e0300 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff8110422a>] do_generic_file_read+0x1ba/0x460
[112186.818106]  [<ffffffff811027f0>] ? iov_iter_copy_from_user+0x140/0x140
[112186.818106]  [<ffffffff81104b02>] generic_file_aio_read+0x102/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            S ffff880885cd10b0     0 23484  23481 0x00000000
[112186.818106]  ffff8808839efab8 0000000000000086 ffff8808839ee010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8808839effd8
[112186.818106]  ffff8808839effd8 0000000000012c80 ffff88087a12e3c0 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81178966>] ? do_select+0x506/0x6c0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff814648a5>] schedule_timeout+0x215/0x2b0
[112186.818106]  [<ffffffff8114ebc6>] ? ksize+0x16/0x70
[112186.818106]  [<ffffffff8139753a>] ? __alloc_skb+0x8a/0x180
[112186.818106]  [<ffffffff81065eb9>] ? prepare_to_wait+0x59/0x90
[112186.818106]  [<ffffffff814327c7>] unix_stream_data_wait+0xb7/0x120
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff813e7956>] ? tcp_recvmsg+0x486/0xd90
[112186.818106]  [<ffffffff8143550f>] unix_stream_recvmsg+0x2af/0x680
[112186.818106]  [<ffffffff8138dfc4>] __sock_recvmsg+0x84/0xa0
[112186.818106]  [<ffffffff8138e0f1>] sock_aio_read+0x111/0x120
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165b46>] vfs_read+0x126/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D 0000000000000000     0 23639      1 0x00000000
[112186.818106]  ffff88087a255ca8 0000000000000086 ffff88087a254010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087a255fd8
[112186.818106]  ffff88087a255fd8 0000000000012c80 ffff88087ca744c0 ffff8808971ce400
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811bf24f>] ? __dquot_initialize+0x2f/0x1f0
[112186.818106]  [<ffffffff8124c76d>] ? cpumask_any_but+0x2d/0x40
[112186.818106]  [<ffffffff81037bf0>] ? flush_tlb_page+0x40/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466944>] __mutex_lock_slowpath+0xf4/0x170
[112186.818106]  [<ffffffff8146634e>] mutex_lock+0x1e/0x40
[112186.818106]  [<ffffffff811054c8>] generic_file_aio_write+0x48/0xd0
[112186.818106]  [<ffffffff81165221>] do_sync_write+0xe1/0x130
[112186.818106]  [<ffffffff81150cd9>] ? kmem_cache_free+0x149/0x2a0
[112186.818106]  [<ffffffff81218253>] ? apparmor_file_permission+0x13/0x20
[112186.818106]  [<ffffffff811f398d>] ? security_file_permission+0x1d/0xa0
[112186.818106]  [<ffffffff8116588b>] vfs_write+0xcb/0x130
[112186.818106]  [<ffffffff811659e0>] sys_write+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] iotop           D 0000000000000000     0 23670  23639 0x00000000
[112186.818106]  ffff88085b6a3b28 0000000000000086 ffff88085b6a2010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88085b6a3fd8
[112186.818106]  ffff88085b6a3fd8 0000000000012c80 ffff880881b8c340 ffff8808970c6300
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8146b07c>] ? do_page_fault+0x25c/0x4b0
[112186.818106]  [<ffffffff8110a3a7>] ? prep_new_page+0x147/0x1d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466944>] __mutex_lock_slowpath+0xf4/0x170
[112186.818106]  [<ffffffff8146634e>] mutex_lock+0x1e/0x40
[112186.818106]  [<ffffffff81171f5f>] do_lookup+0x2af/0x310
[112186.818106]  [<ffffffff811f2719>] ? security_inode_permission+0x19/0x20
[112186.818106]  [<ffffffff811738d2>] link_path_walk+0x192/0x4e0
[112186.818106]  [<ffffffff811742c7>] path_lookupat+0x57/0x680
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81174920>] do_path_lookup+0x30/0xd0
[112186.818106]  [<ffffffff8117580b>] user_path_at_empty+0x7b/0xb0
[112186.818106]  [<ffffffff8146b07c>] ? do_page_fault+0x25c/0x4b0
[112186.818106]  [<ffffffff8117584c>] user_path_at+0xc/0x10
[112186.818106]  [<ffffffff8116a2d6>] vfs_fstatat+0x46/0x80
[112186.818106]  [<ffffffff8116a436>] vfs_stat+0x16/0x20
[112186.818106]  [<ffffffff8116a45f>] sys_newstat+0x1f/0x50
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            S ffff88087cca48a8     0 23671   8292 0x00000000
[112186.818106]  ffff88085835d8d8 0000000000000086 ffff88085835c010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88085835dfd8
[112186.818106]  ffff88085835dfd8 0000000000012c80 ffff88087cca4300 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff813c2f07>] ? sch_direct_xmit+0x77/0x1d0
[112186.818106]  [<ffffffff813a774c>] ? dev_queue_xmit+0x16c/0x3b0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81464d15>] schedule_hrtimeout_range_clock+0x115/0x130
[112186.818106]  [<ffffffff8107105e>] ? __wake_up+0x4e/0x70
[112186.818106]  [<ffffffff812efdba>] ? put_ldisc+0x5a/0xc0
[112186.818106]  [<ffffffff81464d3e>] schedule_hrtimeout_range+0xe/0x10
[112186.818106]  [<ffffffff81177e84>] poll_schedule_timeout+0x44/0x70
[112186.818106]  [<ffffffff81178a63>] do_select+0x603/0x6c0
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff8140a04b>] ? inet_recvmsg+0x4b/0x90
[112186.818106]  [<ffffffff81077b6e>] ? try_to_wake_up+0x5e/0x390
[112186.818106]  [<ffffffff8138dfc4>] ? __sock_recvmsg+0x84/0xa0
[112186.818106]  [<ffffffff811791ec>] core_sys_select+0x17c/0x290
[112186.818106]  [<ffffffff81032898>] ? __bad_area_nosemaphore+0x208/0x220
[112186.818106]  [<ffffffff81165351>] ? do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff810328be>] ? bad_area_nosemaphore+0xe/0x10
[112186.818106]  [<ffffffff8146af20>] ? do_page_fault+0x100/0x4b0
[112186.818106]  [<ffffffff8117955a>] sys_select+0x4a/0x110
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D 0000000000000000     0 23677  23671 0x00000004
[112186.818106]  ffff880880df3e28 0000000000000082 ffff880880df2010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880880df3fd8
[112186.818106]  ffff880880df3fd8 0000000000012c80 ffff88087db1e480 ffff88089711c580
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811f2941>] ? security_file_alloc+0x11/0x20
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff812ecc6f>] ? n_tty_read+0x3af/0x910
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            D ffff880880505542     0 23747      1 0x00000004
[112186.818106]  ffff88087cabfa58 0000000000000086 ffff88087cabe010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087cabffd8
[112186.818106]  ffff88087cabffd8 0000000000012c80 ffff88088407e240 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111793>] ? mark_page_accessed+0x43/0x50
[112186.818106]  [<ffffffff811949f8>] ? __find_get_block+0xb8/0x200
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff8119428c>] ? __find_get_block_slow+0xbc/0x140
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff81174490>] path_lookupat+0x220/0x680
[112186.818106]  [<ffffffff81174920>] do_path_lookup+0x30/0xd0
[112186.818106]  [<ffffffff8117580b>] user_path_at_empty+0x7b/0xb0
[112186.818106]  [<ffffffff81171121>] ? putname+0x31/0x50
[112186.818106]  [<ffffffff81175816>] ? user_path_at_empty+0x86/0xb0
[112186.818106]  [<ffffffff8117584c>] user_path_at+0xc/0x10
[112186.818106]  [<ffffffff8116a2d6>] vfs_fstatat+0x46/0x80
[112186.818106]  [<ffffffff8116a436>] vfs_stat+0x16/0x20
[112186.818106]  [<ffffffff8116a45f>] sys_newstat+0x1f/0x50
[112186.818106]  [<ffffffff8106bc1a>] ? __put_cred+0x3a/0x50
[112186.818106]  [<ffffffff8116427f>] ? sys_faccessat+0x16f/0x1b0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            S ffff88083ea32b28     0 23775   8292 0x00000000
[112186.818106]  ffff8808818758d8 0000000000000082 ffff880881874010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880881875fd8
[112186.818106]  ffff880881875fd8 0000000000012c80 ffff88083ea32580 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffffa042bfff>] ? igb_xmit_frame+0x5f/0xa0 [igb]
[112186.818106]  [<ffffffff813a46b0>] ? dev_hard_start_xmit+0x2e0/0x4f0
[112186.818106]  [<ffffffff813c2f07>] ? sch_direct_xmit+0x77/0x1d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81464d15>] schedule_hrtimeout_range_clock+0x115/0x130
[112186.818106]  [<ffffffff8107105e>] ? __wake_up+0x4e/0x70
[112186.818106]  [<ffffffff812efdba>] ? put_ldisc+0x5a/0xc0
[112186.818106]  [<ffffffff81464d3e>] schedule_hrtimeout_range+0xe/0x10
[112186.818106]  [<ffffffff81177e84>] poll_schedule_timeout+0x44/0x70
[112186.818106]  [<ffffffff81178a63>] do_select+0x603/0x6c0
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff8140a04b>] ? inet_recvmsg+0x4b/0x90
[112186.818106]  [<ffffffff8138dfc4>] ? __sock_recvmsg+0x84/0xa0
[112186.818106]  [<ffffffff811791ec>] core_sys_select+0x17c/0x290
[112186.818106]  [<ffffffff81032898>] ? __bad_area_nosemaphore+0x208/0x220
[112186.818106]  [<ffffffff81165351>] ? do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff810328be>] ? bad_area_nosemaphore+0xe/0x10
[112186.818106]  [<ffffffff8146af20>] ? do_page_fault+0x100/0x4b0
[112186.818106]  [<ffffffff8117955a>] sys_select+0x4a/0x110
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] bash            S ffff880867630100     0 23781  23775 0x00000000
[112186.818106]  ffff88084fd0fe48 0000000000000082 ffff88084fd0e010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88084fd0ffd8
[112186.818106]  ffff88084fd0ffd8 0000000000012c80 ffff880867630100 ffff8808970d43c0
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            S 00007fcdc3e7ae10     0 27038   8222 0x00000000
[112186.818106]  ffff88087c83fcc8 0000000000000082 ffff88087c83e010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087c83ffd8
[112186.818106]  ffff88087c83ffd8 0000000000012c80 ffff8808652ca3c0 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sh              S ffff88087a03e400     0 27039  27038 0x00000000
[112186.818106]  ffff88087de4fe48 0000000000000086 ffff88087de4e010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087de4ffd8
[112186.818106]  ffff88087de4ffd8 0000000000012c80 ffff88087a03e400 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81054be5>] ? do_sigaction+0x95/0x1e0
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] run-crons       S ffff880881dd6440     0 27040  27039 0x00000000
[112186.818106]  ffff88087ecc9e48 0000000000000082 ffff88087ecc8010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087ecc9fd8
[112186.818106]  ffff88087ecc9fd8 0000000000012c80 ffff880881dd6440 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81054be5>] ? do_sigaction+0x95/0x1e0
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] logrotate       S ffff8808581a4500     0 27057  27040 0x00000000
[112186.818106]  ffff88087d6ede48 0000000000000082 ffff88087d6ec010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087d6edfd8
[112186.818106]  ffff88087d6edfd8 0000000000012c80 ffff8808581a4500 ffff880897176180
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81054be5>] ? do_sigaction+0x95/0x1e0
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] logrotate       D ffff8808820f22d2     0 27060  27057 0x00000000
[112186.818106]  ffff880881cb7ab8 0000000000000082 ffff880881cb6010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880881cb7fd8
[112186.818106]  ffff880881cb7fd8 0000000000012c80 ffff8808677f2640 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffffa02c60f9>] ? do_get_write_access+0x329/0x4d0 [jbd]
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02ee9b6>] ? ext3_rename+0x2e6/0x650 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02ee9b6>] ext3_rename+0x2e6/0x650 [ext3]
[112186.818106]  [<ffffffff8117270f>] vfs_rename_other+0xef/0x140
[112186.818106]  [<ffffffff81172a2c>] vfs_rename+0xfc/0x1d0
[112186.818106]  [<ffffffff811753c8>] sys_renameat+0x268/0x270
[112186.818106]  [<ffffffff8116a0b3>] ? cp_new_stat+0xe3/0xf0
[112186.818106]  [<ffffffff8116a471>] ? sys_newstat+0x31/0x50
[112186.818106]  [<ffffffff811753e6>] sys_rename+0x16/0x20
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] tee             S 00007fff599befd0     0 27061  27057 0x00000000
[112186.818106]  ffff88087efabcc8 0000000000000082 ffff88087efaa010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087efabfd8
[112186.818106]  ffff88087efabfd8 0000000000012c80 ffff8808650cc0c0 ffff8808970c6300
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            D ffff880880505472     0 27203   8222 0x00000000
[112186.818106]  ffff88088328fa08 0000000000000082 ffff88088328e010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88088328ffd8
[112186.818106]  ffff88088328ffd8 0000000000012c80 ffff88085b784500 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff8110422a>] do_generic_file_read+0x1ba/0x460
[112186.818106]  [<ffffffff811027f0>] ? iov_iter_copy_from_user+0x140/0x140
[112186.818106]  [<ffffffff81104b02>] generic_file_aio_read+0x102/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            D ffff880880504a8a     0 27235   8222 0x00000000
[112186.818106]  ffff880885b95a08 0000000000000086 ffff880885b94010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880885b95fd8
[112186.818106]  ffff880885b95fd8 0000000000012c80 ffff88086770a640 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff8110422a>] do_generic_file_read+0x1ba/0x460
[112186.818106]  [<ffffffff811027f0>] ? iov_iter_copy_from_user+0x140/0x140
[112186.818106]  [<ffffffff81104b02>] generic_file_aio_read+0x102/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            D ffff880880504a8a     0 27266   8222 0x00000000
[112186.818106]  ffff88084fc41b18 0000000000000082 ffff88084fc40010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88084fc41fd8
[112186.818106]  ffff88084fc41fd8 0000000000012c80 ffff88085b6cc100 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8110a6b9>] ? get_page_from_freelist+0x289/0x6f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff81173f39>] path_openat+0x229/0x3f0
[112186.818106]  [<ffffffff81174213>] do_filp_open+0x43/0xa0
[112186.818106]  [<ffffffff81180f3a>] ? alloc_fd+0x4a/0x120
[112186.818106]  [<ffffffff81164aa2>] do_sys_open+0x162/0x1f0
[112186.818106]  [<ffffffff81164b6c>] sys_open+0x1c/0x20
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            D ffff880880504a8a     0 27298   8222 0x00000000
[112186.818106]  ffff8808653a9a08 0000000000000086 ffff8808653a8010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8808653a9fd8
[112186.818106]  ffff8808653a9fd8 0000000000012c80 ffff88088369e280 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff8112cf88>] ? handle_pte_fault+0x208/0x210
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff8146b07c>] ? do_page_fault+0x25c/0x4b0
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff8110422a>] do_generic_file_read+0x1ba/0x460
[112186.818106]  [<ffffffff811027f0>] ? iov_iter_copy_from_user+0x140/0x140
[112186.818106]  [<ffffffff81104b02>] generic_file_aio_read+0x102/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            D ffff880880504a8a     0 27342   8222 0x00000000
[112186.818106]  ffff88087d701b18 0000000000000086 ffff88087d700010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087d701fd8
[112186.818106]  ffff88087d701fd8 0000000000012c80 ffff88083e872580 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8110a6b9>] ? get_page_from_freelist+0x289/0x6f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff81173f39>] path_openat+0x229/0x3f0
[112186.818106]  [<ffffffff81128ac4>] ? tlb_flush_mmu+0x64/0x80
[112186.818106]  [<ffffffff81174213>] do_filp_open+0x43/0xa0
[112186.818106]  [<ffffffff81180f3a>] ? alloc_fd+0x4a/0x120
[112186.818106]  [<ffffffff81164aa2>] do_sys_open+0x162/0x1f0
[112186.818106]  [<ffffffff81164b6c>] sys_open+0x1c/0x20
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            D ffff880880504a8a     0 27348   8292 0x00000004
[112186.818106]  ffff88087a10fa08 0000000000000086 ffff88087a10e010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087a10ffd8
[112186.818106]  ffff88087a10ffd8 0000000000012c80 ffff88083ebf0680 ffff8808970c6300
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff8110422a>] do_generic_file_read+0x1ba/0x460
[112186.818106]  [<ffffffff811027f0>] ? iov_iter_copy_from_user+0x140/0x140
[112186.818106]  [<ffffffff81104b02>] generic_file_aio_read+0x102/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            S ffff880882d9b230     0 27351  27348 0x00000000
[112186.818106]  ffff88083e97dab8 0000000000000082 ffff88083e97c010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88083e97dfd8
[112186.818106]  ffff88083e97dfd8 0000000000012c80 ffff8808650e60c0 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81178966>] ? do_select+0x506/0x6c0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff814648a5>] schedule_timeout+0x215/0x2b0
[112186.818106]  [<ffffffff8114ebc6>] ? ksize+0x16/0x70
[112186.818106]  [<ffffffff8139753a>] ? __alloc_skb+0x8a/0x180
[112186.818106]  [<ffffffff81065eb9>] ? prepare_to_wait+0x59/0x90
[112186.818106]  [<ffffffff814327c7>] unix_stream_data_wait+0xb7/0x120
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff813e7956>] ? tcp_recvmsg+0x486/0xd90
[112186.818106]  [<ffffffff8143550f>] unix_stream_recvmsg+0x2af/0x680
[112186.818106]  [<ffffffff8138dfc4>] __sock_recvmsg+0x84/0xa0
[112186.818106]  [<ffffffff8138e0f1>] sock_aio_read+0x111/0x120
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165b46>] vfs_read+0x126/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            D ffff880880504a8a     0 27377   8222 0x00000000
[112186.818106]  ffff88084fd07b18 0000000000000086 ffff88084fd06010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88084fd07fd8
[112186.818106]  ffff88084fd07fd8 0000000000012c80 ffff88083e90c0c0 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8146b07c>] ? do_page_fault+0x25c/0x4b0
[112186.818106]  [<ffffffff8110a6b9>] ? get_page_from_freelist+0x289/0x6f0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff81173f39>] path_openat+0x229/0x3f0
[112186.818106]  [<ffffffff81128ac4>] ? tlb_flush_mmu+0x64/0x80
[112186.818106]  [<ffffffff81174213>] do_filp_open+0x43/0xa0
[112186.818106]  [<ffffffff81180f3a>] ? alloc_fd+0x4a/0x120
[112186.818106]  [<ffffffff81164aa2>] do_sys_open+0x162/0x1f0
[112186.818106]  [<ffffffff81164b6c>] sys_open+0x1c/0x20
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] top             D ffff880880560202     0 27388  21975 0x00000004
[112186.818106]  ffff88083eafda08 0000000000000082 ffff88083eafc010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88083eafdfd8
[112186.818106]  ffff88083eafdfd8 0000000000012c80 ffff88084fd72380 ffff880897176180
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff8110422a>] do_generic_file_read+0x1ba/0x460
[112186.818106]  [<ffffffff811027f0>] ? iov_iter_copy_from_user+0x140/0x140
[112186.818106]  [<ffffffff81104b02>] generic_file_aio_read+0x102/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            D ffff88087d164a22     0 27390   8292 0x00000004
[112186.818106]  ffff88087d619a08 0000000000000082 ffff88087d618010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087d619fd8
[112186.818106]  ffff88087d619fd8 0000000000012c80 ffff880865374400 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff8110422a>] do_generic_file_read+0x1ba/0x460
[112186.818106]  [<ffffffff811027f0>] ? iov_iter_copy_from_user+0x140/0x140
[112186.818106]  [<ffffffff81104b02>] generic_file_aio_read+0x102/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            S ffff880882d8a0b0     0 27393  27390 0x00000000
[112186.818106]  ffff88085b52fab8 0000000000000082 ffff88085b52e010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88085b52ffd8
[112186.818106]  ffff88085b52ffd8 0000000000012c80 ffff88086501a4c0 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81178966>] ? do_select+0x506/0x6c0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff814648a5>] schedule_timeout+0x215/0x2b0
[112186.818106]  [<ffffffff8114ebc6>] ? ksize+0x16/0x70
[112186.818106]  [<ffffffff8139753a>] ? __alloc_skb+0x8a/0x180
[112186.818106]  [<ffffffff81065eb9>] ? prepare_to_wait+0x59/0x90
[112186.818106]  [<ffffffff814327c7>] unix_stream_data_wait+0xb7/0x120
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff813e7956>] ? tcp_recvmsg+0x486/0xd90
[112186.818106]  [<ffffffff8143550f>] unix_stream_recvmsg+0x2af/0x680
[112186.818106]  [<ffffffff8138dfc4>] __sock_recvmsg+0x84/0xa0
[112186.818106]  [<ffffffff8138e0f1>] sock_aio_read+0x111/0x120
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165b46>] vfs_read+0x126/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            D ffff88087d164a22     0 27408   8292 0x00000004
[112186.818106]  ffff88087f1c7b18 0000000000000086 ffff88087f1c6010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087f1c7fd8
[112186.818106]  ffff88087f1c7fd8 0000000000012c80 ffff88088beb8200 ffff8808970c6300
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8110a6b9>] ? get_page_from_freelist+0x289/0x6f0
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff81173f39>] path_openat+0x229/0x3f0
[112186.818106]  [<ffffffff811332c4>] ? change_protection+0x4b4/0x4d0
[112186.818106]  [<ffffffff81174213>] do_filp_open+0x43/0xa0
[112186.818106]  [<ffffffff81180f3a>] ? alloc_fd+0x4a/0x120
[112186.818106]  [<ffffffff81164aa2>] do_sys_open+0x162/0x1f0
[112186.818106]  [<ffffffff811336ce>] ? sys_mprotect+0x13e/0x260
[112186.818106]  [<ffffffff81164b6c>] sys_open+0x1c/0x20
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            S ffff88087d6eb7b0     0 27411  27408 0x00000000
[112186.818106]  ffff88085800fab8 0000000000000086 ffff88085800e010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88085800ffd8
[112186.818106]  ffff88085800ffd8 0000000000012c80 ffff88083e8082c0 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81178966>] ? do_select+0x506/0x6c0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff814648a5>] schedule_timeout+0x215/0x2b0
[112186.818106]  [<ffffffff8114ebc6>] ? ksize+0x16/0x70
[112186.818106]  [<ffffffff8139753a>] ? __alloc_skb+0x8a/0x180
[112186.818106]  [<ffffffff81065eb9>] ? prepare_to_wait+0x59/0x90
[112186.818106]  [<ffffffff814327c7>] unix_stream_data_wait+0xb7/0x120
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff813e7956>] ? tcp_recvmsg+0x486/0xd90
[112186.818106]  [<ffffffff8143550f>] unix_stream_recvmsg+0x2af/0x680
[112186.818106]  [<ffffffff8138dfc4>] __sock_recvmsg+0x84/0xa0
[112186.818106]  [<ffffffff8138e0f1>] sock_aio_read+0x111/0x120
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165b46>] vfs_read+0x126/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            D ffff88087d164a22     0 27425   8222 0x00000000
[112186.818106]  ffff88087b54da08 0000000000000086 ffff88087b54c010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087b54dfd8
[112186.818106]  ffff88087b54dfd8 0000000000012c80 ffff880881828580 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff8110422a>] do_generic_file_read+0x1ba/0x460
[112186.818106]  [<ffffffff811027f0>] ? iov_iter_copy_from_user+0x140/0x140
[112186.818106]  [<ffffffff81104b02>] generic_file_aio_read+0x102/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            D ffff88087d164a22     0 27508   8292 0x00000004
[112186.818106]  ffff88087c8e3a08 0000000000000082 ffff88087c8e2010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087c8e3fd8
[112186.818106]  ffff88087c8e3fd8 0000000000012c80 ffff8808825d0140 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff8110422a>] do_generic_file_read+0x1ba/0x460
[112186.818106]  [<ffffffff811027f0>] ? iov_iter_copy_from_user+0x140/0x140
[112186.818106]  [<ffffffff81104b02>] generic_file_aio_read+0x102/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            S ffff880882c7e470     0 27511  27508 0x00000000
[112186.818106]  ffff88084fd15ab8 0000000000000086 ffff88084fd14010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88084fd15fd8
[112186.818106]  ffff88084fd15fd8 0000000000012c80 ffff88083eb12200 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81178966>] ? do_select+0x506/0x6c0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff814648a5>] schedule_timeout+0x215/0x2b0
[112186.818106]  [<ffffffff8114ebc6>] ? ksize+0x16/0x70
[112186.818106]  [<ffffffff8139753a>] ? __alloc_skb+0x8a/0x180
[112186.818106]  [<ffffffff81065eb9>] ? prepare_to_wait+0x59/0x90
[112186.818106]  [<ffffffff814327c7>] unix_stream_data_wait+0xb7/0x120
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff813e7956>] ? tcp_recvmsg+0x486/0xd90
[112186.818106]  [<ffffffff8143550f>] unix_stream_recvmsg+0x2af/0x680
[112186.818106]  [<ffffffff8138dfc4>] __sock_recvmsg+0x84/0xa0
[112186.818106]  [<ffffffff8138e0f1>] sock_aio_read+0x111/0x120
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165b46>] vfs_read+0x126/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            D ffff880880560202     0 27544   8222 0x00000000
[112186.818106]  ffff88083e9c1a08 0000000000000082 ffff88083e9c0010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88083e9c1fd8
[112186.818106]  ffff88083e9c1fd8 0000000000012c80 ffff88084fe800c0 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff8110422a>] do_generic_file_read+0x1ba/0x460
[112186.818106]  [<ffffffff811027f0>] ? iov_iter_copy_from_user+0x140/0x140
[112186.818106]  [<ffffffff81104b02>] generic_file_aio_read+0x102/0x290
[112186.818106]  [<ffffffff81172eb9>] ? do_last+0x3b9/0x800
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] ls              D 0000000000000000     0 27555  23781 0x00000000
[112186.818106]  ffff880858283e28 0000000000000082 ffff880858282010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880858283fd8
[112186.818106]  ffff880858283fd8 0000000000012c80 ffff88085b76c2c0 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf88>] ? handle_pte_fault+0x208/0x210
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] vi              D 0000000000000000     0 27561  23781 0x00000000
[112186.818106]  ffff88085b585ba8 0000000000000086 ffff88085b584010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88085b585fd8
[112186.818106]  ffff88085b585fd8 0000000000012c80 ffff88084fc36400 ffff88089715a040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff81178070>] ? __pollwait+0x100/0x100
[112186.818106]  [<ffffffff8107af58>] ? enqueue_sleeper+0x228/0x270
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466944>] __mutex_lock_slowpath+0xf4/0x170
[112186.818106]  [<ffffffff8146634e>] mutex_lock+0x1e/0x40
[112186.818106]  [<ffffffff81171f5f>] do_lookup+0x2af/0x310
[112186.818106]  [<ffffffff8117432f>] path_lookupat+0xbf/0x680
[112186.818106]  [<ffffffff81174920>] do_path_lookup+0x30/0xd0
[112186.818106]  [<ffffffff8117580b>] user_path_at_empty+0x7b/0xb0
[112186.818106]  [<ffffffff81217de8>] ? apparmor_inode_getattr+0x48/0x50
[112186.818106]  [<ffffffff8116a0b3>] ? cp_new_stat+0xe3/0xf0
[112186.818106]  [<ffffffff8117584c>] user_path_at+0xc/0x10
[112186.818106]  [<ffffffff8116a2d6>] vfs_fstatat+0x46/0x80
[112186.818106]  [<ffffffff8116a436>] vfs_stat+0x16/0x20
[112186.818106]  [<ffffffff8116a45f>] sys_newstat+0x1f/0x50
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            S ffff8807ac0c5da8     0 27563   8292 0x00000000
[112186.818106]  ffff8807ac0c5ad8 0000000000000082 ffff8807ac0c4010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807ac0c5fd8
[112186.818106]  ffff8807ac0c5fd8 0000000000012c80 ffff8808653e4480 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff814648a5>] schedule_timeout+0x215/0x2b0
[112186.818106]  [<ffffffff813932eb>] ? sock_alloc_send_pskb+0x24b/0x370
[112186.818106]  [<ffffffff81065e29>] ? prepare_to_wait_exclusive+0x59/0x90
[112186.818106]  [<ffffffff8143304c>] unix_wait_for_peer+0x8c/0xd0
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff813b615f>] ? sk_filter+0x1f/0xa0
[112186.818106]  [<ffffffff814343aa>] unix_dgram_sendmsg+0x48a/0x640
[112186.818106]  [<ffffffff813905a2>] sock_sendmsg+0x112/0x130
[112186.818106]  [<ffffffff81175085>] ? kern_path+0x25/0x50
[112186.818106]  [<ffffffff810499a2>] ? current_fs_time+0x22/0x30
[112186.818106]  [<ffffffff8116fffd>] ? path_put+0x1d/0x30
[112186.818106]  [<ffffffff814326c9>] ? unix_find_other+0x1b9/0x200
[112186.818106]  [<ffffffff81390715>] sys_sendto+0x105/0x140
[112186.818106]  [<ffffffff8138e878>] ? sys_connect+0xb8/0xd0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            S ffff88087fd29530     0 27566  27563 0x00000000
[112186.818106]  ffff88083eadbab8 0000000000000086 ffff88083eada010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88083eadbfd8
[112186.818106]  ffff88083eadbfd8 0000000000012c80 ffff88087a2c0540 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8114f93b>] ? cache_grow+0x1eb/0x2f0
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff814648a5>] schedule_timeout+0x215/0x2b0
[112186.818106]  [<ffffffff8114ebc6>] ? ksize+0x16/0x70
[112186.818106]  [<ffffffff8139753a>] ? __alloc_skb+0x8a/0x180
[112186.818106]  [<ffffffff81065eb9>] ? prepare_to_wait+0x59/0x90
[112186.818106]  [<ffffffff814327c7>] unix_stream_data_wait+0xb7/0x120
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8110ca96>] ? __alloc_pages_nodemask+0x136/0x1f0
[112186.818106]  [<ffffffff8143550f>] unix_stream_recvmsg+0x2af/0x680
[112186.818106]  [<ffffffff8138dfc4>] __sock_recvmsg+0x84/0xa0
[112186.818106]  [<ffffffff8138e0f1>] sock_aio_read+0x111/0x120
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165b46>] vfs_read+0x126/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            S 00007fcdc3e7ae10     0 27620   8222 0x00000000
[112186.818106]  ffff88085b597cc8 0000000000000086 ffff88085b596010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88085b597fd8
[112186.818106]  ffff88085b597fd8 0000000000012c80 ffff88086763c240 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            D ffff880880505472     0 27621  27620 0x00000000
[112186.818106]  ffff880865311a08 0000000000000082 ffff880865310010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880865311fd8
[112186.818106]  ffff880865311fd8 0000000000012c80 ffff8808580b6280 ffff880897352100
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff8110422a>] do_generic_file_read+0x1ba/0x460
[112186.818106]  [<ffffffff811027f0>] ? iov_iter_copy_from_user+0x140/0x140
[112186.818106]  [<ffffffff81104b02>] generic_file_aio_read+0x102/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            S ffff88087ca67da8     0 27673   8292 0x00000000
[112186.818106]  ffff88087ca67ad8 0000000000000086 ffff88087ca66010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087ca67fd8
[112186.818106]  ffff88087ca67fd8 0000000000012c80 ffff88085b508100 ffff8808970c6300
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff814648a5>] schedule_timeout+0x215/0x2b0
[112186.818106]  [<ffffffff813932eb>] ? sock_alloc_send_pskb+0x24b/0x370
[112186.818106]  [<ffffffff81065e29>] ? prepare_to_wait_exclusive+0x59/0x90
[112186.818106]  [<ffffffff8143304c>] unix_wait_for_peer+0x8c/0xd0
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff813b615f>] ? sk_filter+0x1f/0xa0
[112186.818106]  [<ffffffff814343aa>] unix_dgram_sendmsg+0x48a/0x640
[112186.818106]  [<ffffffff813905a2>] sock_sendmsg+0x112/0x130
[112186.818106]  [<ffffffff81175085>] ? kern_path+0x25/0x50
[112186.818106]  [<ffffffff810499a2>] ? current_fs_time+0x22/0x30
[112186.818106]  [<ffffffff8116fffd>] ? path_put+0x1d/0x30
[112186.818106]  [<ffffffff814326c9>] ? unix_find_other+0x1b9/0x200
[112186.818106]  [<ffffffff81390715>] sys_sendto+0x105/0x140
[112186.818106]  [<ffffffff8138e878>] ? sys_connect+0xb8/0xd0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            S ffff88088315b870     0 27676  27673 0x00000000
[112186.818106]  ffff88085804bab8 0000000000000082 ffff88085804a010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88085804bfd8
[112186.818106]  ffff88085804bfd8 0000000000012c80 ffff88084ff261c0 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8114f93b>] ? cache_grow+0x1eb/0x2f0
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff814648a5>] schedule_timeout+0x215/0x2b0
[112186.818106]  [<ffffffff8114ebc6>] ? ksize+0x16/0x70
[112186.818106]  [<ffffffff8139753a>] ? __alloc_skb+0x8a/0x180
[112186.818106]  [<ffffffff81065eb9>] ? prepare_to_wait+0x59/0x90
[112186.818106]  [<ffffffff814327c7>] unix_stream_data_wait+0xb7/0x120
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8110ca96>] ? __alloc_pages_nodemask+0x136/0x1f0
[112186.818106]  [<ffffffff8143550f>] unix_stream_recvmsg+0x2af/0x680
[112186.818106]  [<ffffffff8138dfc4>] __sock_recvmsg+0x84/0xa0
[112186.818106]  [<ffffffff8138e0f1>] sock_aio_read+0x111/0x120
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165b46>] vfs_read+0x126/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            S ffff88085818fda8     0 27749   8292 0x00000000
[112186.818106]  ffff88085818fad8 0000000000000086 ffff88085818e010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88085818ffd8
[112186.818106]  ffff88085818ffd8 0000000000012c80 ffff8808653e2180 ffff88083e932240
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff814648a5>] schedule_timeout+0x215/0x2b0
[112186.818106]  [<ffffffff813932eb>] ? sock_alloc_send_pskb+0x24b/0x370
[112186.818106]  [<ffffffff81065e29>] ? prepare_to_wait_exclusive+0x59/0x90
[112186.818106]  [<ffffffff8143304c>] unix_wait_for_peer+0x8c/0xd0
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff813b615f>] ? sk_filter+0x1f/0xa0
[112186.818106]  [<ffffffff814343aa>] unix_dgram_sendmsg+0x48a/0x640
[112186.818106]  [<ffffffff813905a2>] sock_sendmsg+0x112/0x130
[112186.818106]  [<ffffffff81175085>] ? kern_path+0x25/0x50
[112186.818106]  [<ffffffff810499a2>] ? current_fs_time+0x22/0x30
[112186.818106]  [<ffffffff8116fffd>] ? path_put+0x1d/0x30
[112186.818106]  [<ffffffff814326c9>] ? unix_find_other+0x1b9/0x200
[112186.818106]  [<ffffffff81390715>] sys_sendto+0x105/0x140
[112186.818106]  [<ffffffff8138e878>] ? sys_connect+0xb8/0xd0
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sshd            S ffff88087d46c4b0     0 27752  27749 0x00000000
[112186.818106]  ffff88087ccd1ab8 0000000000000082 ffff88087ccd0010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087ccd1fd8
[112186.818106]  ffff88087ccd1fd8 0000000000012c80 ffff88083e932240 ffff8808971b22c0
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff813de240>] ? ip_mc_output+0x260/0x260
[112186.818106]  [<ffffffff813de3c8>] ? ip_finish_output+0x188/0x300
[112186.818106]  [<ffffffff813dd7a6>] ? ip_output+0x66/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff814648a5>] schedule_timeout+0x215/0x2b0
[112186.818106]  [<ffffffff8114ebc6>] ? ksize+0x16/0x70
[112186.818106]  [<ffffffff8139753a>] ? __alloc_skb+0x8a/0x180
[112186.818106]  [<ffffffff81065eb9>] ? prepare_to_wait+0x59/0x90
[112186.818106]  [<ffffffff814327c7>] unix_stream_data_wait+0xb7/0x120
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8110ca96>] ? __alloc_pages_nodemask+0x136/0x1f0
[112186.818106]  [<ffffffff8143550f>] unix_stream_recvmsg+0x2af/0x680
[112186.818106]  [<ffffffff8138dfc4>] __sock_recvmsg+0x84/0xa0
[112186.818106]  [<ffffffff8138e0f1>] sock_aio_read+0x111/0x120
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165b46>] vfs_read+0x126/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            S 00007fcdc3e7ae10     0 27782   8222 0x00000000
[112186.818106]  ffff88088bd39cc8 0000000000000082 ffff88088bd38010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88088bd39fd8
[112186.818106]  ffff88088bd39fd8 0000000000012c80 ffff8808652ec0c0 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sh              S ffff88087efae100     0 27783  27782 0x00000000
[112186.818106]  ffff88086533de48 0000000000000082 ffff88086533c010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88086533dfd8
[112186.818106]  ffff88086533dfd8 0000000000012c80 ffff88087efae100 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81054be5>] ? do_sigaction+0x95/0x1e0
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] run-crons       D ffff880880505a22     0 27784  27783 0x00000000
[112186.818106]  ffff88085b73ba08 0000000000000082 ffff88085b73a010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88085b73bfd8
[112186.818106]  ffff88085b73bfd8 0000000000012c80 ffff88086763e140 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81111678>] ? lru_cache_add_lru+0x28/0x50
[112186.818106]  [<ffffffff811359c5>] ? page_add_new_anon_rmap+0x95/0xf0
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff8110422a>] do_generic_file_read+0x1ba/0x460
[112186.818106]  [<ffffffff811027f0>] ? iov_iter_copy_from_user+0x140/0x140
[112186.818106]  [<ffffffff81104b02>] generic_file_aio_read+0x102/0x290
[112186.818106]  [<ffffffff81127b65>] ? do_anonymous_page+0x115/0x350
[112186.818106]  [<ffffffff8112cf88>] ? handle_pte_fault+0x208/0x210
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            S ffff88084fc1a8e8     0 27883   8222 0x00000000
[112186.818106]  ffff8808583adcc8 0000000000000082 ffff8808583ac010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8808583adfd8
[112186.818106]  ffff8808583adfd8 0000000000012c80 ffff88084fc1a340 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sh              S ffff880865166928     0 27884  27883 0x00000000
[112186.818106]  ffff88087b841e48 0000000000000082 ffff88087b840010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087b841fd8
[112186.818106]  ffff88087b841fd8 0000000000012c80 ffff880865166380 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81054be5>] ? do_sigaction+0x95/0x1e0
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] run-crons       S ffff8807d673a968     0 27885  27884 0x00000000
[112186.818106]  ffff88087db4bcc8 0000000000000082 ffff88087db4a010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087db4bfd8
[112186.818106]  ffff88087db4bfd8 0000000000012c80 ffff8807d673a3c0 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811110bd>] ? pagevec_lru_move_fn+0xed/0x110
[112186.818106]  [<ffffffff811108c0>] ? pagevec_move_tail_fn+0xd0/0xd0
[112186.818106]  [<ffffffff811110f2>] ? __pagevec_lru_add+0x12/0x20
[112186.818106]  [<ffffffff81111635>] ? __lru_cache_add+0x95/0xb0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] find            D ffff880804cd0a68     0 27889  27885 0x00000000
[112186.818106]  ffff88087a1d5c68 0000000000000086 ffff88087a1d4010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087a1d5fd8
[112186.818106]  ffff88087a1d5fd8 0000000000012c80 ffff880804cd04c0 ffff88089715a040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02e8dab>] ? ext3_getblk+0xeb/0x1d0 [ext3]
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffffa02c6165>] do_get_write_access+0x395/0x4d0 [jbd]
[112186.818106]  [<ffffffff81065c60>] ? autoremove_wake_function+0x40/0x40
[112186.818106]  [<ffffffff81194c71>] ? __getblk+0x21/0x50
[112186.818106]  [<ffffffffa02c640c>] journal_get_write_access+0x2c/0x50 [jbd]
[112186.818106]  [<ffffffffa02fd04f>] __ext3_journal_get_write_access+0x2f/0x70 [ext3]
[112186.818106]  [<ffffffffa02e6213>] ext3_reserve_inode_write+0x83/0xa0 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffffa02e74da>] ext3_mark_inode_dirty+0x6a/0x90 [ext3]
[112186.818106]  [<ffffffffa02e7659>] ext3_dirty_inode+0x59/0x90 [ext3]
[112186.818106]  [<ffffffff8118d1fa>] __mark_inode_dirty+0x3a/0x240
[112186.818106]  [<ffffffff8117e06b>] touch_atime+0xfb/0x140
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff811779a4>] vfs_readdir+0xc4/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            S ffff8807d6734828     0 27952   8222 0x00000000
[112186.818106]  ffff880865149cc8 0000000000000086 ffff880865148010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880865149fd8
[112186.818106]  ffff880865149fd8 0000000000012c80 ffff8807d6734280 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sh              S ffff880858296868     0 27953  27952 0x00000000
[112186.818106]  ffff88085b523e48 0000000000000082 ffff88085b522010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88085b523fd8
[112186.818106]  ffff88085b523fd8 0000000000012c80 ffff8808582962c0 ffff88084fd321c0
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] run-crons       S ffff8808676e68a8     0 27954  27953 0x00000000
[112186.818106]  ffff88087ceadcc8 0000000000000086 ffff88087ceac010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087ceadfd8
[112186.818106]  ffff88087ceadfd8 0000000000012c80 ffff8808676e6300 ffff88089715a040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811110bd>] ? pagevec_lru_move_fn+0xed/0x110
[112186.818106]  [<ffffffff811108c0>] ? pagevec_move_tail_fn+0xd0/0xd0
[112186.818106]  [<ffffffff811110f2>] ? __pagevec_lru_add+0x12/0x20
[112186.818106]  [<ffffffff81111635>] ? __lru_cache_add+0x95/0xb0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] find            D ffff8807ac08c9a8     0 27958  27954 0x00000000
[112186.818106]  ffff88084ff81e28 0000000000000082 ffff88084ff80010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88084ff81fd8
[112186.818106]  ffff88084ff81fd8 0000000000012c80 ffff8807ac08c400 ffff8808971b22c0
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112ce12>] ? handle_pte_fault+0x92/0x210
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            S ffff880883d6aae8     0 27989   8222 0x00000000
[112186.818106]  ffff88085b7e7cc8 0000000000000082 ffff88085b7e6010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88085b7e7fd8
[112186.818106]  ffff88085b7e7fd8 0000000000012c80 ffff880883d6a540 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sh              S ffff88087c870b28     0 27990  27989 0x00000000
[112186.818106]  ffff88087c873e48 0000000000000082 ffff88087c872010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087c873fd8
[112186.818106]  ffff88087c873fd8 0000000000012c80 ffff88087c870580 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81054be5>] ? do_sigaction+0x95/0x1e0
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] run-crons       S ffff8807ac084b68     0 27991  27990 0x00000000
[112186.818106]  ffff8807ac087cc8 0000000000000086 ffff8807ac086010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807ac087fd8
[112186.818106]  ffff8807ac087fd8 0000000000012c80 ffff8807ac0845c0 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8115facb>] ? __mem_cgroup_commit_charge+0x12b/0x2b0
[112186.818106]  [<ffffffff8124c76d>] ? cpumask_any_but+0x2d/0x40
[112186.818106]  [<ffffffff81037bf0>] ? flush_tlb_page+0x40/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] find            D ffff88084ff985e8     0 27995  27991 0x00000000
[112186.818106]  ffff8807ac0a7e28 0000000000000082 ffff8807ac0a6010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807ac0a7fd8
[112186.818106]  ffff8807ac0a7fd8 0000000000012c80 ffff88084ff98040 ffff88089715a040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112ce12>] ? handle_pte_fault+0x92/0x210
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            S ffff88086758e828     0 28037   8222 0x00000000
[112186.818106]  ffff88084ffbbcc8 0000000000000086 ffff88084ffba010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88084ffbbfd8
[112186.818106]  ffff88084ffbbfd8 0000000000012c80 ffff88086758e280 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sh              S ffff88084ff86868     0 28038  28037 0x00000000
[112186.818106]  ffff88086752de48 0000000000000082 ffff88086752c010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88086752dfd8
[112186.818106]  ffff88086752dfd8 0000000000012c80 ffff88084ff862c0 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81054be5>] ? do_sigaction+0x95/0x1e0
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] run-crons       S ffff88087a3968a8     0 28039  28038 0x00000000
[112186.818106]  ffff88087a385cc8 0000000000000082 ffff88087a384010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087a385fd8
[112186.818106]  ffff88087a385fd8 0000000000012c80 ffff88087a396300 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8115facb>] ? __mem_cgroup_commit_charge+0x12b/0x2b0
[112186.818106]  [<ffffffff8124c76d>] ? cpumask_any_but+0x2d/0x40
[112186.818106]  [<ffffffff81037bf0>] ? flush_tlb_page+0x40/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] find            D ffff8807aa8269a8     0 28043  28039 0x00000000
[112186.818106]  ffff8807aa823e28 0000000000000086 ffff8807aa822010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807aa823fd8
[112186.818106]  ffff8807aa823fd8 0000000000012c80 ffff8807aa826400 ffff88089715a040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112ce12>] ? handle_pte_fault+0x92/0x210
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            S ffff8807ac09eb28     0 28075   8222 0x00000000
[112186.818106]  ffff88087a30dcc8 0000000000000086 ffff88087a30c010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087a30dfd8
[112186.818106]  ffff88087a30dfd8 0000000000012c80 ffff8807ac09e580 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8110ca96>] ? __alloc_pages_nodemask+0x136/0x1f0
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sh              S ffff88087ce30b68     0 28076  28075 0x00000000
[112186.818106]  ffff88087b75fe48 0000000000000082 ffff88087b75e010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087b75ffd8
[112186.818106]  ffff88087b75ffd8 0000000000012c80 ffff88087ce305c0 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81054be5>] ? do_sigaction+0x95/0x1e0
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] run-crons       S ffff88083e8dcba8     0 28077  28076 0x00000000
[112186.818106]  ffff88086511dcc8 0000000000000082 ffff88086511c010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88086511dfd8
[112186.818106]  ffff88086511dfd8 0000000000012c80 ffff88083e8dc600 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8115facb>] ? __mem_cgroup_commit_charge+0x12b/0x2b0
[112186.818106]  [<ffffffff8124c76d>] ? cpumask_any_but+0x2d/0x40
[112186.818106]  [<ffffffff81037bf0>] ? flush_tlb_page+0x40/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] find            D ffff88087a380628     0 28081  28077 0x00000000
[112186.818106]  ffff88084fd39e28 0000000000000086 ffff88084fd38010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88084fd39fd8
[112186.818106]  ffff88084fd39fd8 0000000000012c80 ffff88087a380080 ffff88089715a040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112ce12>] ? handle_pte_fault+0x92/0x210
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            S ffff8807aa8167a8     0 28113   8222 0x00000000
[112186.818106]  ffff8807aa811cc8 0000000000000082 ffff8807aa810010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807aa811fd8
[112186.818106]  ffff8807aa811fd8 0000000000012c80 ffff8807aa816200 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8110ca96>] ? __alloc_pages_nodemask+0x136/0x1f0
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sh              S ffff8808583947e8     0 28114  28113 0x00000000
[112186.818106]  ffff88087cef5e48 0000000000000082 ffff88087cef4010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087cef5fd8
[112186.818106]  ffff88087cef5fd8 0000000000012c80 ffff880858394240 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81054be5>] ? do_sigaction+0x95/0x1e0
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] run-crons       S ffff88084ffac828     0 28115  28114 0x00000000
[112186.818106]  ffff88084ffa9cc8 0000000000000082 ffff88084ffa8010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88084ffa9fd8
[112186.818106]  ffff88084ffa9fd8 0000000000012c80 ffff88084ffac280 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811110bd>] ? pagevec_lru_move_fn+0xed/0x110
[112186.818106]  [<ffffffff811108c0>] ? pagevec_move_tail_fn+0xd0/0xd0
[112186.818106]  [<ffffffff811110f2>] ? __pagevec_lru_add+0x12/0x20
[112186.818106]  [<ffffffff81111635>] ? __lru_cache_add+0x95/0xb0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] find            D ffff88087a3b2928     0 28119  28115 0x00000000
[112186.818106]  ffff88087a3b5e28 0000000000000082 ffff88087a3b4010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087a3b5fd8
[112186.818106]  ffff88087a3b5fd8 0000000000012c80 ffff88087a3b2380 ffff88089715a040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112ce12>] ? handle_pte_fault+0x92/0x210
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            S ffff8807aa838a28     0 28149   8222 0x00000000
[112186.818106]  ffff8807ac0bfcc8 0000000000000082 ffff8807ac0be010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807ac0bffd8
[112186.818106]  ffff8807ac0bffd8 0000000000012c80 ffff8807aa838480 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sh              S ffff8807aa808a68     0 28150  28149 0x00000000
[112186.818106]  ffff8807be81be48 0000000000000082 ffff8807be81a010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807be81bfd8
[112186.818106]  ffff8807be81bfd8 0000000000012c80 ffff8807aa8084c0 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81054be5>] ? do_sigaction+0x95/0x1e0
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] run-crons       S ffff8807be832aa8     0 28151  28150 0x00000000
[112186.818106]  ffff8807be835cc8 0000000000000082 ffff8807be834010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807be835fd8
[112186.818106]  ffff8807be835fd8 0000000000012c80 ffff8807be832500 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811110bd>] ? pagevec_lru_move_fn+0xed/0x110
[112186.818106]  [<ffffffff811108c0>] ? pagevec_move_tail_fn+0xd0/0xd0
[112186.818106]  [<ffffffff811110f2>] ? __pagevec_lru_add+0x12/0x20
[112186.818106]  [<ffffffff81111635>] ? __lru_cache_add+0x95/0xb0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] find            D ffff8807aa4d8ba8     0 28155  28151 0x00000000
[112186.818106]  ffff8807d64c3e28 0000000000000086 ffff8807d64c2010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807d64c3fd8
[112186.818106]  ffff8807d64c3fd8 0000000000012c80 ffff8807aa4d8600 ffff88089715a040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112ce12>] ? handle_pte_fault+0x92/0x210
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            S ffff8807aa4ec768     0 28197   8222 0x00000000
[112186.818106]  ffff8807be839cc8 0000000000000082 ffff8807be838010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807be839fd8
[112186.818106]  ffff8807be839fd8 0000000000012c80 ffff8807aa4ec1c0 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sh              S ffff8807ac8e67a8     0 28198  28197 0x00000000
[112186.818106]  ffff8807ac8e9e48 0000000000000086 ffff8807ac8e8010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807ac8e9fd8
[112186.818106]  ffff8807ac8e9fd8 0000000000012c80 ffff8807ac8e6200 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81054be5>] ? do_sigaction+0x95/0x1e0
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] run-crons       S ffff8807ae30a7e8     0 28199  28198 0x00000000
[112186.818106]  ffff8807ae30dcc8 0000000000000082 ffff8807ae30c010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807ae30dfd8
[112186.818106]  ffff8807ae30dfd8 0000000000012c80 ffff8807ae30a240 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8115facb>] ? __mem_cgroup_commit_charge+0x12b/0x2b0
[112186.818106]  [<ffffffff8124c76d>] ? cpumask_any_but+0x2d/0x40
[112186.818106]  [<ffffffff81037bf0>] ? flush_tlb_page+0x40/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] find            D ffff8807ae3328e8     0 28203  28199 0x00000000
[112186.818106]  ffff8807ae335e28 0000000000000086 ffff8807ae334010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807ae335fd8
[112186.818106]  ffff8807ae335fd8 0000000000012c80 ffff8807ae332340 ffff88089715a040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112ce12>] ? handle_pte_fault+0x92/0x210
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            S ffff8807bb7b0b68     0 28243   8222 0x00000000
[112186.818106]  ffff880867535cc8 0000000000000086 ffff880867534010 0000000000012c80
[112186.818106]  0000000000012c80
[112186.845727] [FUNC:<PLACP_RxCallbackFunc> LINE:<889>]
[112186.845729] [DRV_PLACP] PLACP_RxCallbackFunc: PLACP uninitialization! 0000000000012c80 0000000000012c80 ffff880867535fd8
[112186.818106]  ffff880867535fd8 0000000000012c80 ffff8807bb7b05c0 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sh              S ffff8807bb578ba8     0 28244  28243 0x00000000
[112186.818106]  ffff8807bb57be48 0000000000000086 ffff8807bb57a010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807bb57bfd8
[112186.818106]  ffff8807bb57bfd8 0000000000012c80 ffff8807bb578600 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81054be5>] ? do_sigaction+0x95/0x1e0
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] run-crons       S ffff8807aa4e6be8     0 28245  28244 0x00000000
[112186.818106]  ffff8807d65ddcc8 0000000000000086 ffff8807d65dc010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807d65ddfd8
[112186.818106]  ffff8807d65ddfd8 0000000000012c80 ffff8807aa4e6640 ffff88089711c580
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811110bd>] ? pagevec_lru_move_fn+0xed/0x110
[112186.818106]  [<ffffffff811108c0>] ? pagevec_move_tail_fn+0xd0/0xd0
[112186.818106]  [<ffffffff811110f2>] ? __pagevec_lru_add+0x12/0x20
[112186.818106]  [<ffffffff81111635>] ? __lru_cache_add+0x95/0xb0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] find            D ffff8807d70ec668     0 28249  28245 0x00000000
[112186.818106]  ffff8807d70efe28 0000000000000082 ffff8807d70ee010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807d70effd8
[112186.818106]  ffff8807d70effd8 0000000000012c80 ffff8807d70ec0c0 ffff880897176180
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112ce12>] ? handle_pte_fault+0x92/0x210
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            S ffff8807d64cc868     0 28283   8222 0x00000000
[112186.818106]  ffff8807bb7a3cc8 0000000000000082 ffff8807bb7a2010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807bb7a3fd8
[112186.818106]  ffff8807bb7a3fd8 0000000000012c80 ffff8807d64cc2c0 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sh              S ffff8807d64e48a8     0 28284  28283 0x00000000
[112186.818106]  ffff8807be807e48 0000000000000086 ffff8807be806010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807be807fd8
[112186.818106]  ffff8807be807fd8 0000000000012c80 ffff8807d64e4300 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81054be5>] ? do_sigaction+0x95/0x1e0
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] run-crons       S ffff8807bb78a8e8     0 28285  28284 0x00000000
[112186.818106]  ffff8807bb523cc8 0000000000000082 ffff8807bb522010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807bb523fd8
[112186.818106]  ffff8807bb523fd8 0000000000012c80 ffff8807bb78a340 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811110bd>] ? pagevec_lru_move_fn+0xed/0x110
[112186.818106]  [<ffffffff811108c0>] ? pagevec_move_tail_fn+0xd0/0xd0
[112186.818106]  [<ffffffff811110f2>] ? __pagevec_lru_add+0x12/0x20
[112186.818106]  [<ffffffff81111635>] ? __lru_cache_add+0x95/0xb0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] find            D ffff8807d75509e8     0 28289  28285 0x00000000
[112186.818106]  ffff8807d7553e28 0000000000000086 ffff8807d7552010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807d7553fd8
[112186.818106]  ffff8807d7553fd8 0000000000012c80 ffff8807d7550440 ffff88089715a040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112ce12>] ? handle_pte_fault+0x92/0x210
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            S ffff8807bb786b28     0 28320   8222 0x00000000
[112186.818106]  ffff8807d64e9cc8 0000000000000086 ffff8807d64e8010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807d64e9fd8
[112186.818106]  ffff8807d64e9fd8 0000000000012c80 ffff8807bb786580 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sh              S ffff8807d6738b68     0 28321  28320 0x00000000
[112186.818106]  ffff8807aa837e48 0000000000000086 ffff8807aa836010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807aa837fd8
[112186.818106]  ffff8807aa837fd8 0000000000012c80 ffff8807d67385c0 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81054be5>] ? do_sigaction+0x95/0x1e0
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] run-crons       S ffff8807d65d2ba8     0 28322  28321 0x00000000
[112186.818106]  ffff88087a11bcc8 0000000000000082 ffff88087a11a010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff88087a11bfd8
[112186.818106]  ffff88087a11bfd8 0000000000012c80 ffff8807d65d2600 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811110bd>] ? pagevec_lru_move_fn+0xed/0x110
[112186.818106]  [<ffffffff811108c0>] ? pagevec_move_tail_fn+0xd0/0xd0
[112186.818106]  [<ffffffff811110f2>] ? __pagevec_lru_add+0x12/0x20
[112186.818106]  [<ffffffff81111635>] ? __lru_cache_add+0x95/0xb0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] find            D ffff8807d755c628     0 28326  28322 0x00000000
[112186.818106]  ffff8807d755fe28 0000000000000082 ffff8807d755e010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807d755ffd8
[112186.818106]  ffff8807d755ffd8 0000000000012c80 ffff8807d755c080 ffff88089715a040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112ce12>] ? handle_pte_fault+0x92/0x210
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] cron            S ffff88087a3ae768     0 28357   8222 0x00000000
[112186.818106]  ffff8807aaab1cc8 0000000000000082 ffff8807aaab0010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807aaab1fd8
[112186.818106]  ffff8807aaab1fd8 0000000000012c80 ffff88087a3ae1c0 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sh              S ffff880804d927a8     0 28358  28357 0x00000000
[112186.818106]  ffff880867743e48 0000000000000082 ffff880867742010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880867743fd8
[112186.818106]  ffff880867743fd8 0000000000012c80 ffff880804d92200 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81054be5>] ? do_sigaction+0x95/0x1e0
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] run-crons       S ffff8807d65cc7e8     0 28359  28358 0x00000000
[112186.818106]  ffff880804dabcc8 0000000000000086 ffff880804daa010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880804dabfd8
[112186.818106]  ffff880804dabfd8 0000000000012c80 ffff8807d65cc240 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811110bd>] ? pagevec_lru_move_fn+0xed/0x110
[112186.818106]  [<ffffffff811108c0>] ? pagevec_move_tail_fn+0xd0/0xd0
[112186.818106]  [<ffffffff811110f2>] ? __pagevec_lru_add+0x12/0x20
[112186.818106]  [<ffffffff81111635>] ? __lru_cache_add+0x95/0xb0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] find            D ffff880804dfe8e8     0 28363  28359 0x00000000
[112186.818106]  ffff880804dd5e28 0000000000000082 ffff880804dd4010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880804dd5fd8
[112186.818106]  ffff880804dd5fd8 0000000000012c80 ffff880804dfe340 ffff88088430c180
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112ce12>] ? handle_pte_fault+0x92/0x210
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] kworker/u:2     S ffff880804db26a8     0 28388      2 0x00000000
[112186.818106]  ffff8807d65cfe40 0000000000000046 ffff8807d65ce010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807d65cffd8
[112186.818106]  ffff8807d65cffd8 0000000000012c80 ffff880804db2100 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff81077b6e>] ? try_to_wake_up+0x5e/0x390
[112186.818106]  [<ffffffff81077f02>] ? wake_up_process+0x22/0x40
[112186.818106]  [<ffffffff8105d756>] ? start_worker+0x26/0x30
[112186.818106]  [<ffffffff810606b0>] ? manage_workers+0x120/0x120
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8106091a>] worker_thread+0x26a/0x430
[112186.818106]  [<ffffffff810606b0>] ? manage_workers+0x120/0x120
[112186.818106]  [<ffffffff810606b0>] ? manage_workers+0x120/0x120
[112186.818106]  [<ffffffff8106556e>] kthread+0x9e/0xb0
[112186.818106]  [<ffffffff814708d4>] kernel_thread_helper+0x4/0x10
[112186.818106]  [<ffffffff810654d0>] ? kthread_freezable_should_stop+0x70/0x70
[112186.818106]  [<ffffffff814708d0>] ? gs_change+0x13/0x13
[112186.818106] kworker/u:1     S ffff8807ac8beb68     0 28407      2 0x00000000
[112186.818106]  ffff8807bb525e40 0000000000000046 ffff8807bb524010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807bb525fd8
[112186.818106]  ffff8807bb525fd8 0000000000012c80 ffff8807ac8be5c0 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff810537f3>] ? add_timer+0x13/0x20
[112186.818106]  [<ffffffff8105eb45>] ? queue_delayed_work_on+0xb5/0x190
[112186.818106]  [<ffffffff8105ec5c>] ? queue_delayed_work+0x1c/0x30
[112186.818106]  [<ffffffffa016c6db>] ? bond_mii_monitor+0xbb/0x160 [bonding]
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8106091a>] worker_thread+0x26a/0x430
[112186.818106]  [<ffffffff810606b0>] ? manage_workers+0x120/0x120
[112186.818106]  [<ffffffff8106556e>] kthread+0x9e/0xb0
[112186.818106]  [<ffffffff814708d4>] kernel_thread_helper+0x4/0x10
[112186.818106]  [<ffffffff810654d0>] ? kthread_freezable_should_stop+0x70/0x70
[112186.818106]  [<ffffffff814708d0>] ? gs_change+0x13/0x13
[112186.818106] cron            S ffff8807bb7a0ba8     0 28408   8222 0x00000000
[112186.818106]  ffff8807d678fcc8 0000000000000086 ffff8807d678e010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807d678ffd8
[112186.818106]  ffff8807d678ffd8 0000000000012c80 ffff8807bb7a0600 ffff880897314640
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff811031d9>] ? find_get_page+0x19/0xa0
[112186.818106]  [<ffffffff81103d29>] ? filemap_fault+0x89/0x3d0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff8114fac5>] ? cache_alloc_refill+0x85/0x290
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] sh              S ffff8807bb568be8     0 28409  28408 0x00000000
[112186.818106]  ffff880804d85e48 0000000000000082 ffff880804d84010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff880804d85fd8
[112186.818106]  ffff880804d85fd8 0000000000012c80 ffff8807bb568640 ffffffff81a13020
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112cf4d>] ? handle_pte_fault+0x1cd/0x210
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81047da9>] do_wait+0x219/0x250
[112186.818106]  [<ffffffff81047e81>] sys_wait4+0xa1/0xf0
[112186.818106]  [<ffffffff81046490>] ? wait_task_continued+0x170/0x170
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] run-crons       S ffff8807ac8f4c28     0 28410  28409 0x00000000
[112186.818106]  ffff8807d65dbcc8 0000000000000086 ffff8807d65da010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807d65dbfd8
[112186.818106]  ffff8807d65dbfd8 0000000000012c80 ffff8807ac8f4680 ffff880897100440
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8115facb>] ? __mem_cgroup_commit_charge+0x12b/0x2b0
[112186.818106]  [<ffffffff8124c76d>] ? cpumask_any_but+0x2d/0x40
[112186.818106]  [<ffffffff81037bf0>] ? flush_tlb_page+0x40/0xa0
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff8116e9b5>] pipe_wait+0x55/0x80
[112186.818106]  [<ffffffff81065c20>] ? wake_up_bit+0x40/0x40
[112186.818106]  [<ffffffff8116f456>] pipe_read+0x3e6/0x4f0
[112186.818106]  [<ffffffff81165351>] do_sync_read+0xe1/0x130
[112186.818106]  [<ffffffff811f3a03>] ? security_file_permission+0x93/0xa0
[112186.818106]  [<ffffffff81165ae8>] vfs_read+0xc8/0x130
[112186.818106]  [<ffffffff81165c40>] sys_read+0x50/0x90
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b
[112186.818106] find            D ffff8807bb78e6a8     0 28414  28410 0x00000000
[112186.818106]  ffff8807bb54be28 0000000000000086 ffff8807bb54a010 0000000000012c80
[112186.818106]  0000000000012c80 0000000000012c80 0000000000012c80 ffff8807bb54bfd8
[112186.818106]  ffff8807bb54bfd8 0000000000012c80 ffff8807bb78e100 ffff88089715a040
[112186.818106] Call Trace:
[112186.818106]  [<ffffffff8112ce12>] ? handle_pte_fault+0x92/0x210
[112186.818106]  [<ffffffff81173e0f>] ? path_openat+0xff/0x3f0
[112186.818106]  [<ffffffff8112d250>] ? handle_mm_fault+0x2c0/0x340
[112186.818106]  [<ffffffff81465f49>] schedule+0x29/0xa0
[112186.818106]  [<ffffffff81466269>] schedule_preempt_disabled+0x9/0x10
[112186.818106]  [<ffffffff81466524>] __mutex_lock_killable_slowpath+0x104/0x1c0
[112186.818106]  [<ffffffff81177650>] ? generic_block_fiemap+0x80/0x80
[112186.818106]  [<ffffffff81466615>] mutex_lock_killable+0x35/0x50
[112186.818106]  [<ffffffff81177962>] vfs_readdir+0x82/0xd0
[112186.818106]  [<ffffffff81177a33>] sys_getdents64+0x83/0xd0
[112186.818106]  [<ffffffff81467b75>] ? page_fault+0x25/0x30
[112186.818106]  [<ffffffff8146f579>] system_call_fastpath+0x16/0x1b

[112186.818106] ktime                                   : 112186846.820431
[112186.818106] sched_clk                               : 112044526.190186
[112186.818106] cpu_clk                                 : 112186818.106252
[112186.818106] jiffies                                 : 4322939007
[112186.818106] sched_clock_stable                      : 0
[112186.818106] 
[112186.818106] sysctl_sched
[112186.818106]   .sysctl_sched_latency                    : 24.000000
[112186.818106]   .sysctl_sched_min_granularity            : 3.000000
[112186.818106]   .sysctl_sched_wakeup_granularity         : 4.000000
[112186.818106]   .sysctl_sched_child_runs_first           : 0
[112186.818106]   .sysctl_sched_features                   : 24119
[112186.818106]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[112186.818106] 
[112186.818106] cpu#0, 2099.924 MHz
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .nr_switches                   : 334565964
[112186.818106]   .nr_load_updates               : 12809789
[112186.818106]   .nr_uninterruptible            : -50460
[112186.818106]   .next_balance                  : 4322.939005
[112186.818106]   .curr->pid                     : 0
[112186.818106]   .clock                         : 112186845.301555
[112186.818106]   .cpu_load[0]                   : 0
[112186.818106]   .cpu_load[1]                   : 0
[112186.818106]   .cpu_load[2]                   : 0
[112186.818106]   .cpu_load[3]                   : 0
[112186.818106]   .cpu_load[4]                   : 0
[112186.818106]   .yld_count                     : 356883
[112186.818106]   .sched_count                   : 334920800
[112186.818106]   .sched_goidle                  : 160244165
[112186.818106]   .avg_idle                      : 891402
[112186.818106]   .ttwu_count                    : 177023161
[112186.818106]   .ttwu_local                    : 126191158
[112186.818106] 
[112186.818106] cfs_rq[0]:/
[112186.818106]   .exec_clock                    : 5244900.092129
[112186.818106]   .MIN_vruntime                  : 0.000001
[112186.818106]   .min_vruntime                  : 561601.587454
[112186.818106]   .max_vruntime                  : 0.000001
[112186.818106]   .spread                        : 0.000000
[112186.818106]   .spread0                       : 0.000000
[112186.818106]   .nr_spread_over                : 3375
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .load_avg                      : 0.000000
[112186.818106]   .load_period                   : 0.000000
[112186.818106]   .load_contrib                  : 0
[112186.818106]   .load_tg                       : 0
[112186.818106] 
[112186.818106] rt_rq[0]:/
[112186.818106]   .rt_nr_running                 : 0
[112186.818106]   .rt_throttled                  : 0
[112186.818106]   .rt_time                       : 0.000000
[112186.818106]   .rt_runtime                    : 950.000000
[112186.818106]   .rt_nr_migratory               : 0
[112186.818106] 
[112186.818106] runnable tasks:
[112186.818106]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[112186.818106] ----------------------------------------------------------------------------------------------------------
[112186.818106] 
[112186.818106] cpu#1, 2099.924 MHz
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .nr_switches                   : 139245611
[112186.818106]   .nr_load_updates               : 7897685
[112186.818106]   .nr_uninterruptible            : 29993
[112186.818106]   .next_balance                  : 4322.938984
[112186.818106]   .curr->pid                     : 0
[112186.818106]   .clock                         : 112186801.205489
[112186.818106]   .cpu_load[0]                   : 0
[112186.818106]   .cpu_load[1]                   : 0
[112186.818106]   .cpu_load[2]                   : 0
[112186.818106]   .cpu_load[3]                   : 0
[112186.818106]   .cpu_load[4]                   : 0
[112186.818106]   .yld_count                     : 475387
[112186.818106]   .sched_count                   : 139721253
[112186.818106]   .sched_goidle                  : 62646710
[112186.818106]   .avg_idle                      : 1000000
[112186.818106]   .ttwu_count                    : 74087015
[112186.818106]   .ttwu_local                    : 26026128
[112186.818106] 
[112186.818106] cfs_rq[1]:/
[112186.818106]   .exec_clock                    : 3082467.413874
[112186.818106]   .MIN_vruntime                  : 0.000001
[112186.818106]   .min_vruntime                  : 447990.088784
[112186.818106]   .max_vruntime                  : 0.000001
[112186.818106]   .spread                        : 0.000000
[112186.818106]   .spread0                       : -113611.498670
[112186.818106]   .nr_spread_over                : 1780
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .load_avg                      : 0.000000
[112186.818106]   .load_period                   : 0.000000
[112186.818106]   .load_contrib                  : 0
[112186.818106]   .load_tg                       : 0
[112186.818106] 
[112186.818106] rt_rq[1]:/
[112186.818106]   .rt_nr_running                 : 0
[112186.818106]   .rt_throttled                  : 0
[112186.818106]   .rt_time                       : 0.000000
[112186.818106]   .rt_runtime                    : 950.000000
[112186.818106]   .rt_nr_migratory               : 0
[112186.818106] 
[112186.818106] runnable tasks:
[112186.818106]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[112186.818106] ----------------------------------------------------------------------------------------------------------
[112186.818106] 
[112186.818106] cpu#2, 2099.924 MHz
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .nr_switches                   : 139474454
[112186.818106]   .nr_load_updates               : 2537655
[112186.818106]   .nr_uninterruptible            : 583
[112186.818106]   .next_balance                  : 4322.938979
[112186.818106]   .curr->pid                     : 0
[112186.818106]   .clock                         : 112186752.045777
[112186.818106]   .cpu_load[0]                   : 0
[112186.818106]   .cpu_load[1]                   : 0
[112186.818106]   .cpu_load[2]                   : 0
[112186.818106]   .cpu_load[3]                   : 0
[112186.818106]   .cpu_load[4]                   : 0
[112186.818106]   .yld_count                     : 667170
[112186.818106]   .sched_count                   : 140141770
[112186.818106]   .sched_goidle                  : 62777565
[112186.818106]   .avg_idle                      : 1000000
[112186.818106]   .ttwu_count                    : 75762308
[112186.818106]   .ttwu_local                    : 27843969
[112186.818106] 
[112186.818106] cfs_rq[2]:/
[112186.818106]   .exec_clock                    : 3000452.262685
[112186.818106]   .MIN_vruntime                  : 0.000001
[112186.818106]   .min_vruntime                  : 419871.946533
[112186.818106]   .max_vruntime                  : 0.000001
[112186.818106]   .spread                        : 0.000000
[112186.818106]   .spread0                       : -141729.640921
[112186.818106]   .nr_spread_over                : 2031
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .load_avg                      : 0.000000
[112186.818106]   .load_period                   : 0.000000
[112186.818106]   .load_contrib                  : 0
[112186.818106]   .load_tg                       : 0
[112186.818106] 
[112186.818106] rt_rq[2]:/
[112186.818106]   .rt_nr_running                 : 0
[112186.818106]   .rt_throttled                  : 0
[112186.818106]   .rt_time                       : 0.000000
[112186.818106]   .rt_runtime                    : 950.000000
[112186.818106]   .rt_nr_migratory               : 0
[112186.818106] 
[112186.818106] runnable tasks:
[112186.818106]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[112186.818106] ----------------------------------------------------------------------------------------------------------
[112186.818106] 
[112186.818106] cpu#3, 2099.924 MHz
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .nr_switches                   : 136787902
[112186.818106]   .nr_load_updates               : 1640054
[112186.818106]   .nr_uninterruptible            : -280
[112186.818106]   .next_balance                  : 4322.938957
[112186.818106]   .curr->pid                     : 0
[112186.818106]   .clock                         : 112186216.032931
[112186.818106]   .cpu_load[0]                   : 0
[112186.818106]   .cpu_load[1]                   : 0
[112186.818106]   .cpu_load[2]                   : 0
[112186.818106]   .cpu_load[3]                   : 0
[112186.818106]   .cpu_load[4]                   : 0
[112186.818106]   .yld_count                     : 992013
[112186.818106]   .sched_count                   : 137780176
[112186.818106]   .sched_goidle                  : 61565520
[112186.818106]   .avg_idle                      : 1000000
[112186.818106]   .ttwu_count                    : 74286435
[112186.818106]   .ttwu_local                    : 26532563
[112186.818106] 
[112186.818106] cfs_rq[3]:/
[112186.818106]   .exec_clock                    : 2971153.994489
[112186.818106]   .MIN_vruntime                  : 0.000001
[112186.818106]   .min_vruntime                  : 409332.434065
[112186.818106]   .max_vruntime                  : 0.000001
[112186.818106]   .spread                        : 0.000000
[112186.818106]   .spread0                       : -152269.153389
[112186.818106]   .nr_spread_over                : 2020
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .load_avg                      : 0.000000
[112186.818106]   .load_period                   : 0.000000
[112186.818106]   .load_contrib                  : 0
[112186.818106]   .load_tg                       : 0
[112186.818106] 
[112186.818106] rt_rq[3]:/
[112186.818106]   .rt_nr_running                 : 0
[112186.818106]   .rt_throttled                  : 0
[112186.818106]   .rt_time                       : 0.000000
[112186.818106]   .rt_runtime                    : 950.000000
[112186.818106]   .rt_nr_migratory               : 0
[112186.818106] 
[112186.818106] runnable tasks:
[112186.818106]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[112186.818106] ----------------------------------------------------------------------------------------------------------
[112186.818106] 
[112186.818106] cpu#4, 2099.924 MHz
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .nr_switches                   : 139551354
[112186.818106]   .nr_load_updates               : 2736555
[112186.818106]   .nr_uninterruptible            : -629
[112186.818106]   .next_balance                  : 4322.938975
[112186.818106]   .curr->pid                     : 0
[112186.818106]   .clock                         : 112186721.558327
[112186.818106]   .cpu_load[0]                   : 0
[112186.818106]   .cpu_load[1]                   : 0
[112186.818106]   .cpu_load[2]                   : 0
[112186.818106]   .cpu_load[3]                   : 0
[112186.818106]   .cpu_load[4]                   : 0
[112186.818106]   .yld_count                     : 5066675
[112186.818106]   .sched_count                   : 144618150
[112186.818106]   .sched_goidle                  : 62863377
[112186.818106]   .avg_idle                      : 1000000
[112186.818106]   .ttwu_count                    : 75875184
[112186.818106]   .ttwu_local                    : 28038833
[112186.818106] 
[112186.818106] cfs_rq[4]:/
[112186.818106]   .exec_clock                    : 2987041.838027
[112186.818106]   .MIN_vruntime                  : 0.000001
[112186.818106]   .min_vruntime                  : 432696.206536
[112186.818106]   .max_vruntime                  : 0.000001
[112186.818106]   .spread                        : 0.000000
[112186.818106]   .spread0                       : -128905.380918
[112186.818106]   .nr_spread_over                : 2375
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .load_avg                      : 0.000000
[112186.818106]   .load_period                   : 0.000000
[112186.818106]   .load_contrib                  : 0
[112186.818106]   .load_tg                       : 0
[112186.818106] 
[112186.818106] rt_rq[4]:/
[112186.818106]   .rt_nr_running                 : 0
[112186.818106]   .rt_throttled                  : 0
[112186.818106]   .rt_time                       : 0.000000
[112186.818106]   .rt_runtime                    : 950.000000
[112186.818106]   .rt_nr_migratory               : 0
[112186.818106] 
[112186.818106] runnable tasks:
[112186.818106]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[112186.818106] ----------------------------------------------------------------------------------------------------------
[112186.818106] 
[112186.818106] cpu#5, 2099.924 MHz
[112186.818106]   .nr_running                    : 2
[112186.818106]   .load                          : 2048
[112186.818106]   .nr_switches                   : 137526531
[112186.818106]   .nr_load_updates               : 1642602
[112186.818106]   .nr_uninterruptible            : -225
[112186.818106]   .next_balance                  : 4322.938957
[112186.818106]   .curr->pid                     : 23084
[112186.818106]   .clock                         : 112186814.125461
[112186.818106]   .cpu_load[0]                   : 0
[112186.818106]   .cpu_load[1]                   : 0
[112186.818106]   .cpu_load[2]                   : 0
[112186.818106]   .cpu_load[3]                   : 0
[112186.818106]   .cpu_load[4]                   : 0
[112186.818106]   .yld_count                     : 431821
[112186.818106]   .sched_count                   : 137948296
[112186.818106]   .sched_goidle                  : 61835900
[112186.818106]   .avg_idle                      : 1000000
[112186.818106]   .ttwu_count                    : 74887944
[112186.818106]   .ttwu_local                    : 27010306
[112186.818106] 
[112186.818106] cfs_rq[5]:/
[112186.818106]   .exec_clock                    : 2968425.299186
[112186.818106]   .MIN_vruntime                  : 389998.566469
[112186.818106]   .min_vruntime                  : 390010.317287
[112186.818106]   .max_vruntime                  : 389998.566469
[112186.818106]   .spread                        : 0.000000
[112186.818106]   .spread0                       : -171591.270167
[112186.818106]   .nr_spread_over                : 1996
[112186.818106]   .nr_running                    : 2
[112186.818106]   .load                          : 2048
[112186.818106]   .load_avg                      : 0.000000
[112186.818106]   .load_period                   : 0.000000
[112186.818106]   .load_contrib                  : 0
[112186.818106]   .load_tg                       : 0
[112186.818106] 
[112186.818106] rt_rq[5]:/
[112186.818106]   .rt_nr_running                 : 0
[112186.818106]   .rt_throttled                  : 0
[112186.818106]   .rt_time                       : 0.000000
[112186.818106]   .rt_runtime                    : 950.000000
[112186.818106]   .rt_nr_migratory               : 0
[112186.818106] 
[112186.818106] runnable tasks:
[112186.818106]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[112186.818106] ----------------------------------------------------------------------------------------------------------
[112186.818106]      kworker/5:1   148    389998.566469    825848   120    389998.566469     38401.591232 112124351.039875 /
[112186.818106] R           bash 23084    389998.362349      2817   120    389998.362349       341.370042  87204832.161216 /
[112186.818106] 
[112186.818106] cpu#6, 2099.924 MHz
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .nr_switches                   : 138548467
[112186.818106]   .nr_load_updates               : 2012863
[112186.818106]   .nr_uninterruptible            : -42
[112186.818106]   .next_balance                  : 4322.938957
[112186.818106]   .curr->pid                     : 0
[112186.818106]   .clock                         : 112186640.042975
[112186.818106]   .cpu_load[0]                   : 0
[112186.818106]   .cpu_load[1]                   : 0
[112186.818106]   .cpu_load[2]                   : 0
[112186.818106]   .cpu_load[3]                   : 0
[112186.818106]   .cpu_load[4]                   : 0
[112186.818106]   .yld_count                     : 38592
[112186.818106]   .sched_count                   : 138586978
[112186.818106]   .sched_goidle                  : 62366512
[112186.818106]   .avg_idle                      : 1000000
[112186.818106]   .ttwu_count                    : 75423533
[112186.818106]   .ttwu_local                    : 27484160
[112186.818106] 
[112186.818106] cfs_rq[6]:/
[112186.818106]   .exec_clock                    : 2965958.214394
[112186.818106]   .MIN_vruntime                  : 0.000001
[112186.818106]   .min_vruntime                  : 364107.181869
[112186.818106]   .max_vruntime                  : 0.000001
[112186.818106]   .spread                        : 0.000000
[112186.818106]   .spread0                       : -197494.405585
[112186.818106]   .nr_spread_over                : 1843
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .load_avg                      : 0.000000
[112186.818106]   .load_period                   : 0.000000
[112186.818106]   .load_contrib                  : 0
[112186.818106]   .load_tg                       : 0
[112186.818106] 
[112186.818106] rt_rq[6]:/
[112186.818106]   .rt_nr_running                 : 0
[112186.818106]   .rt_throttled                  : 0
[112186.818106]   .rt_time                       : 0.000000
[112186.818106]   .rt_runtime                    : 950.000000
[112186.818106]   .rt_nr_migratory               : 0
[112186.818106] 
[112186.818106] runnable tasks:
[112186.818106]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[112186.818106] ----------------------------------------------------------------------------------------------------------
[112186.818106] 
[112186.818106] cpu#7, 2099.924 MHz
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .nr_switches                   : 137863337
[112186.818106]   .nr_load_updates               : 1613753
[112186.818106]   .nr_uninterruptible            : -113
[112186.818106]   .next_balance                  : 4322.938975
[112186.818106]   .curr->pid                     : 0
[112186.818106]   .clock                         : 112186839.118215
[112186.818106]   .cpu_load[0]                   : 0
[112186.818106]   .cpu_load[1]                   : 0
[112186.818106]   .cpu_load[2]                   : 0
[112186.818106]   .cpu_load[3]                   : 0
[112186.818106]   .cpu_load[4]                   : 0
[112186.818106]   .yld_count                     : 93358
[112186.818106]   .sched_count                   : 137945314
[112186.818106]   .sched_goidle                  : 61930817
[112186.818106]   .avg_idle                      : 1000000
[112186.818106]   .ttwu_count                    : 75172429
[112186.818106]   .ttwu_local                    : 27259517
[112186.818106] 
[112186.818106] cfs_rq[7]:/
[112186.818106]   .exec_clock                    : 2971590.898283
[112186.818106]   .MIN_vruntime                  : 0.000001
[112186.818106]   .min_vruntime                  : 376421.036433
[112186.818106]   .max_vruntime                  : 0.000001
[112186.818106]   .spread                        : 0.000000
[112186.818106]   .spread0                       : -185180.551021
[112186.818106]   .nr_spread_over                : 1852
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .load_avg                      : 0.000000
[112186.818106]   .load_period                   : 0.000000
[112186.818106]   .load_contrib                  : 0
[112186.818106]   .load_tg                       : 0
[112186.818106] 
[112186.818106] rt_rq[7]:/
[112186.818106]   .rt_nr_running                 : 0
[112186.818106]   .rt_throttled                  : 0
[112186.818106]   .rt_time                       : 0.000000
[112186.818106]   .rt_runtime                    : 950.000000
[112186.818106]   .rt_nr_migratory               : 0
[112186.818106] 
[112186.818106] runnable tasks:
[112186.818106]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[112186.818106] ----------------------------------------------------------------------------------------------------------
[112186.818106] 
[112186.818106] cpu#8, 2099.924 MHz
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .nr_switches                   : 74689336
[112186.818106]   .nr_load_updates               : 1364964
[112186.818106]   .nr_uninterruptible            : 3065
[112186.818106]   .next_balance                  : 4322.938957
[112186.818106]   .curr->pid                     : 0
[112186.818106]   .clock                         : 112186488.030783
[112186.818106]   .cpu_load[0]                   : 0
[112186.818106]   .cpu_load[1]                   : 0
[112186.818106]   .cpu_load[2]                   : 0
[112186.818106]   .cpu_load[3]                   : 0
[112186.818106]   .cpu_load[4]                   : 0
[112186.818106]   .yld_count                     : 380497
[112186.818106]   .sched_count                   : 75069846
[112186.818106]   .sched_goidle                  : 35150232
[112186.818106]   .avg_idle                      : 1000000
[112186.818106]   .ttwu_count                    : 39126242
[112186.818106]   .ttwu_local                    : 30196030
[112186.818106] 
[112186.818106] cfs_rq[8]:/
[112186.818106]   .exec_clock                    : 1476526.469738
[112186.818106]   .MIN_vruntime                  : 0.000001
[112186.818106]   .min_vruntime                  : 391903.518962
[112186.818106]   .max_vruntime                  : 0.000001
[112186.818106]   .spread                        : 0.000000
[112186.818106]   .spread0                       : -169698.068492
[112186.818106]   .nr_spread_over                : 966
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .load_avg                      : 0.000000
[112186.818106]   .load_period                   : 0.000000
[112186.818106]   .load_contrib                  : 0
[112186.818106]   .load_tg                       : 0
[112186.818106] 
[112186.818106] rt_rq[8]:/
[112186.818106]   .rt_nr_running                 : 0
[112186.818106]   .rt_throttled                  : 0
[112186.818106]   .rt_time                       : 0.000000
[112186.818106]   .rt_runtime                    : 950.000000
[112186.818106]   .rt_nr_migratory               : 0
[112186.818106] 
[112186.818106] runnable tasks:
[112186.818106]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[112186.818106] ----------------------------------------------------------------------------------------------------------
[112186.818106] 
[112186.818106] cpu#9, 2099.924 MHz
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .nr_switches                   : 78161692
[112186.818106]   .nr_load_updates               : 1381764
[112186.818106]   .nr_uninterruptible            : 3087
[112186.818106]   .next_balance                  : 4322.938975
[112186.818106]   .curr->pid                     : 0
[112186.818106]   .clock                         : 112186801.742163
[112186.818106]   .cpu_load[0]                   : 0
[112186.818106]   .cpu_load[1]                   : 0
[112186.818106]   .cpu_load[2]                   : 0
[112186.818106]   .cpu_load[3]                   : 0
[112186.818106]   .cpu_load[4]                   : 0
[112186.818106]   .yld_count                     : 577303
[112186.818106]   .sched_count                   : 78739025
[112186.818106]   .sched_goidle                  : 36872935
[112186.818106]   .avg_idle                      : 1000000
[112186.818106]   .ttwu_count                    : 40965522
[112186.818106]   .ttwu_local                    : 31963259
[112186.818106] 
[112186.818106] cfs_rq[9]:/
[112186.818106]   .exec_clock                    : 1507643.876022
[112186.818106]   .MIN_vruntime                  : 0.000001
[112186.818106]   .min_vruntime                  : 308275.505157
[112186.818106]   .max_vruntime                  : 0.000001
[112186.818106]   .spread                        : 0.000000
[112186.818106]   .spread0                       : -253326.082297
[112186.818106]   .nr_spread_over                : 1406
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .load_avg                      : 0.000000
[112186.818106]   .load_period                   : 0.000000
[112186.818106]   .load_contrib                  : 0
[112186.818106]   .load_tg                       : 0
[112186.818106] 
[112186.818106] rt_rq[9]:/
[112186.818106]   .rt_nr_running                 : 0
[112186.818106]   .rt_throttled                  : 0
[112186.818106]   .rt_time                       : 0.000000
[112186.818106]   .rt_runtime                    : 950.000000
[112186.818106]   .rt_nr_migratory               : 0
[112186.818106] 
[112186.818106] runnable tasks:
[112186.818106]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[112186.818106] ----------------------------------------------------------------------------------------------------------
[112186.818106] 
[112186.818106] cpu#10, 2099.924 MHz
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .nr_switches                   : 79379983
[112186.818106]   .nr_load_updates               : 1371269
[112186.818106]   .nr_uninterruptible            : 2552
[112186.818106]   .next_balance                  : 4322.938995
[112186.818106]   .curr->pid                     : 0
[112186.818106]   .clock                         : 112186792.049733
[112186.818106]   .cpu_load[0]                   : 0
[112186.818106]   .cpu_load[1]                   : 0
[112186.818106]   .cpu_load[2]                   : 0
[112186.818106]   .cpu_load[3]                   : 0
[112186.818106]   .cpu_load[4]                   : 0
[112186.818106]   .yld_count                     : 173681
[112186.818106]   .sched_count                   : 79553682
[112186.818106]   .sched_goidle                  : 37463427
[112186.818106]   .avg_idle                      : 1000000
[112186.818106]   .ttwu_count                    : 41604054
[112186.818106]   .ttwu_local                    : 32605747
[112186.818106] 
[112186.818106] cfs_rq[10]:/
[112186.818106]   .exec_clock                    : 1517685.002961
[112186.818106]   .MIN_vruntime                  : 0.000001
[112186.818106]   .min_vruntime                  : 321745.061635
[112186.818106]   .max_vruntime                  : 0.000001
[112186.818106]   .spread                        : 0.000000
[112186.818106]   .spread0                       : -239856.525819
[112186.818106]   .nr_spread_over                : 1525
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .load_avg                      : 0.000000
[112186.818106]   .load_period                   : 0.000000
[112186.818106]   .load_contrib                  : 0
[112186.818106]   .load_tg                       : 0
[112186.818106] 
[112186.818106] rt_rq[10]:/
[112186.818106]   .rt_nr_running                 : 0
[112186.818106]   .rt_throttled                  : 0
[112186.818106]   .rt_time                       : 0.000000
[112186.818106]   .rt_runtime                    : 950.000000
[112186.818106]   .rt_nr_migratory               : 0
[112186.818106] 
[112186.818106] runnable tasks:
[112186.818106]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[112186.818106] ----------------------------------------------------------------------------------------------------------
[112186.818106] 
[112186.818106] cpu#11, 2099.924 MHz
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .nr_switches                   : 77730110
[112186.818106]   .nr_load_updates               : 1368054
[112186.818106]   .nr_uninterruptible            : 2853
[112186.818106]   .next_balance                  : 4322.938957
[112186.818106]   .curr->pid                     : 0
[112186.818106]   .clock                         : 112186016.035078
[112186.818106]   .cpu_load[0]                   : 0
[112186.818106]   .cpu_load[1]                   : 0
[112186.818106]   .cpu_load[2]                   : 0
[112186.818106]   .cpu_load[3]                   : 0
[112186.818106]   .cpu_load[4]                   : 0
[112186.818106]   .yld_count                     : 191833
[112186.818106]   .sched_count                   : 77921969
[112186.818106]   .sched_goidle                  : 36643379
[112186.818106]   .avg_idle                      : 1000000
[112186.818106]   .ttwu_count                    : 40751633
[112186.818106]   .ttwu_local                    : 31778495
[112186.818106] 
[112186.818106] cfs_rq[11]:/
[112186.818106]   .exec_clock                    : 1508299.796184
[112186.818106]   .MIN_vruntime                  : 0.000001
[112186.818106]   .min_vruntime                  : 323187.128258
[112186.818106]   .max_vruntime                  : 0.000001
[112186.818106]   .spread                        : 0.000000
[112186.818106]   .spread0                       : -238414.459196
[112186.818106]   .nr_spread_over                : 1750
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .load_avg                      : 0.000000
[112186.818106]   .load_period                   : 0.000000
[112186.818106]   .load_contrib                  : 0
[112186.818106]   .load_tg                       : 0
[112186.818106] 
[112186.818106] rt_rq[11]:/
[112186.818106]   .rt_nr_running                 : 0
[112186.818106]   .rt_throttled                  : 0
[112186.818106]   .rt_time                       : 0.000000
[112186.818106]   .rt_runtime                    : 950.000000
[112186.818106]   .rt_nr_migratory               : 0
[112186.818106] 
[112186.818106] runnable tasks:
[112186.818106]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[112186.818106] ----------------------------------------------------------------------------------------------------------
[112186.818106] 
[112186.818106] cpu#12, 2099.924 MHz
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .nr_switches                   : 77617712
[112186.818106]   .nr_load_updates               : 1366434
[112186.818106]   .nr_uninterruptible            : 2564
[112186.818106]   .next_balance                  : 4322.938957
[112186.818106]   .curr->pid                     : 0
[112186.818106]   .clock                         : 112185904.047455
[112186.818106]   .cpu_load[0]                   : 0
[112186.818106]   .cpu_load[1]                   : 0
[112186.818106]   .cpu_load[2]                   : 0
[112186.818106]   .cpu_load[3]                   : 0
[112186.818106]   .cpu_load[4]                   : 0
[112186.818106]   .yld_count                     : 1020624
[112186.818106]   .sched_count                   : 78638402
[112186.818106]   .sched_goidle                  : 36601358
[112186.818106]   .avg_idle                      : 1000000
[112186.818106]   .ttwu_count                    : 40655586
[112186.818106]   .ttwu_local                    : 31673197
[112186.818106] 
[112186.818106] cfs_rq[12]:/
[112186.818106]   .exec_clock                    : 1512646.517590
[112186.818106]   .MIN_vruntime                  : 0.000001
[112186.818106]   .min_vruntime                  : 307605.339888
[112186.818106]   .max_vruntime                  : 0.000001
[112186.818106]   .spread                        : 0.000000
[112186.818106]   .spread0                       : -253996.247566
[112186.818106]   .nr_spread_over                : 1417
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .load_avg                      : 0.000000
[112186.818106]   .load_period                   : 0.000000
[112186.818106]   .load_contrib                  : 0
[112186.818106]   .load_tg                       : 0
[112186.818106] 
[112186.818106] rt_rq[12]:/
[112186.818106]   .rt_nr_running                 : 0
[112186.818106]   .rt_throttled                  : 0
[112186.818106]   .rt_time                       : 0.000000
[112186.818106]   .rt_runtime                    : 950.000000
[112186.818106]   .rt_nr_migratory               : 0
[112186.818106] 
[112186.818106] runnable tasks:
[112186.818106]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[112186.818106] ----------------------------------------------------------------------------------------------------------
[112186.818106] 
[112186.818106] cpu#13, 2099.924 MHz
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .nr_switches                   : 75560545
[112186.818106]   .nr_load_updates               : 1358696
[112186.818106]   .nr_uninterruptible            : 2526
[112186.818106]   .next_balance                  : 4322.938981
[112186.818106]   .curr->pid                     : 0
[112186.818106]   .clock                         : 112186736.035760
[112186.818106]   .cpu_load[0]                   : 0
[112186.818106]   .cpu_load[1]                   : 0
[112186.818106]   .cpu_load[2]                   : 0
[112186.818106]   .cpu_load[3]                   : 0
[112186.818106]   .cpu_load[4]                   : 0
[112186.818106]   .yld_count                     : 128337
[112186.818106]   .sched_count                   : 75688900
[112186.818106]   .sched_goidle                  : 35564308
[112186.818106]   .avg_idle                      : 1000000
[112186.818106]   .ttwu_count                    : 39654196
[112186.818106]   .ttwu_local                    : 30664221
[112186.818106] 
[112186.818106] cfs_rq[13]:/
[112186.818106]   .exec_clock                    : 1483778.293893
[112186.818106]   .MIN_vruntime                  : 0.000001
[112186.818106]   .min_vruntime                  : 287723.642592
[112186.818106]   .max_vruntime                  : 0.000001
[112186.818106]   .spread                        : 0.000000
[112186.818106]   .spread0                       : -273877.944862
[112186.818106]   .nr_spread_over                : 1158
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .load_avg                      : 0.000000
[112186.818106]   .load_period                   : 0.000000
[112186.818106]   .load_contrib                  : 0
[112186.818106]   .load_tg                       : 0
[112186.818106] 
[112186.818106] rt_rq[13]:/
[112186.818106]   .rt_nr_running                 : 0
[112186.818106]   .rt_throttled                  : 0
[112186.818106]   .rt_time                       : 0.000000
[112186.818106]   .rt_runtime                    : 950.000000
[112186.818106]   .rt_nr_migratory               : 0
[112186.818106] 
[112186.818106] runnable tasks:
[112186.818106]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[112186.818106] ----------------------------------------------------------------------------------------------------------
[112186.818106] 
[112186.818106] cpu#14, 2099.924 MHz
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .nr_switches                   : 77915680
[112186.818106]   .nr_load_updates               : 1365423
[112186.818106]   .nr_uninterruptible            : 2045
[112186.818106]   .next_balance                  : 4322.938957
[112186.818106]   .curr->pid                     : 0
[112186.818106]   .clock                         : 112186268.055956
[112186.818106]   .cpu_load[0]                   : 0
[112186.818106]   .cpu_load[1]                   : 0
[112186.818106]   .cpu_load[2]                   : 0
[112186.818106]   .cpu_load[3]                   : 0
[112186.818106]   .cpu_load[4]                   : 0
[112186.818106]   .yld_count                     : 588809
[112186.818106]   .sched_count                   : 78504151
[112186.818106]   .sched_goidle                  : 36745956
[112186.818106]   .avg_idle                      : 1000000
[112186.818106]   .ttwu_count                    : 40809752
[112186.818106]   .ttwu_local                    : 31810714
[112186.818106] 
[112186.818106] cfs_rq[14]:/
[112186.818106]   .exec_clock                    : 1506975.997876
[112186.818106]   .MIN_vruntime                  : 0.000001
[112186.818106]   .min_vruntime                  : 299414.502841
[112186.818106]   .max_vruntime                  : 0.000001
[112186.818106]   .spread                        : 0.000000
[112186.818106]   .spread0                       : -262187.084613
[112186.818106]   .nr_spread_over                : 1189
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .load_avg                      : 0.000000
[112186.818106]   .load_period                   : 0.000000
[112186.818106]   .load_contrib                  : 0
[112186.818106]   .load_tg                       : 0
[112186.818106] 
[112186.818106] rt_rq[14]:/
[112186.818106]   .rt_nr_running                 : 0
[112186.818106]   .rt_throttled                  : 0
[112186.818106]   .rt_time                       : 0.000000
[112186.818106]   .rt_runtime                    : 950.000000
[112186.818106]   .rt_nr_migratory               : 0
[112186.818106] 
[112186.818106] runnable tasks:
[112186.818106]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[112186.818106] ----------------------------------------------------------------------------------------------------------
[112186.818106] 
[112186.818106] cpu#15, 2099.924 MHz
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .nr_switches                   : 77529856
[112186.818106]   .nr_load_updates               : 1364452
[112186.818106]   .nr_uninterruptible            : 2620
[112186.818106]   .next_balance                  : 4322.938957
[112186.818106]   .curr->pid                     : 0
[112186.818106]   .clock                         : 112186426.130808
[112186.818106]   .cpu_load[0]                   : 0
[112186.818106]   .cpu_load[1]                   : 0
[112186.818106]   .cpu_load[2]                   : 0
[112186.818106]   .cpu_load[3]                   : 0
[112186.818106]   .cpu_load[4]                   : 0
[112186.818106]   .yld_count                     : 656709
[112186.818106]   .sched_count                   : 78186616
[112186.818106]   .sched_goidle                  : 36534477
[112186.818106]   .avg_idle                      : 1000000
[112186.818106]   .ttwu_count                    : 40577355
[112186.818106]   .ttwu_local                    : 31563530
[112186.818106] 
[112186.818106] cfs_rq[15]:/
[112186.818106]   .exec_clock                    : 1501628.276407
[112186.818106]   .MIN_vruntime                  : 0.000001
[112186.818106]   .min_vruntime                  : 301450.548163
[112186.818106]   .max_vruntime                  : 0.000001
[112186.818106]   .spread                        : 0.000000
[112186.818106]   .spread0                       : -260151.039291
[112186.818106]   .nr_spread_over                : 1229
[112186.818106]   .nr_running                    : 0
[112186.818106]   .load                          : 0
[112186.818106]   .load_avg                      : 0.000000
[112186.818106]   .load_period                   : 0.000000
[112186.818106]   .load_contrib                  : 0
[112186.818106]   .load_tg                       : 0
[112186.818106] 
[112186.818106] rt_rq[15]:/
[112186.818106]   .rt_nr_running                 : 0
[112186.818106]   .rt_throttled                  : 0
[112186.818106]   .rt_time                       : 0.000000
[112186.818106]   .rt_runtime                    : 950.000000
[112186.818106]   .rt_nr_migratory               : 0
[112186.818106] 
[112186.818106] runnable tasks:
[112186.818106]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[112186.818106] ----------------------------------------------------------------------------------------------------------
[112186.818106] 


--------------050805010707080200000205--
