Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab3FGBCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 21:02:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60794 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3FGBCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 21:02:30 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51B130F9.8070408@jp.fujitsu.com>
Date: Fri, 07 Jun 2013 10:01:45 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org,
        cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH v8 9/9] vmcore: support mmap() on /proc/vmcore
References: <20130523052421.13864.83978.stgit@localhost6.localdomain6> <20130523052547.13864.83306.stgit@localhost6.localdomain6> <10307835.fkACLi6FUD@wuerfel>
In-Reply-To: <10307835.fkACLi6FUD@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/07 6:31), Arnd Bergmann wrote:
> On Thursday 23 May 2013 14:25:48 HATAYAMA Daisuke wrote:
>> This patch introduces mmap_vmcore().
>>
>> Don't permit writable nor executable mapping even with mprotect()
>> because this mmap() is aimed at reading crash dump memory.
>> Non-writable mapping is also requirement of remap_pfn_range() when
>> mapping linear pages on non-consecutive physical pages; see
>> is_cow_mapping().
>>
>> Set VM_MIXEDMAP flag to remap memory by remap_pfn_range and by
>> remap_vmalloc_range_pertial at the same time for a single
>> vma. do_munmap() can correctly clean partially remapped vma with two
>> functions in abnormal case. See zap_pte_range(), vm_normal_page() and
>> their comments for details.
>>
>> On x86-32 PAE kernels, mmap() supports at most 16TB memory only. This
>> limitation comes from the fact that the third argument of
>> remap_pfn_range(), pfn, is of 32-bit length on x86-32: unsigned long.
>>
>> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
>> Acked-by: Vivek Goyal <vgoyal@redhat.com>
>
> I get build errors on 'make randconfig' from this, when building
> NOMMU kernels on ARM. I suppose the new feature should be hidden
> in #ifdef CONFIG_MMU.
>
> 	Arnd
>

Thanks for trying the build and your report!

OTOH, I don't have no-MMU architectures; x86 box only. I cannot reproduce this build error. Could you give me your build log? I want to use it to detect what part depends on CONFIG_MMU.

-- 
Thanks.
HATAYAMA, Daisuke

