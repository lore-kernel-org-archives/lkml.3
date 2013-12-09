Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321Ab3LIRMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:12:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab3LIRMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:12:18 -0500
Message-ID: <52A5F9EE.4010605@suse.cz>
Date: Mon, 09 Dec 2013 18:12:14 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: joern@logfs.org, mgorman@suse.de, Michel Lespinasse <walken@google.com>,
        riel@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: kernel BUG in munlock_vma_pages_range
References: <52A3D0C3.1080504@oracle.com> <52A58E8A.3050401@suse.cz> <52A5F83F.4000207@oracle.com>
In-Reply-To: <52A5F83F.4000207@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 06:05 PM, Sasha Levin wrote:
> On 12/09/2013 04:34 AM, Vlastimil Babka wrote:
>> Hello, I will look at it, thanks.
>> Do you have specific reproduction instructions?
>
> Not really, the fuzzer hit it once and I've been unable to trigger it again. Looking at
> the piece of code involved it might have had something to do with hugetlbfs, so I'll crank
> up testing on that part.

Thanks. Do you have trinity log and the .config file? I'm currently 
unable to even boot linux-next with my config/setup due to a GPF.
Looking at code I wouldn't expect that it could encounter a tail page, 
without first encountering a head page and skipping the whole huge page. 
At least in THP case, as TLB pages should be split when a vma is split. 
As for hugetlbfs, it should be skipped for mlock/munlock operations 
completely. One of these assumptions is probably failing here...

Vlastimil

>
> Thanks,
> Sasha
>

