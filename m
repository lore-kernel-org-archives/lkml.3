Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab3G2O7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:59:10 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:34914 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab3G2O7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:59:07 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>
Cc: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] mm: Save soft-dirty bits on file pages
In-Reply-To: <20130729141417.GM2524@moon>
References: <20130726201807.GJ8661@moon> <51F67777.6060609@parallels.com> <20130729141417.GM2524@moon>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 29 Jul 2013 20:28:54 +0530
Message-ID: <878v0ps98x.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072914-1618-0000-0000-0000045CC2CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> writes:

> On Mon, Jul 29, 2013 at 06:08:55PM +0400, Pavel Emelyanov wrote:
>> >  
>> > -	if (!pte_none(*pte))
>> > +	ptfile = pgoff_to_pte(pgoff);
>> > +
>> > +	if (!pte_none(*pte)) {
>> > +#ifdef CONFIG_MEM_SOFT_DIRTY
>> > +		if (pte_present(*pte) &&
>> > +		    pte_soft_dirty(*pte))
>> 
>> I think there's no need in wrapping every such if () inside #ifdef CONFIG_...,
>> since the pte_soft_dirty() routine itself would be 0 for non-soft-dirty case
>> and compiler would optimize this code out.
>
> If only I'm not missing something obvious, this code compiles not only on x86,
> CONFIG_MEM_SOFT_DIRTY depends on x86 (otherwise I'll have to implement
> pte_soft_dirty for all archs).

why not

#ifndef pte_soft_dirty 
#define pte_soft_dirty(pte) 0 
#endif

and on x86 
#define pte_soft_dirty pte_soft_dirty

-aneesh

