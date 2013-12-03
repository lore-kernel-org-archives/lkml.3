Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3LCBSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 20:18:33 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59457 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3LCBSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 20:18:32 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <529D3158.2080603@jp.fujitsu.com>
Date: Tue, 03 Dec 2013 10:18:16 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: Re: [PATCH] vmcore: call remap_pfn_range() separately for respective
 partial pages
References: <52970342.8090302@jp.fujitsu.com> <20131202152754.GC18642@redhat.com>
In-Reply-To: <20131202152754.GC18642@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/03 0:27), Vivek Goyal wrote:
> On Thu, Nov 28, 2013 at 05:48:02PM +0900, HATAYAMA Daisuke wrote:
>> Hello Vivek,
>>
>> Here is a patch set for mmap failure for /proc/vmcore.
>> Could you try to use this on the problematic system?
>>
>> This patch doesn't copy partial pages to the 2nd kernel, only prepares
>> vmcore objects for respective partial pages to invoke remap_pfn_range()
>> for individual partial pages.
>
> Hi Hatayama,
>
> Thanks for the patch. Ok, I see that partial pages will be put in a separate
> call to remap_oldmem_pfn_range() and this time it should succeed.
>
> I am wondering what do you think about your old approach of copying
> only relevant old memory to a new kernel page in new kernel. I kind
> of feel little uncomfortable with the idea of rounding down start
> and roudning up end to page size boundaries and then accessing the
> full page using oldmem interface. A safer approach might be to allocate
> page in new kernel, read *only* those bytes as reported by elf header
> and fill rest of the page with zeros.
>
> Thanks
> Vivek
>

Even if copying partial pages into the 2nd kernel, we need to use ioremap()
once on them, and I think the ioremap() is exactly similar to
remap_pfn_range() for a single page. There seems no difference on safeness
between them.

Also, current /proc/vmcore shows user-land tools a shape with holes not
filled with zeros both in case of read() and in case of mmap(). If we adapt
copying one without reading data in holes, shape of /proc/vmcore gets
changed again.

-- 
Thanks.
HATAYAMA, Daisuke

