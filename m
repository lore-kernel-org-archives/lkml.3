Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaJ0XPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:15:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaJ0XPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:15:44 -0400
Date: Mon, 27 Oct 2014 16:15:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Pintu Kumar <pintu.k@samsung.com>, riel@redhat.com, aquini@redhat.com,
        paul.gortmaker@windriver.com, jmarchan@redhat.com,
        lcapitulino@redhat.com, kirill.shutemov@linux.intel.com,
        m.szyprowski@samsung.com, aneesh.kumar@linux.vnet.ibm.com,
        iamjoonsoo.kim@lge.com, lauraa@codeaurora.org, gioh.kim@lge.com,
        mgorman@suse.de, rientjes@google.com, hannes@cmpxchg.org,
        vbabka@suse.cz, sasha.levin@oracle.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, pintu_agarwal@yahoo.com, cpgs@samsung.com,
        vishnu.ps@samsung.com, rohit.kr@samsung.com, ed.savinay@samsung.com
Subject: Re: [PATCH v2 2/2] fs: proc: Include cma info in proc/meminfo
Message-Id: <20141027161544.8955c1df4c01c48e22283692@linux-foundation.org>
In-Reply-To: <xa1tk33p2zvq.fsf@mina86.com>
References: <1413790391-31686-1-git-send-email-pintu.k@samsung.com>
	<1413986796-19732-1-git-send-email-pintu.k@samsung.com>
	<1413986796-19732-2-git-send-email-pintu.k@samsung.com>
	<xa1tk33p2zvq.fsf@mina86.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014 18:31:21 +0200 Michal Nazarewicz <mina86@mina86.com> wrote:

> On Wed, Oct 22 2014, Pintu Kumar <pintu.k@samsung.com> wrote:
> > This patch include CMA info (CMATotal, CMAFree) in /proc/meminfo.
> > Currently, in a CMA enabled system, if somebody wants to know the
> > total CMA size declared, there is no way to tell, other than the dmesg
> > or /var/log/messages logs.
> > With this patch we are showing the CMA info as part of meminfo, so that
> > it can be determined at any point of time.
> > This will be populated only when CMA is enabled.
> >
> > Below is the sample output from a ARM based device with RAM:512MB and CMA:16MB.
> >
> > MemTotal:         471172 kB
> > MemFree:          111712 kB
> > MemAvailable:     271172 kB
> > .
> > .
> > .
> > CmaTotal:          16384 kB
> > CmaFree:            6144 kB
> >
> > This patch also fix below checkpatch errors that were found during these changes.
> 
> As already mentioned, this should be in separate patch.

Yes, in theory.  But a couple of little whitespace fixes aren't really
worth a resend.  As long as they don't make the patch harder to read
and to backport I usually just let them through.
