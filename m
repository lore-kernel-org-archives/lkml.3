Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaG1XCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 19:02:35 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34085 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaG1XCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 19:02:34 -0400
Date: Mon, 28 Jul 2014 16:02:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH 2/3] mm/hugetlb: take refcount under page table lock in
 follow_huge_pmd()
In-Reply-To: <1406570911-28133-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.DEB.2.02.1407281602050.8998@chino.kir.corp.google.com>
References: <1406570911-28133-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1406570911-28133-2-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Naoya Horiguchi wrote:

> We have a race condition between move_pages() and freeing hugepages,
> where move_pages() calls follow_page(FOLL_GET) for hugepages internally
> and tries to get its refcount without preventing concurrent freeing.
> This race crashes the kernel, so this patch fixes it by moving FOLL_GET
> code for hugepages into follow_huge_pmd() with taking the page table lock.
> 

What about CONFIG_ARCH_WANT_GENERAL_HUGETLB=n configs?
