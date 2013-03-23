Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab3CWWY0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 18:24:26 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:45940 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3CWWYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 18:24:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130323152948.GA3036@sgi.com>
References: <20130318155619.GA18828@sgi.com> <20130321105516.GC18484@gmail.com>
 <alpine.DEB.2.02.1303211139110.3775@chino.kir.corp.google.com>
 <20130322072532.GC10608@gmail.com> <20130323152948.GA3036@sgi.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sat, 23 Mar 2013 18:24:04 -0400
Message-ID: <CAHGf_=qgsga4Juj8uNnfbmOZYtYhcQbqngbFDWg9=B-1nc1HSw@mail.gmail.com>
Subject: Re: [patch] mm: speedup in __early_pfn_to_nid
To: Russ Anderson <rja@sgi.com>
Cc: Ingo Molnar <mingo@kernel.org>, David Rientjes <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- linux.orig/mm/page_alloc.c  2013-03-19 16:09:03.736450861 -0500
> +++ linux/mm/page_alloc.c       2013-03-22 17:07:43.895405617 -0500
> @@ -4161,10 +4161,23 @@ int __meminit __early_pfn_to_nid(unsigne
>  {
>         unsigned long start_pfn, end_pfn;
>         int i, nid;
> +       /*
> +          NOTE: The following SMP-unsafe globals are only used early
> +          in boot when the kernel is running single-threaded.
> +        */
> +       static unsigned long last_start_pfn, last_end_pfn;
> +       static int last_nid;

Why don't you mark them __meminitdata? They seems freeable.
