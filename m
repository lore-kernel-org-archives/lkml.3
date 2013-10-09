Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab3JIKPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 06:15:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59158 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab3JIKPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 06:15:14 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <52552C9F.2030404@jp.fujitsu.com>
Date: Wed, 09 Oct 2013 19:14:55 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vivek Goyal <vgoyal@redhat.com>, Jan Willeke <willeke@de.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org
Subject: Re: mmap for /proc/vmcore broken since 3.12-rc1
References: <20131002140356.63706540@holzheu>	<524D0ADF.2010507@jp.fujitsu.com>	<52521FA5.3040101@jp.fujitsu.com> <CACVxJT8S7kA92=80DWVmVJJvbnaQ6WkyvsiFq4wP37WHV=tfuA@mail.gmail.com>
In-Reply-To: <CACVxJT8S7kA92=80DWVmVJJvbnaQ6WkyvsiFq4wP37WHV=tfuA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(2013/10/08 21:49), Alexey Dobriyan wrote:
> On Mon, Oct 7, 2013 at 5:42 AM, HATAYAMA Daisuke
> <d.hatayama@jp.fujitsu.com> wrote:
>
>> +static unsigned long
>> +get_unmapped_area_vmcore(struct file *filp, unsigned long addr,
>> +                        unsigned long len, unsigned long pgoff,
>> +                        unsigned long flags)
>> +{
>> +#ifdef CONFIG_MMU
>> +       return current->mm->get_unmapped_area(filp, addr, len, pgoff,
>> flags);
>> +#else
>> +       return -EIO;
>> +#endif
>> +}
>> +
>>   static const struct file_operations proc_vmcore_operations = {
>>          .read           = read_vmcore,
>>          .llseek         = default_llseek,
>>          .mmap           = mmap_vmcore,
>> +       .get_unmapped_area = get_unmapped_area_vmcore,
>
> I think current->mm->get_unmapped_area should be used by core proc code.

What do you actually suggest here? You mean moving this code in proc code?
I don't think you suggest so.

> ENOMEM bug looks unrelated though.
>

Next step I'll do is to look into vm_unmapped_region() that looks for
for a region fit to a given mmap request and returns its address.
In particular, I'll focus on when vm_unmapped_region() could return
kernel-space address.

-- 
Thanks.
HATAYAMA, Daisuke

