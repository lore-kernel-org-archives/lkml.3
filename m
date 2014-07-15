Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbaGOKzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:55:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:57978 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932516AbaGOKzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:55:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,664,1400050800"; 
   d="scan'208";a="561994804"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Ingo Korb <ingo.korb@tu-dortmund.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Ning Qu <quning@google.com>, Dave Jones <davej@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CALYGNiM9Fu9-i7hXMQNTUP69RfydN+2NqO29wZYd+4Gn25GbCQ@mail.gmail.com>
References: <748020aaaf5c5c2924a16232313e0175.squirrel@webmail.tu-dortmund.de>
 <alpine.LSU.2.11.1407141209160.17242@eggly.anvils>
 <CALYGNiM9Fu9-i7hXMQNTUP69RfydN+2NqO29wZYd+4Gn25GbCQ@mail.gmail.com>
Subject: Re: PROBLEM: repeated remap_file_pages on tmpfs triggers bug on
 process exit
Content-Transfer-Encoding: 7bit
Message-Id: <20140715105547.C4832E00A3@blue.fi.intel.com>
Date: Tue, 15 Jul 2014 13:55:47 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Khlebnikov wrote:
> It seems boundng logic in do_fault_around is wrong:
> 
> start_addr = max(address & fault_around_mask(), vma->vm_start);
> off = ((address - start_addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
> pte -= off;
> pgoff -= off;
> 
> Ok, off  <= 511, but it might be bigger than pte offset in pte table.

I don't see how it possible: fault_around_mask() cannot be more than 0x1ff000
(x86-64, fault_around_bytes == 2M). It means start_addr will be aligned to 2M
boundary in this case which is start of the page table pte belong to.

Do I miss something?

-- 
 Kirill A. Shutemov
