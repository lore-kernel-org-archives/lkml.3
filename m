Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3JCGNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:13:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33477 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab3JCGNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:13:24 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <524D0ADF.2010507@jp.fujitsu.com>
Date: Thu, 03 Oct 2013 15:12:47 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: mmap for /proc/vmcore broken since 3.12-rc1
References: <20131002140356.63706540@holzheu>
In-Reply-To: <20131002140356.63706540@holzheu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/02 21:03), Michael Holzheu wrote:
> Hello Alexey,
>
> Looks like the following commit broke mmap for /proc/vmcore:
>
> commit c4fe24485729fc2cbff324c111e67a1cc2f9adea
> Author: Alexey Dobriyan <adobriyan@gmail.com>
> Date:   Tue Aug 20 22:17:24 2013 +0300
>
>      sparc: fix PCI device proc file mmap(2)
>
> Because /proc/vmcore (fs/proc/vmcore.c) does not implement the
> get_unmapped_area() fops function mmap now always returns EIO.
>
> Michael
>

I confirmed the bug on v3.12-rc3. According to makedumpfile's log,
mmap failed on /proc/vmcore.

mem_map (271)
   mem_map    : ffffea001da40000
   pfn_start  : 878000
   pfn_end    : 880000
Kernel can't mmap vmcore, using reads.
STEP [Excluding unnecessary pages] : 1.268799 seconds
STEP [Excluding unnecessary pages] : 1.268756 seconds
STEP [Copying data               ] : 44.847924 seconds
Writing erase info...

I'll post a patch later.

-- 
Thanks.
HATAYAMA, Daisuke

