Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab3C0Fvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 01:51:43 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:11098 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab3C0Fvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 01:51:42 -0400
Message-ID: <515288E9.2070707@hp.com>
Date: Wed, 27 Mar 2013 13:51:37 +0800
From: Jingbai Ma <jingbai.ma@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, vgoyal@redhat.com,
        ebiederm@xmission.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>,
        akpm@linux-foundation.org
CC: jingbai.ma@hp.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp
Subject: makedumpfile mmap() benchmark
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
In-Reply-To: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have tested the makedumpfile mmap patch on a machine with 2TB memory, 
here is testing results:
Test environment:
Machine: HP ProLiant DL980 G7 with 2TB RAM.
CPU: Intel(R) Xeon(R) CPU E7- 2860  @ 2.27GHz (8 sockets, 10 cores)
(Only 1 cpu was enabled the 2nd kernel)
Kernel: 3.9.0-rc3+ with mmap kernel patch v3
vmcore size: 2.0TB
Dump file size: 3.6GB
makedumpfile mmap branch with parameters: -c --message-level 23 -d 31 
--map-size <map-size>
All measured time from debug message of makedumpfile.

As a comparison, I also have tested with original kernel and original 
makedumpfile 1.5.1 and 1.5.3.
I added all [Excluding unnecessary pages] and [Excluding free pages] 
time together as "Filter Pages", and [Copyying Data] as "Copy data" here.

makedumjpfile	Kernel	map-size (KB)	Filter pages (s)	Copy data (s)	Total (s)
1.5.1	 3.7.0-0.36.el7.x86_64	N/A	940.28	1269.25	2209.53
1.5.3	 3.7.0-0.36.el7.x86_64	N/A	380.09	992.77	1372.86
1.5.3	v3.9-rc3	N/A	197.77	892.27	1090.04
1.5.3+mmap	v3.9-rc3+mmap	0	164.87	606.06	770.93
1.5.3+mmap	v3.9-rc3+mmap	4	88.62	576.07	664.69
1.5.3+mmap	v3.9-rc3+mmap	1024	83.66	477.23	560.89
1.5.3+mmap	v3.9-rc3+mmap	2048	83.44	477.21	560.65
1.5.3+mmap	v3.9-rc3+mmap	10240	83.84	476.56	560.4


Thanks,
Jingbai Ma
