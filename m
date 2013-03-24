Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab3CXHni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 03:43:38 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49650 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3CXHng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 03:43:36 -0400
Date: Sun, 24 Mar 2013 08:43:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Russ Anderson <rja@sgi.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [patch] mm: speedup in __early_pfn_to_nid
Message-ID: <20130324074331.GA12939@gmail.com>
References: <20130318155619.GA18828@sgi.com>
 <20130321105516.GC18484@gmail.com>
 <alpine.DEB.2.02.1303211139110.3775@chino.kir.corp.google.com>
 <20130322072532.GC10608@gmail.com>
 <20130323152948.GA3036@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130323152948.GA3036@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Russ Anderson <rja@sgi.com> wrote:

> --- linux.orig/mm/page_alloc.c	2013-03-19 16:09:03.736450861 -0500
> +++ linux/mm/page_alloc.c	2013-03-22 17:07:43.895405617 -0500
> @@ -4161,10 +4161,23 @@ int __meminit __early_pfn_to_nid(unsigne
>  {
>  	unsigned long start_pfn, end_pfn;
>  	int i, nid;
> +	/*
> +	   NOTE: The following SMP-unsafe globals are only used early
> +	   in boot when the kernel is running single-threaded.
> +	 */
> +	static unsigned long last_start_pfn, last_end_pfn;
> +	static int last_nid;

I guess I'm the nitpicker of the week:

please use the customary (multi-line) comment style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

Thanks,

        Ingo

