Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3HKQ4c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:56:32 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56149 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab3HKQ4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:56:30 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] Add per-process flag to control thp
In-Reply-To: <20130802205735.GS26476@sgi.com>
References: <20130802205735.GS26476@sgi.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Sun, 11 Aug 2013 22:26:21 +0530
Message-ID: <874nawrwsq.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081116-3864-0000-0000-0000098959B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Thorlton <athorlton@sgi.com> writes:

> This patch implements functionality to allow processes to disable the use of
> transparent hugepages through the prctl syscall.
>
> We've determined that some jobs perform significantly better with thp disabled,
> and we needed a way to control thp on a per-process basis, without relying on
> madvise.
>

Is that because of hugepage alloc on fault ? I understand, that could be
a real issue when applications touch one byte per hugepage. In that case
we would endup allocating more memory than the application footprint. I have
observed that system almost hang and start hitting OOM when run with THP
enabled. Now we could possibly handle that by not allowing alloc on fault and
always depend on coallpse hugepage to instantiate a hugepage ? 

-aneesh

