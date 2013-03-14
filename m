Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab3CNHZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 03:25:11 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:34525 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3CNHZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 03:25:08 -0400
Date: Thu, 14 Mar 2013 08:25:04 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: s390: net: Replaced kmalloc and memset with kzalloc
Message-ID: <20130314072504.GC3480@osiris>
References: <1363201157-17545-1-git-send-email-gheorghiuandru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363201157-17545-1-git-send-email-gheorghiuandru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
x-cbid: 13031407-0542-0000-0000-000004A8E484
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 08:59:17PM +0200, Alexandru Gheorghiu wrote:
> Used kzalloc instead of kmalloc followed by memset with 0.
> Patch found using coccinelle.
> 
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>  arch/s390/net/bpf_jit_comp.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
> index 0972e91..e645528 100644
> --- a/arch/s390/net/bpf_jit_comp.c
> +++ b/arch/s390/net/bpf_jit_comp.c
> @@ -747,10 +747,9 @@ void bpf_jit_compile(struct sk_filter *fp)
> 
>  	if (!bpf_jit_enable)
>  		return;
> -	addrs = kmalloc(fp->len * sizeof(*addrs), GFP_KERNEL);
> +	addrs = kzalloc(fp->len * sizeof(*addrs), GFP_KERNEL);
>  	if (addrs == NULL)
>  		return;
> -	memset(addrs, 0, fp->len * sizeof(*addrs));

We have already a different patch from Stelian Nirlu for the same stuff.

