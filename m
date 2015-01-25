Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbbAYOsV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 09:48:21 -0500
Received: from smtpcm9-314.freemail.mail.aliyun.com ([110.75.46.14]:45055 "EHLO
	smtpcm9-314.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752829AbbAYOsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 09:48:18 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Jan 2015 09:48:18 EST
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.5192142|-1;FP=0|0|0|0|0|-1|-1|-1;HT=r75b01018;MF=zhangyanfei.linux@aliyun.com;PH=DS;RN=14;RT=14;SR=0;
Message-ID: <54C500F0.3070903@aliyun.com>
Date: Sun, 25 Jan 2015 22:42:56 +0800
From: Zhang Yanfei <zhangyanfei.linux@aliyun.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>,
        Ebru Akagunduz <ebru.akagunduz@gmail.com>
CC: linux-mm@kvack.org, akpm@linux-foundation.org, kirill@shutemov.name,
        mhocko@suse.cz, mgorman@suse.de, rientjes@google.com,
        sasha.levin@oracle.com, hughd@google.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, riel@redhat.com
Subject: Re: [PATCH] mm: incorporate read-only pages into transparent huge
 pages
References: <1421999256-3881-1-git-send-email-ebru.akagunduz@gmail.com> <20150123191816.GN11755@redhat.com> <54C4B680.3010304@suse.cz>
In-Reply-To: <54C4B680.3010304@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

在 2015/1/25 17:25, Vlastimil Babka 写道:
> On 23.1.2015 20:18, Andrea Arcangeli wrote:
>>> >+        if (!pte_write(pteval)) {
>>> >+            if (++ro > khugepaged_max_ptes_none)
>>> >+                goto out_unmap;
>>> >+        }
>> It's true this is maxed out at 511, so there must be at least one
>> writable and not none pte (as results of the two "ro" and "none"
>> counters checks).
> 
> Hm, but if we consider ro and pte_none separately, both can be lower
> than 512, but the sum of the two can be 512, so we can actually be in
> read-only VMA?

Yes, I also think so.

So is it necessary to add a at-least-one-writable-pte check just like the existing
at-least-one-page-referenced check?

Thanks.
