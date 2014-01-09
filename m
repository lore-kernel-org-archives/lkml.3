Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaAIKif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:38:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbaAIKi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:38:28 -0500
Message-ID: <52CE7C21.4060300@suse.cz>
Date: Thu, 09 Jan 2014 11:38:25 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: kernel BUG at mm/huge_memory.c:1440!
References: <52B88F6E.8070909@oracle.com> <20131223200255.GA18521@node.dhcp.inet.fi> <52B8AAFD.5090401@oracle.com> <52C819E2.8090509@oracle.com>
In-Reply-To: <52C819E2.8090509@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2014 03:25 PM, Sasha Levin wrote:
> On 12/23/2013 04:28 PM, Sasha Levin wrote:
>> On 12/23/2013 03:02 PM, Kirill A. Shutemov wrote:
>>>> [  265.474585] kernel BUG at mm/huge_memory.c:1440!
>>> Could you dump_page() on the bug?
>>
>> [  469.007946] page:ffffea0005bd8000 count:3 mapcount:0 mapping:ffff8800bcd3d171 index: 0x7fca81000
>> [  469.009362] page flags: 0x2afffff80090018(uptodate|dirty|swapcache|swapbacked)
>
> Ping? It still shows up in 3.13-rc6.

Could you verify if a version before split PMD locks is affected or not? 
I.e. 3.12 (IIRC)? I've checked if there can be race with THP splitting 
and it seems there shouldn't be thanks to pmd_lock() protection. So that 
could be a candidate. Given the recent trinity improvements it would be 
good to determine if it's a new bug or another years old one...

Thanks,
Vlastimil

> Thanks,
> Sasha
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>

