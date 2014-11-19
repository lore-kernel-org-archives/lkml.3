Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbaKSENJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 23:13:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41520 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbaKSENH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 23:13:07 -0500
Message-ID: <546C18C5.5090508@oracle.com>
Date: Tue, 18 Nov 2014 23:12:53 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: mm: shmem: freeing mlocked page
References: <545C4A36.9050702@oracle.com>	<5466142C.60100@oracle.com>	<20141118135843.bd711e95d3977c74cf51d803@linux-foundation.org>	<546C1202.1020502@oracle.com> <20141118195656.f80ff650.akpm@linux-foundation.org>
In-Reply-To: <20141118195656.f80ff650.akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 10:56 PM, Andrew Morton wrote:
>> Trinity can't really log anything because attempts to log syscalls slow everything
>> > down to a crawl to the point nothing reproduces.
> Ah.  I was thinking that it could be worked out by looking at the
> trinity source around where it calls splice().  But I suspect that
> doesn't make sense if trinity just creates a zillion threads each of
> which sprays semi-random syscalls at the kernel(?).

I think Dave would agree here that this is a rather accurate description
of Trinity :)

>> > I've just looked at that trace above, and got a bit more confused. I didn't think
>> > that you can mlock page cache. How would a user do that exactly?
> mmap it then mlock it!  The kernel will fault everything in for you
> then pin it down.

But that's a pipe buffer, I didn't think userspace can mmap pipes? I have
some reading to do.


Thanks,
Sasha
