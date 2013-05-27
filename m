Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3E0Bts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 21:49:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50532 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718Ab3E0Btr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 21:49:47 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51A2BBA7.50607@jp.fujitsu.com>
Date: Mon, 27 May 2013 10:49:27 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Maxim Uvarov <muvarov@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
        hughd@google.com, jingbai.ma@hp.com,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        linux-kernel@vger.kernel.org, lisa.mitchell@hp.com, linux-mm@kvack.org,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        kosaki.motohiro@jp.fujitsu.com, zhangyanfei@cn.fujitsu.com,
        walken@google.com, Cliff Wickman <cpw@sgi.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v8 9/9] vmcore: support mmap() on /proc/vmcore
References: <20130523052421.13864.83978.stgit@localhost6.localdomain6> <20130523052547.13864.83306.stgit@localhost6.localdomain6> <20130523152445.17549682ae45b5aab3f3cde0@linux-foundation.org> <CAJGZr0LwivLTH+E7WAR1B9_6B4e=jv04KgCUL_PdVpi9JjDpBw@mail.gmail.com>
In-Reply-To: <CAJGZr0LwivLTH+E7WAR1B9_6B4e=jv04KgCUL_PdVpi9JjDpBw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/05/24 18:02), Maxim Uvarov wrote:
>
>
>
> 2013/5/24 Andrew Morton <akpm@linux-foundation.org <mailto:akpm@linux-foundation.org>>
>
>     On Thu, 23 May 2013 14:25:48 +0900 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com <mailto:d.hatayama@jp.fujitsu.com>> wrote:
>
>      > This patch introduces mmap_vmcore().
>      >
>      > Don't permit writable nor executable mapping even with mprotect()
>      > because this mmap() is aimed at reading crash dump memory.
>      > Non-writable mapping is also requirement of remap_pfn_range() when
>      > mapping linear pages on non-consecutive physical pages; see
>      > is_cow_mapping().
>      >
>      > Set VM_MIXEDMAP flag to remap memory by remap_pfn_range and by
>      > remap_vmalloc_range_pertial at the same time for a single
>      > vma. do_munmap() can correctly clean partially remapped vma with two
>      > functions in abnormal case. See zap_pte_range(), vm_normal_page() and
>      > their comments for details.
>      >
>      > On x86-32 PAE kernels, mmap() supports at most 16TB memory only. This
>      > limitation comes from the fact that the third argument of
>      > remap_pfn_range(), pfn, is of 32-bit length on x86-32: unsigned long.
>
>     More reviewing and testing, please.
>
>
> Do you have git pull for both kernel and userland changes? I would like to do some more testing on my machines.
>
> Maxim.

Thanks! That's very helpful.

-- 
Thanks.
HATAYAMA, Daisuke

