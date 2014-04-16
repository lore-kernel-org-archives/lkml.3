Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbaDPUun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:50:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbaDPUuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:50:39 -0400
Date: Wed, 16 Apr 2014 13:50:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yogesh Gaur <yogeshgaur.83@gmail.com>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Dead code removal in madvise_willneed
Message-Id: <20140416135037.c7e458897286271aa133555f@linux-foundation.org>
In-Reply-To: <CAG6enPx4WLM+q_bNupPewAd3-QoxOPEDNRdeeTEhOEWp3a1NzA@mail.gmail.com>
References: <CAG6enPx4WLM+q_bNupPewAd3-QoxOPEDNRdeeTEhOEWp3a1NzA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2014 13:16:18 +0530 Yogesh Gaur <yogeshgaur.83@gmail.com> wrote:

> Dead code removal in func madvise_willneed().
> When file is NULL i.e. !file true
> 	case CONFIG_SWAP returns 0.
> 	else returns -EBADF.
> Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
> ---
>  mm/madvise.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 7055883..be24987 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -231,10 +231,10 @@ static long madvise_willneed(struct vm_area_struct * vma,
>  						file->f_mapping);
>  		return 0;
>  	}
> -#endif
> -
> +#else
>  	if (!file)
>  		return -EBADF;
> +#endif

The compiler should have no trouble making this optimisation for us.  I
don't see that it is necessary to add more ugly-looking ifdefs for
this.

