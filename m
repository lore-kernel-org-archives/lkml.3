Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab3EPSmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:42:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab3EPSmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:42:46 -0400
Date: Thu, 16 May 2013 20:38:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Jiri Slaby <jslaby@suse.cz>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/6] coredump: avoid the uninitialized cn->corename if
	core_pattern is empty
Message-ID: <20130516183853.GA29767@redhat.com>
References: <20130515201158.GA14606@redhat.com> <20130516182624.GA29455@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516182624.GA29455@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

off-topic...

Perhaps do_coredump() should warn if filp_open() fails?

And I'd wish I could understand d_unhashed() check...

And why filp_open() uses O_RDWR passed as hardcoded 2.

On 05/16, Oleg Nesterov wrote:
>
> If core_pattern is "" or "|", cn->corename is used uninitialized
> by filp_open() or call_usermodehelper_exec().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  fs/coredump.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 5968064..72f816d 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -165,6 +165,7 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm)
>  	cn->corename = NULL;
>  	if (expand_corename(cn, core_name_size))
>  		return -ENOMEM;
> +	cn->corename[0] = '\0';
>  
>  	if (ispipe)
>  		++pat_ptr;
> -- 
> 1.5.5.1
> 

