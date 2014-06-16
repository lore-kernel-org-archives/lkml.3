Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaFPEUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 00:20:05 -0400
Received: from [119.145.14.65] ([119.145.14.65]:25912 "EHLO
	szxga02-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaFPEUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 00:20:03 -0400
Message-ID: <539E7006.3010000@huawei.com>
Date: Mon, 16 Jun 2014 12:18:14 +0800
From: Weng Meiling <wengmeiling.weng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <adilger.kernel@dilger.ca>,
        Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: Re: [linux 3.4 question] reboot command stall when vdbench test
References: <5397FC71.8020403@huawei.com> <53981100.7030404@huawei.com> <20140611121214.GD3661@quack.suse.cz>
In-Reply-To: <20140611121214.GD3661@quack.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.66]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/11 20:12, Jan Kara wrote:
>   Hello,
> 
> On Wed 11-06-14 16:19:12, Weng Meiling wrote:
>> We run vdbench test in our suse system with kernel 3.4, the vdbench test
>> is about different block size seq and rand read/write. Before the vdbench
>   Hum, this looks like some relatively old (not supported anymore)
> openSUSE, right?
> 
>> test, we had did some test about: disk message lookup, raid rebuild(note
>> we use hard raid: SAS2008 RAID).
>>
>> we used nohup to run the vdbench test script:
>>
>> #nohup ./vdbench_batch_test &
>>
>> During test,  we cat the result file:
>>
>> #cat nohup.out
>>
>> at this time, the cat command stalled, then try to reboot, but the system
>> didn't reboot, and the reboot also stalled, shutdown gone to uninterruptible
>> sleep:
>   Yeah, looking at the logs from sysrq, the machine seems to be waiting for
> IO to complete which never happened. Most often I've seen this happening
> because of a bug in driver for the hardware raid sometimes also because of
> a bug in the firmware of the card itself. So I'd update the card firmware
> to the latest version and check changes to the driver since the kernel
> version you run.
> 

Thanks for your reply, we will check if there are some suspicious points in
the driver and firmware.

Weng Meiling
Thanks!
>> root     21716  0.0  0.0   4276   556 ?        D    18:31   0:00 cat nohup.out
>> root     21726  0.0  0.0  17880  2876 ?        Ds   18:33   0:00 -bash
>> root     21868  0.0  0.0   8224   740 ?        D    19:03   0:00 shutdown -r 0 w
>> root     21892  0.0  0.0  17880  2884 ?        Ds   19:11   0:00 -bash
>> root     21967  0.0  0.0   8224   740 ?        D    19:19   0:00 shutdown -r 0 w
>> root     21970  0.0  0.0  86044  3680 ?        Ss   19:19   0:00 sshd: root@pts/4
>> root     21975  0.0  0.0  17880  2880 pts/4    Ss   19:19   0:00 -bash
>> root     22000  0.0  0.0  12932  1280 pts/4    T    19:20   0:00 top
>>
>> after several hours the system gone to dead, all the ssh connect stalled,
>> we can't connect to this server any more. The status kept for a week,
>> finally we had to reboot the system by power key. After system reboot, we
>> done the same steps to try to reproduce the problem for more than a
>> month, but it didn't happen again.
>>
>> We had analysed the code and lock information according the call trace,
>> also review linux 3.4+ mainline patch to find similar problem fix, but no
>> result.
>>
>> Many others met the similar problem because use SAN/NFS/multipath devices, but we don't use none of these.
>>
>> The attachments are our test program and dmesg information we get by
>> sysrq before system dead.  Does anyone met the problem before? Any
>> suggestion is appreciative. Thanks!
> 
> 								Honza
> 


