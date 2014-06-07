Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaFGVue (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 17:50:34 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:46221 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaFGVud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 17:50:33 -0400
Date: Sat, 7 Jun 2014 14:50:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, koct9i@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: rmap: fix use-after-free in __put_anon_vma
In-Reply-To: <1402067370-5773-1-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.DEB.2.02.1406071450190.24927@chino.kir.corp.google.com>
References: <20140606115620.GS3213@twins.programming.kicks-ass.net> <1402067370-5773-1-git-send-email-a.ryabinin@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014, Andrey Ryabinin wrote:

> While working address sanitizer for kernel I've discovered use-after-free
> bug in __put_anon_vma.
> For the last anon_vma, anon_vma->root freed before child anon_vma.
> Later in anon_vma_free(anon_vma) we are referencing to already freed anon_vma->root
> to check rwsem.
> This patch puts freeing of child anon_vma before freeing of anon_vma->root.
> 
> Cc: <stable@vger.kernel.org> # v3.0+
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>

Acked-by: David Rientjes <rientjes@google.com>
