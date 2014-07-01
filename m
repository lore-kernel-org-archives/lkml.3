Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965102AbaGAWNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:13:53 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:57688 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaGAWNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:13:52 -0400
Date: Tue, 1 Jul 2014 15:13:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Davidlohr Bueso <davidlohr@hp.com>
cc: akpm@linux-foundation.org, aswin@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm,hugetlb: simplify error handling in
 hugetlb_cow()
In-Reply-To: <1404246097-18810-2-git-send-email-davidlohr@hp.com>
Message-ID: <alpine.DEB.2.02.1407011513180.4004@chino.kir.corp.google.com>
References: <1404246097-18810-1-git-send-email-davidlohr@hp.com> <1404246097-18810-2-git-send-email-davidlohr@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014, Davidlohr Bueso wrote:

> When returning from hugetlb_cow(), we always (1) put back the refcount
> for each referenced page -- always 'old', and 'new' if allocation was
> successful. And (2) retake the page table lock right before returning,
> as the callers expects. This logic can be simplified and encapsulated,
> as proposed in this patch. In addition to cleaner code, we also shave
> a few bytes off in instruction text:
> 
>    text    data     bss     dec     hex filename
>   28399     462   41328   70189   1122d mm/hugetlb.o-baseline
>   28367     462   41328   70157   1120d mm/hugetlb.o-patched
> 
> Passes libhugetlbfs testcases.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>

Acked-by: David Rientjes <rientjes@google.com>

Not sure the extra indirection is clearer code, but I can't argue with the 
difference in object size.
