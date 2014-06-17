Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbaFQH6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:58:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599AbaFQH6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:58:46 -0400
Date: Tue, 17 Jun 2014 09:58:35 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lczerner@localhost.localdomain
To: Hugh Dickins <hughd@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: ZERO_RANGE and COLLAPSE_RANGE not currently
 supported
In-Reply-To: <alpine.LSU.2.11.1406151816410.31998@eggly.anvils>
Message-ID: <alpine.LFD.2.00.1406170956420.2148@localhost.localdomain>
References: <alpine.LSU.2.11.1406151816410.31998@eggly.anvils>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jun 2014, Hugh Dickins wrote:

> Date: Sun, 15 Jun 2014 18:28:00 -0700 (PDT)
> From: Hugh Dickins <hughd@google.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lukas Czerner <lczerner@redhat.com>,
>     Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org
> Subject: [PATCH] tmpfs: ZERO_RANGE and COLLAPSE_RANGE not currently supported
> 
> I was well aware of FALLOC_FL_ZERO_RANGE and FALLOC_FL_COLLAPSE_RANGE
> support being added to fallocate(); but didn't realize until now that
> I had been too stupid to future-proof shmem_fallocate() against new
> additions.  -EOPNOTSUPP instead of going on to ordinary fallocation.

Looks good.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org # v3.15
> ---
> 
>  mm/shmem.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- v3.15/mm/shmem.c	2014-06-08 11:19:54.000000000 -0700
> +++ linux/mm/shmem.c	2014-06-15 18:01:16.988996166 -0700
> @@ -1728,6 +1728,9 @@ static long shmem_fallocate(struct file
>  	pgoff_t start, index, end;
>  	int error;
>  
> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> +		return -EOPNOTSUPP;
> +
>  	mutex_lock(&inode->i_mutex);
>  
>  	if (mode & FALLOC_FL_PUNCH_HOLE) {
> 
