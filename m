Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbaDQA2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 20:28:22 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:54506 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaDQA2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 20:28:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140416084236.GA23247@node.dhcp.inet.fi>
References: <1397598536-25074-1-git-send-email-kirill.shutemov@linux.intel.com>
	<CAA_GA1ecVD2GuxvPqBhGKdUfMeBJU+m-i5XeSzMmDXy=QncLqA@mail.gmail.com>
	<20140416084236.GA23247@node.dhcp.inet.fi>
Date: Thu, 17 Apr 2014 08:28:20 +0800
Message-ID: <CAA_GA1d1uKtqAxhgzx-pwkymvndmJb4PpMLQZHcetvgf16vBeg@mail.gmail.com>
Subject: Re: [PATCH] thp: close race between split and zap huge pages
From: Bob Liu <lliubbo@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michel Lespinasse <walken@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Linux-MM <linux-mm@kvack.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 4:42 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> On Wed, Apr 16, 2014 at 07:52:29AM +0800, Bob Liu wrote:
>> >         *ptl = pmd_lock(mm, pmd);
>> > -       if (pmd_none(*pmd))
>> > +       if (!pmd_present(*pmd))
>> >                 goto unlock;
>>
>> But I didn't get the idea why pmd_none() was removed?
>
> !pmd_present(*pmd) is weaker check then pmd_none(*pmd). I mean if
> pmd_none(*pmd) is true then pmd_present(*pmd) is always false.

Oh, yes. That's right.

BTW, it looks like this bug was introduced by the same reason.
https://lkml.org/lkml/2014/4/16/403

-- 
Regards,
--Bob
