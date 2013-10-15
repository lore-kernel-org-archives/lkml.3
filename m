Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814Ab3JOUoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:44:08 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:36344 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab3JOUoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:44:05 -0400
MIME-Version: 1.0
In-Reply-To: <20131014154403.562B2E0090@blue.fi.intel.com>
References: <1381761155-19166-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1381761155-19166-2-git-send-email-kirill.shutemov@linux.intel.com>
	<CAMo8Bf+oo4WCE366+bPoD5Y=Q3pCF0NVnfjXVqz8=nZ45_XY7Q@mail.gmail.com>
	<20131014154403.562B2E0090@blue.fi.intel.com>
Date: Wed, 16 Oct 2013 00:44:03 +0400
Message-ID: <CAMo8Bf+vAe3q+jJ6qv_ZqGZO=-3h40AHhZ==AbKfYV76wbn79Q@mail.gmail.com>
Subject: Re: [PATCHv2 2/2] xtensa: use buddy allocator for PTE table
From: Max Filippov <jcmvbkbc@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Chris Zankel <chris@zankel.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 7:44 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Corrected patch below.
>
> From 0ba2ac687321f5ad7bac5f5c141da5b65b957fdc Mon Sep 17 00:00:00 2001
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Date: Mon, 14 Oct 2013 13:38:21 +0300
> Subject: [PATCHv3] xtensa: use buddy allocator for PTE table
>
> At the moment xtensa uses slab allocator for PTE table. It doesn't work
> with enabled split page table lock: slab uses page->slab_cache and
> page->first_page for its pages. These fields share stroage with
> page->ptl.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Chris Zankel <chris@zankel.net>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> ---
> v3:
>  - return correct value from pte_alloc_one_kernel();
> v2:
>  - add missed return in pte_alloc_one_kernel();

Acked-by: Max Filippov <jcmvbkbc@gmail.com>

-- 
Thanks.
-- Max
