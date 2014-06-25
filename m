Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbaFYU2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:28:15 -0400
Received: from fujitsu24.fnanic.fujitsu.com ([192.240.6.14]:39842 "EHLO
	fujitsu24.fnanic.fujitsu.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752833AbaFYU2N convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:28:13 -0400
From: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
To: Rafael Aquini <aquini@redhat.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Motohiro Kosaki JP <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 Jun 2014 13:27:53 -0700
Subject: RE: [PATCH] mm: export NR_SHMEM via sysinfo(2) / si_meminfo()
 interfaces
Thread-Topic: [PATCH] mm: export NR_SHMEM via sysinfo(2) / si_meminfo()
 interfaces
Thread-Index: Ac+Qslt2FjsSyZmwTK6j9fyeq2v8wQAAUA5A
Message-ID: <6B2BA408B38BA1478B473C31C3D2074E341D585503@SV-EXCHANGE1.Corp.FC.LOCAL>
References: <4b46c5b21263c446923caf3da3f0dca6febc7b55.1403709665.git.aquini@redhat.com>
 <6B2BA408B38BA1478B473C31C3D2074E341D585464@SV-EXCHANGE1.Corp.FC.LOCAL>
 <20140625201603.GA1534@t510.redhat.com>
In-Reply-To: <20140625201603.GA1534@t510.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-25_06:2014-06-25,2014-06-25,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Rafael Aquini [mailto:aquini@redhat.com]
> Sent: Wednesday, June 25, 2014 4:16 PM
> To: Motohiro Kosaki
> Cc: linux-mm@kvack.org; Andrew Morton; Rik van Riel; Mel Gorman; Johannes Weiner; Motohiro Kosaki JP; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] mm: export NR_SHMEM via sysinfo(2) / si_meminfo() interfaces
> 
> On Wed, Jun 25, 2014 at 12:41:17PM -0700, Motohiro Kosaki wrote:
> >
> >
> > > -----Original Message-----
> > > From: Rafael Aquini [mailto:aquini@redhat.com]
> > > Sent: Wednesday, June 25, 2014 2:40 PM
> > > To: linux-mm@kvack.org
> > > Cc: Andrew Morton; Rik van Riel; Mel Gorman; Johannes Weiner;
> > > Motohiro Kosaki JP; linux-kernel@vger.kernel.org
> > > Subject: [PATCH] mm: export NR_SHMEM via sysinfo(2) / si_meminfo()
> > > interfaces
> > >
> > > This patch leverages the addition of explicit accounting for pages
> > > used by shmem/tmpfs -- "4b02108 mm: oom analysis: add shmem vmstat"
> > > -- in order to make the users of sysinfo(2) and si_meminfo*() friends aware of that vmstat entry consistently across the interfaces.
> >
> > Why?
> 
> Because we do not report consistently across the interfaces we declare exporting that data. Check sysinfo(2) manpage, for instance:
> [...]
>            struct sysinfo {
>                long uptime;             /* Seconds since boot */
>                unsigned long loads[3];  /* 1, 5, and 15 minute load averages */
>                unsigned long totalram;  /* Total usable main memory size */
>                unsigned long freeram;   /* Available memory size */
>                unsigned long sharedram; /* Amount of shared memory */ <<<<< [...]
> 
> userspace tools resorting to sysinfo() syscall will get a hardcoded 0 for shared memory which is reported differently from
> /proc/meminfo.
> 
> Also, si_meminfo() & si_meminfo_node() are utilized within the kernel to gather statistics for /proc/meminfo & friends, and so we
> can leverage collecting sharedmem from those calls as well, just as we do for totalram, freeram & bufferram.

But "Amount of shared memory"  didn't mean amout of shmem. It actually meant amout of page of page-count>=2.
Again, there is a possibility to change the semantics. But I don't have enough userland knowledge to do. Please investigate
and explain why your change don't break any userland. 






