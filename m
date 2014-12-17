Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaLQQgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 11:36:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaLQQgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 11:36:31 -0500
Message-ID: <5491B031.3070107@redhat.com>
Date: Wed, 17 Dec 2014 11:32:49 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <koct9i@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Tim Hartrick <tim@edgecast.com>,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        Michel Lespinasse <walken@google.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v4] mm: prevent endless growth of anon_vma hierarchy
References: <20141217085737.16381.75639.stgit@zurg>
In-Reply-To: <20141217085737.16381.75639.stgit@zurg>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2014 02:57 AM, Konstantin Khlebnikov wrote:

> @@ -236,6 +240,13 @@ static inline void unlock_anon_vma_root(struct anon_vma *root)
>  /*
>   * Attach the anon_vmas from src to dst.
>   * Returns 0 on success, -ENOMEM on failure.
> + *
> + * If dst->anon_vma is NULL this function tries to find and reuse existing
> + * anon_vma which has no vmas and only one child anon_vma. This prevents
> + * degradation of anon_vma hierarchy to endless linear chain in case of
> + * constantly forking task. In other hand anon_vma with more than one child
> + * isn't reused even if was no alive vma, thus rmap walker has a good chance
> + * to avoid scanning whole hieraryhy when it searches where page is mapped.
                              ^^^^^^^^^
                              hierarchy

Other than that:

Reviewed-by: Rik van Riel <riel@redhat.com>


Thanks for fixing this long standing issue, Konstantin.
