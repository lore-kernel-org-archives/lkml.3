Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab3G2PCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:02:17 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:35750 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab3G2PCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:02:14 -0400
Date: Mon, 29 Jul 2013 19:02:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] mm: Save soft-dirty bits on file pages
Message-ID: <20130729150209.GO2524@moon>
References: <20130726201807.GJ8661@moon>
 <51F67777.6060609@parallels.com>
 <20130729141417.GM2524@moon>
 <878v0ps98x.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v0ps98x.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 08:28:54PM +0530, Aneesh Kumar K.V wrote:
> >
> > If only I'm not missing something obvious, this code compiles not only on x86,
> > CONFIG_MEM_SOFT_DIRTY depends on x86 (otherwise I'll have to implement
> > pte_soft_dirty for all archs).
> 
> why not
> 
> #ifndef pte_soft_dirty 
> #define pte_soft_dirty(pte) 0 
> #endif
> 
> and on x86 
> #define pte_soft_dirty pte_soft_dirty

Yeah, either this way, either to use asm-generic (later I think
more preferred), thanks!
