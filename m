Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaLGU54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:57:56 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:51497 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbaLGU5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:57:53 -0500
Message-ID: <5484BF4D.1020809@de.ibm.com>
Date: Sun, 07 Dec 2014 21:57:49 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the access_once tree
References: <20141205213224.2dcc20e9@canb.auug.org.au>
In-Reply-To: <20141205213224.2dcc20e9@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120720-0029-0000-0000-0000020F1D9E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.12.2014 um 11:32 schrieb Stephen Rothwell:
> Hi Christian,
> 
> After merging the access_once tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> In file included from include/linux/compiler.h:189:0,
>                  from include/uapi/linux/stddef.h:1,
>                  from include/linux/stddef.h:4,
>                  from include/uapi/linux/posix_types.h:4,
>                  from include/linux/fdtable.h:8,
>                  from security/apparmor/domain.c:16:
> include/linux/types.h:14:9: error: unknown type name '__kernel_fd_set'
>  typedef __kernel_fd_set  fd_set;
>          ^
> 
> And many more :-(
> 
> Presumably caused by commit b06f66134856 ("kernel: Provide READ_ONCE
> and ASSIGN_ONCE") which added types.h into compiler.h, but I am not
> sure.  It could be an interaction with something else in linux-next, of
> course.
> 
> I have dropped the access_once tree for today, sorry.
> 

Interesting, I double checked with defconfig and cross compilation. But yes, using allmodconfig fails.
I have changed that to uapi/linux/types.h and __u<xx>. This seems to fix it as it only adds a small set of types.

Can you re-add?

Christian

