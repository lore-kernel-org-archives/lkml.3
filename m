Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab3ISKVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:21:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3ISKVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:21:47 -0400
Date: Thu, 19 Sep 2013 12:21:37 +0200
From: Frantisek Hrbata <fhrbata@redhat.com>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, jstancek@redhat.com, keescook@chromium.org,
        peter.oberparleiter@de.ibm.com, rusty@rustcorp.com.au,
        linux-arch@vger.kernel.org, arnd@arndb.de, mgahagan@redhat.com,
        agospoda@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH v2 2/4] gcov: add support for gcc 4.7 gcov format
Message-ID: <20130919102137.GB2313@localhost.localdomain>
Reply-To: Frantisek Hrbata <fhrbata@redhat.com>
References: <1378305776-3644-1-git-send-email-fhrbata@redhat.com>
 <1378305776-3644-3-git-send-email-fhrbata@redhat.com>
 <523ABE10.6060802@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <523ABE10.6060802@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 11:04:16AM +0200, Peter Oberparleiter wrote:
> On 04.09.2013 16:42, Frantisek Hrbata wrote:
> > The gcov in-memory format changed in gcc 4.7. The biggest change, which
> > requires this special implementation, is that gcov_info no longer contains
> > array of counters for each counter type for all functions and gcov_fn_info is
> > not used for mapping of function's counters to these arrays(offset). Now each
> > gcov_fn_info contans it's counters, which makes things a little bit easier.
> > 
> > This is heavily based on the previous gcc_3_4.c implementation and patches
> > provided by Peter Oberparleiter. Specially the buffer gcda implementation for
> > iterator.
> > 
> > v2: - removed const definition for gcov_fn_info in gcov_info
> >     - use vmalloc for counter values in gcov_info_dup
> >     - use iter buffer for gcda
> > 
> > Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
> 
> The patch is missing an include statement:
> 
>   CC      kernel/gcov/gcc_4_7.o
> kernel/gcov/gcc_4_7.c: In function ‘gcov_info_dup’:
> kernel/gcov/gcc_4_7.c:293:4: error: implicit declaration of function ‘vmalloc’ [-Werror=implicit-function-declaration]
> kernel/gcov/gcc_4_7.c:293:20: warning: assignment makes pointer from integer without a cast [enabled by default]
> 
> With that added, it compiles and works with gcc 4.3.4 and 4.7.2 on
> kernel 3.21-rc1 on s390x.
> 
> --- a/kernel/gcov/gcc_4_7.c
> +++ b/kernel/gcov/gcc_4_7.c
> @@ -15,6 +15,7 @@
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/seq_file.h>
> +#include <linux/vmalloc.h>
>  #include "gcov.h"
> 
>  #define GCOV_COUNTERS			8
> 

Hi Peter,

I'm sorry I missed that. Many thanks. In addition, do you have any other
objedtions to the code? Andrew already added the patches to the -mm tree.
Andrew, should I post a follow up patch adding the vmalloc.h include or is it
possible to fix it directly as you did for the previous patches? 
Again I'm sorry for the inconvenience.

Many thanks

-- 
Frantisek Hrbata
