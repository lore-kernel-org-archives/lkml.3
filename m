Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142Ab3BHO6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:58:53 -0500
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:50056 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758658Ab3BHO6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:58:51 -0500
Date: Fri, 8 Feb 2013 09:58:42 -0500
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm/iphase: rename fregt_t -> ffreg_t
Message-ID: <20130208095842.7df1a25e@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <20130208101911.GA12195@osiris>
References: <20130208101911.GA12195@osiris>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2013 11:19:11 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> We have conflicting type qualifiers for "freg_t" in s390's ptrace.h and the
> iphase atm device driver, which causes the compile error below.
> Unfortunately the s390 typedef can't be renamed, since it's a user visible api,
> nor can I change the include order in s390 code to avoid the conflict.
> 
> So simply rename the iphase typedef to a new name. Fixes this compile error:
> 
> In file included from drivers/atm/iphase.c:66:0:
> drivers/atm/iphase.h:639:25: error: conflicting type qualifiers for 'freg_t'
> In file included from next/arch/s390/include/asm/ptrace.h:9:0,
>                  from next/arch/s390/include/asm/lowcore.h:12,
>                  from next/arch/s390/include/asm/thread_info.h:30,
>                  from include/linux/thread_info.h:54,
>                  from include/linux/preempt.h:9,
>                  from include/linux/spinlock.h:50,
>                  from include/linux/seqlock.h:29,
>                  from include/linux/time.h:5,
>                  from include/linux/stat.h:18,
>                  from include/linux/module.h:10,
>                  from drivers/atm/iphase.c:43:
> next/arch/s390/include/uapi/asm/ptrace.h:197:3: note: previous declaration of 'freg_t' was here
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

seems like a fine idea.

Acked-by: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
