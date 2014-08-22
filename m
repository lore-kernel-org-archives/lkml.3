Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbaHVMis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:38:48 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49960 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbaHVMiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:38:46 -0400
Message-ID: <53F739C2.8070809@linaro.org>
Date: Fri, 22 Aug 2014 20:38:26 +0800
From: "zhichang.yuan" <zhichang.yuan@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
CC: Deepak Saxena <dsaxena@linaro.org>, linux-kernel@vger.kernel.org
Subject: Some questions about DEBUG_PAGEALLOC on ARMv8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin, Will,

I am working to implement the DEBUG_PAGEALLOC on ARMv8.
After i investigated the DEBUG_PAGEALLOC implementation on x86 arch, some questions are standing in the way to
start coding.

1. How to handle the large page when DEBUG_PAGEALLOC is enabled
In ARMv8, the kernel direct memory page table entries will set the block flag for better performance. When
DEBUG_PAGEALLOC is configured, if the size of freed page is not multiply of page block size, there is no
corresponding page table entry. In the old x86 kernel version, the large page to be freed will be split into
normal page size and build the corresponding PTEs. And afterwards, someone done a patch to remove the
splitting process. It will make the code simpler and easily stable.

I prefer the current design in x86, what are your thoughts here?
 
2. Does ARMv8 support HIBERNATION?

The HIBERNATION has some dependency on DEBUG_PAGEALLOC.
It seems that current kernel does not support hibernation, does it?


3. Is the hypothesis of DEBUG_PAGEALLOC always true?

>From the x86 code, DEBUG_PAGEALLOC use the invalid page table entries to catch the accesses to free pages.
This mechanism is based on the hypothesis that all the corresponding page table entries that are corresponding
to the free pages are cleared correctly. Supposed this condition is always true, what we need to do is just to
clear the kernel linear mapping page entries, since those page tables are fixable after initialization.
DEBUG_PAGEALLOC on x86 seems to do like that.

Is it possible the hypothesis will be broken?
If the answer is yes, DEBUG_PAGEALLOC can catch the accesses to free page with kernel linear mapping address.
But if the virtual address is from other mapped areas and target to the free pages, DEBUG_PAGEALLOC will do
nothing.

Is this result the original objective of DEBUG_PAGEALLOC?
I can not find the initial commit log in kernel Git, i am not sure about it.


Thanks!
Zhichang
