Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab3IHQ46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 12:56:58 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:36140 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab3IHQ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 12:56:57 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andi Kleen <andi@firstfloor.org>,
        Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        kirill.shutemov@linux.intel.com, Alex Thorlton <athorlton@sgi.com>,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH 2/2] thp: support split page table lock
In-Reply-To: <20130906104803.0F39CE0090@blue.fi.intel.com>
References: <1378416466-30913-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1378416466-30913-3-git-send-email-n-horiguchi@ah.jp.nec.com> <20130906104803.0F39CE0090@blue.fi.intel.com>
User-Agent: Notmuch/0.16+32~g01f5508 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Sun, 08 Sep 2013 22:26:29 +0530
Message-ID: <87y577gsle.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090903-3568-0000-0000-000004353423
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> writes:

> Naoya Horiguchi wrote:
>> Thp related code also uses per process mm->page_table_lock now.
>> So making it fine-grained can provide better performance.
>> 
>> This patch makes thp support split page table lock by using page->ptl
>> of the pages storing "pmd_trans_huge" pmds.
>> 
>> Some functions like pmd_trans_huge_lock() and page_check_address_pmd()
>> are expected by their caller to pass back the pointer of ptl, so this
>> patch adds to those functions new arguments for that. Rather than that,
>> this patch gives only straightforward replacement.
>> 
>> ChangeLog v3:
>>  - fixed argument of huge_pmd_lockptr() in copy_huge_pmd()
>>  - added missing declaration of ptl in do_huge_pmd_anonymous_page()
>> 
>> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>
> Generally, looks good. Few notes:
>
> I believe you need to convert __pte_alloc() to new locking. Not sure about
> __pte_alloc_kernel().
> Have you check all rest mm->page_table_lock, that they shouldn't be
> converted to new locking?

May be we can have a CONFIG_DEBUG_VM version of pmd_populate that check 
check with assert_spin_locked ?


-aneesh

