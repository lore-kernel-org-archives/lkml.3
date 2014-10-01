Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaJAVju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:39:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22256 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaJAVjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:39:49 -0400
Message-ID: <542C749B.1040103@oracle.com>
Date: Wed, 01 Oct 2014 17:39:39 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        mgorman@suse.de
Subject: Re: [PATCH 0/5] mm: poison critical mm/ structs
References: <1412041639-23617-1-git-send-email-sasha.levin@oracle.com> <20141001140725.fd7f1d0cf933fbc2aa9fc1b1@linux-foundation.org>
In-Reply-To: <20141001140725.fd7f1d0cf933fbc2aa9fc1b1@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 05:07 PM, Andrew Morton wrote:
> On Mon, 29 Sep 2014 21:47:14 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> Currently we're seeing a few issues which are unexplainable by looking at the
>> data we see and are most likely caused by a memory corruption caused
>> elsewhere.
>>
>> This is wasting time for folks who are trying to figure out an issue provided
>> a stack trace that can't really point out the real issue.
>>
>> This patch introduces poisoning on struct page, vm_area_struct, and mm_struct,
>> and places checks in busy paths to catch corruption early.
>>
>> This series was tested, and it detects corruption in vm_area_struct. Right now
>> I'm working on figuring out the source of the corruption, (which is a long
>> standing bug) using KASan, but the current code is useful as it is.
> 
> Is this still useful if/when kasan is in place?

Yes, the corruption we're seeing happens inside the struct rather than around it.
kasan doesn't look there.

When kasan is merged, we could complement this patchset by making kasan trap on
when the poison is getting written, rather than triggering a BUG in some place
else after we saw the corruption.

> It looks fairly cheap - I wonder if it should simply fall under
> CONFIG_DEBUG_VM rather than the new CONFIG_DEBUG_VM_POISON.

Config options are cheap as well :)

I'd rather expand it further and add poison/kasan trapping into other places such
as the vma interval tree rather than having to keep it "cheap".


Thanks,
Sasha
