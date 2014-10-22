Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbaJVUAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:00:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242AbaJVUAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:00:47 -0400
Date: Wed, 22 Oct 2014 13:00:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pintu Kumar <pintu.k@samsung.com>
Cc: riel@redhat.com, aquini@redhat.com, paul.gortmaker@windriver.com,
        jmarchan@redhat.com, lcapitulino@redhat.com,
        kirill.shutemov@linux.intel.com, m.szyprowski@samsung.com,
        aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com,
        mina86@mina86.com, lauraa@codeaurora.org, gioh.kim@lge.com,
        mgorman@suse.de, rientjes@google.com, hannes@cmpxchg.org,
        vbabka@suse.cz, sasha.levin@oracle.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, pintu_agarwal@yahoo.com, cpgs@samsung.com,
        vishnu.ps@samsung.com, rohit.kr@samsung.com, ed.savinay@samsung.com
Subject: Re: [PATCH v2 2/2] fs: proc: Include cma info in proc/meminfo
Message-Id: <20141022130046.f4c7bb9cfc5805d2bef188a4@linux-foundation.org>
In-Reply-To: <1413986796-19732-2-git-send-email-pintu.k@samsung.com>
References: <1413790391-31686-1-git-send-email-pintu.k@samsung.com>
	<1413986796-19732-1-git-send-email-pintu.k@samsung.com>
	<1413986796-19732-2-git-send-email-pintu.k@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014 19:36:35 +0530 Pintu Kumar <pintu.k@samsung.com> wrote:

> This patch include CMA info (CMATotal, CMAFree) in /proc/meminfo.
> Currently, in a CMA enabled system, if somebody wants to know the
> total CMA size declared, there is no way to tell, other than the dmesg
> or /var/log/messages logs.
> With this patch we are showing the CMA info as part of meminfo, so that
> it can be determined at any point of time.
> This will be populated only when CMA is enabled.

Fair enough.

We should be pretty careful about what we put in meminfo - it's the
top-level, most-important procfs file and I expect that quite a lot of
userspace reads it with some frequency.  We don't want to clutter it
up.  /proc/vmstat is a suitable place for the less important info which
is more kernel developer oriented.

But CMATotal and CMAFree do pass the "should be in meminfo" test, IMO.
