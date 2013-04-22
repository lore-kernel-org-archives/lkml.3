Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab3DVLMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 07:12:41 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:1265 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab3DVLMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 07:12:40 -0400
Message-ID: <51751B21.4080505@hp.com>
Date: Mon, 22 Apr 2013 19:12:33 +0800
From: Jingbai Ma <jingbai.ma@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        zhangyanfei@cn.fujitsu.com,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>,
        "kumagai-atsushi@mxc.nes.nec.co.jp" 
	<kumagai-atsushi@mxc.nes.nec.co.jp>,
        "Eric W. Biederman" <ebiederm@xmission.com>, cpw@sgi.com,
        akpm@linux-foundation.org, "yinghai@kernel.org" <yinghai@kernel.org>
CC: jingbai.ma@hp.com, "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: makedumpfile parallel dumping test
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have done some experiments on parallel kernel dumping. I would like to 
share the test result with you. Hope it helps.

Test environment:
Machine: HP ProLiant DL980 G7 with 4TB RAM.
CPU: Intel(R) Xeon(R) CPU E7- 2860  @ 2.27GHz (8 sockets, 10 cores) (4 
CPU were enabled the 2nd kernel by nr_cpus=4)
Kernel 3.9.0-rc7
kexec-tools 2.0.4
makedumpfile v1.5.3 with lzo library
crashkernel=4096M (I have tested with 2048M but failed with OOM on 3 or 
4 parallels dumping in cyclic mode)

I didn't get a real multipath storage device, so I just put dump files 
on 4 different disks via 3 HP Smart Array controllers. (mounted on /0, 
/1, /2 and /3 in the capture kernel)

Measured time like this (for example: lzo compression, non-cyclic, 4 
parallels):
time makedumpfile -l -non-cyclic --split --message-level 23 -d 31 
/proc/vmcore /0/vmcore_0 /1/vmcore_1 /2/vmcore_2 /3/vmcore_3

I run several tests with different option, parallels from 1 to 4, and 
combined with zlib and lzo compression.

Test result:
-----------------------------------------------------------------
|               |Parallels 1|Parallels 2|Parallels 3|Parallels 4|
-----------------------------------------------------------------
|zlib cyclic    | 42m25.321s|  34m0.168s| 29m44.908s| 28m50.387s|
-----------------------------------------------------------------
|zlib non-cyclic|  42m7.842s| 28m28.275s| 23m25.750s|  21m6.476s|
-----------------------------------------------------------------
|lzo cyclic     | 23m40.010s| 18m19.932s| 21m47.903s| 22m47.605s|
-----------------------------------------------------------------
|lzo non-cyclic | 20m45.749s| 16m42.045s| 15m41.070s| 15m18.605s|
-----------------------------------------------------------------


-- 
Thanks,
Jingbai Ma
