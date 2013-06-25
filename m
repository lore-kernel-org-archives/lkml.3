Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab3FYGuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 02:50:18 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:42649 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3FYGuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 02:50:15 -0400
Date: Tue, 25 Jun 2013 08:50:06 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        cornelia.huck@de.ibm.com, mtosatti@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [Suggestion] arch: s390: mm: the warnings with allmodconfig and
 "EXTRA_CFLAGS=-W"
Message-ID: <20130625085006.01a7f368@mschwide>
In-Reply-To: <51C8F861.9010101@asianux.com>
References: <51C8F685.6000209@asianux.com>
	<51C8F861.9010101@asianux.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062506-1948-0000-0000-00000581F1BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jun 2013 09:54:41 +0800
Chen Gang <gang.chen@asianux.com> wrote:

> Hello Maintainers:
> 
> When allmodconfig for " IBM zSeries model z800 and z900"
> 
> It will report the related warnings ("EXTRA_CFLAGS=-W"):
>   mm/slub.c:1875:1: warning: ‘deactivate_slab’ uses dynamic stack allocation [enabled by default]
>   mm/slub.c:1941:1: warning: ‘unfreeze_partials.isra.32’ uses dynamic stack allocation [enabled by default]
>   mm/slub.c:2575:1: warning: ‘__slab_free’ uses dynamic stack allocation [enabled by default]
>   mm/slub.c:1582:1: warning: ‘get_partial_node.isra.34’ uses dynamic stack allocation [enabled by default]
>   mm/slub.c:2311:1: warning: ‘__slab_alloc.constprop.42’ uses dynamic stack allocation [enabled by default]
> 
> Is it OK ?

Yes, these warnings should be ok. They are enabled by CONFIG_WARN_DYNAMIC_STACK,
the purpose is to find all functions with dynamic stack allocations. The check
if the allocations are truly ok needs to be done manually as the compiler
can not find out the maximum allocation size automatically.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

