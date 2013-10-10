Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab3JJRwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:52:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab3JJRwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:52:53 -0400
Message-ID: <5256E931.5010403@redhat.com>
Date: Thu, 10 Oct 2013 13:51:45 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: hugetlb: initialize PG_reserved for tail pages of
 gigantig compound pages
References: <1381421561-10203-1-git-send-email-aarcange@redhat.com> <1381421561-10203-2-git-send-email-aarcange@redhat.com>
In-Reply-To: <1381421561-10203-2-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 12:12 PM, Andrea Arcangeli wrote:
> 11feeb498086a3a5907b8148bdf1786a9b18fc55 introduced a memory leak when
> KVM is run on gigantic compound pages.
>
> 11feeb498086a3a5907b8148bdf1786a9b18fc55 depends on the assumption
> that PG_reserved is identical for all head and tail pages of a
> compound page. So that if get_user_pages returns a tail page, we don't
> need to check the head page in order to know if we deal with a
> reserved page that requires different refcounting.
>
> The assumption that PG_reserved is the same for head and tail pages is
> certainly correct for THP and regular hugepages, but gigantic
> hugepages allocated through bootmem don't clear the PG_reserved on the
> tail pages (the clearing of PG_reserved is done later only if the
> gigantic hugepage is freed).
>
> This patch corrects the gigantic compound page initialization so that
> we can retain the optimization in
> 11feeb498086a3a5907b8148bdf1786a9b18fc55. The cacheline was already
> modified in order to set PG_tail so this won't affect the boot time of
> large memory systems.
>
> Reported-by: andy123 <ajs124.ajs124@gmail.com>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

