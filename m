Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575AbaKRQ4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:56:52 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:59037 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbaKRQ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:56:51 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>, Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/7] Replace _PAGE_NUMA with PAGE_NONE protections
In-Reply-To: <546B74F5.10004@oracle.com>
References: <1415971986-16143-1-git-send-email-mgorman@suse.de> <5466C8A5.3000402@oracle.com> <20141118154246.GB2725@suse.de> <546B74F5.10004@oracle.com>
User-Agent: Notmuch/0.18.2+162~g34d2c62 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Tue, 18 Nov 2014 22:26:41 +0530
Message-ID: <87tx1w78hi.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111816-0021-0000-0000-00000248C21F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> writes:

> On 11/18/2014 10:42 AM, Mel Gorman wrote:
>> 1. I'm assuming this is a KVM setup but can you confirm?
>
> Yes.
>
>> 2. Are you using numa=fake=N?
>
> Yes. numa=fake=24, which is probably way more nodes on any physical machine
> than the new code was tested on?
>
>> 3. If you are using fake NUMA, what happens if you boot without it as
>>    that should make the patches a no-op?
>
> Nope, still seeing it without fake numa.
>
>> 4. Similarly, does the kernel boot properly without without patches?
>
> Yes, the kernel works fine without the patches both with and without fake
> numa.


Hmm that is interesting. I am not sure how writeback_fid can be
related. We use writeback fid to enable client side caching with 9p
(cache=loose). We use this fid to write back dirty pages later. Can you
share the qemu command line used, 9p mount options and the test details ? 


-aneesh

