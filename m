Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644Ab3CYWg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 18:36:58 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:51584 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933435Ab3CYWg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 18:36:56 -0400
Date: Mon, 25 Mar 2013 15:36:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Russ Anderson <rja@sgi.com>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] mm: speedup in __early_pfn_to_nid
In-Reply-To: <20130325143400.d226b1f7b64a209b86dd4151@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1303251533530.13531@chino.kir.corp.google.com>
References: <20130318155619.GA18828@sgi.com> <20130321105516.GC18484@gmail.com> <alpine.DEB.2.02.1303211139110.3775@chino.kir.corp.google.com> <20130322072532.GC10608@gmail.com> <20130323152948.GA3036@sgi.com> <CAHGf_=qgsga4Juj8uNnfbmOZYtYhcQbqngbFDWg9=B-1nc1HSw@mail.gmail.com>
 <alpine.DEB.2.02.1303241727420.23613@chino.kir.corp.google.com> <20130325143400.d226b1f7b64a209b86dd4151@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Mar 2013, Andrew Morton wrote:

> > Um, defining them in a __meminit function places them in .meminit.data 
> > already.
> 
> I wish it did, but it doesn't.
> 

$ objdump -t mm/page_alloc.o | grep last_start_pfn
0000000000000240 l     O .meminit.data	0000000000000008 last_start_pfn.34345

What version of gcc are you using?
