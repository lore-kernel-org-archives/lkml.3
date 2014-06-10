Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaFJXFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:05:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaFJXFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:05:01 -0400
Date: Tue, 10 Jun 2014 16:04:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 1/1] MM/PAGE_ALLOC add __meminit to
 alloc_pages_exact_nid
Message-Id: <20140610160459.7c76d2ef67c1f3aea5e8431c@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1406101554000.32203@chino.kir.corp.google.com>
References: <1402421774-4044-1-git-send-email-fabf@skynet.be>
	<alpine.DEB.2.02.1406101554000.32203@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014 15:54:41 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> Memcg cannot be compiled as a module, so why are we using EXPORT_SYMBOL()?


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/page_alloc.c: unexport alloc_pages_exact_nid()

It is only called by mm/page_cgroup.c whcih cannot be modular.

Reported-by: David Rientjes <rientjes@google.com>
Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_allocc-unexport-alloc_pages_exact_nid mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-unexport-alloc_pages_exact_nid
+++ a/mm/page_alloc.c
@@ -2957,7 +2957,6 @@ void * __meminit alloc_pages_exact_nid(i
 		return NULL;
 	return make_alloc_exact((unsigned long)page_address(p), order, size);
 }
-EXPORT_SYMBOL(alloc_pages_exact_nid);
 
 /**
  * free_pages_exact - release memory allocated via alloc_pages_exact()
_

