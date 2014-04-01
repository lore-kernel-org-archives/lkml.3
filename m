Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbaDAKeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:34:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbaDAKeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:34:07 -0400
Date: Tue, 1 Apr 2014 12:34:01 +0200
From: Robin Hack <rhack@redhat.com>
To: ak@linux.intel.com, sasha.levin@oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: tools/liblockdep: Build failure
Message-ID: <20140401103401.GE10429@bigoook.brq.redhat.com>
References: <22212997.138341396332274687.JavaMail.weblogic@epml01>
 <20140401080258.GA10429@bigoook.brq.redhat.com>
 <20140401081144.GB10429@bigoook.brq.redhat.com>
 <20140401102159.GC10429@bigoook.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401102159.GC10429@bigoook.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch is wrong.
On Tue, Apr 01, 2014 at 12:21:59PM +0200, Robin Hack wrote:
> From: Robin Hack <rhack@redhat.com>
> Copy asmlinkage macro to lockdep/uinclude/linux/linkage.h.
> 
> diff --git a/tools/lib/lockdep/uinclude/linux/linkage.h b/tools/lib/lockdep/uinclude/linux/linkage.h
> index fab00ff..6799a5b 100644
> --- a/tools/lib/lockdep/uinclude/linux/linkage.h
> +++ b/tools/lib/lockdep/uinclude/linux/linkage.h
> @@ -1,3 +1,19 @@
> +#ifndef _LOCKDEP_ULINKAGE_H
> +#define _LOCKDEP_ULINKAGE_H
>  
> -/* empty file */
> +#if GCC_VERSION >= 40600
> +/*
> + * Tell the optimizer that something else uses this function or variable.
> + */
> +#define __visible __attribute__((externally_visible))
> +#else
> +#define __visible
> +#endif
>  
> +#define CPP_ASMLINKAGE __visible
> +
> +#ifndef asmlinkage
> +#define asmlinkage CPP_ASMLINKAGE
> +#endif
> +
> +#endif
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
