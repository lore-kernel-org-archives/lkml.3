Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab3EJTdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 15:33:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34266 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380Ab3EJTdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 15:33:05 -0400
Date: Fri, 10 May 2013 21:40:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SyS symbol munging.
Message-ID: <20130510194044.GC23014@pd.tnic>
References: <20130510192417.GA4915@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130510192417.GA4915@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 03:24:17PM -0400, Dave Jones wrote:
> On Fri, May 10, 2013 at 12:14:54PM -0700, Andrew Morton wrote:
> 
>  > [  163.953629] Call Trace:
>  > [  163.957706]  [<ffffffff812be322>] ipcget+0x182/0x380
>  > [  163.962123]  [<ffffffff810b99a5>] ?trace_hardirqs_on_caller+0x115/0x1e0
>  > [  163.966752]  [<ffffffff812c559a>] SyS_shmget+0x5a/0x60
>  > [  163.971163]  [<ffffffff812c47e0>] ? shm_close+0x140/0x140
>  > [  163.975590]  [<ffffffff812c3e60>] ? shm_release+0x50/0x50
>  > [  163.979991]  [<ffffffff812c3df0>] ? shm_get_unmapped_area+0x20/0x20
>  > [  163.984499]  [<ffffffff816caa14>] tracesys+0xdd/0xe2
>  
> This has been bugging me for a while.
> What's changing sys_shmget to SyS_shmget in that trace ? And why ?

+1.

And not only sys_shmget:

SyS_access
SyS_chdir
SyS_chown
SyS_fchownat
SyS_flock
SyS_mkdir
SyS_mkdirat
SyS_mknod
SyS_mknodat
SyS_mount

I have those in backtraces from my boot logs of randconfig kernels in
the last couple of days.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
