Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3CLHHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 03:07:23 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:43544 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3CLHHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 03:07:22 -0400
Date: Tue, 12 Mar 2013 08:07:15 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Stelian Nirlu <steliannirlu@gmail.com>
Cc: schwidefsky@de.ibm.com, linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, penberg@kernel.org
Subject: Re: [PATCH v2] s390: use kcalloc instead of kmalloc and memset
Message-ID: <20130312070715.GB4148@osiris>
References: <1363018931-9628-1-git-send-email-steliannirlu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363018931-9628-1-git-send-email-steliannirlu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031207-0342-0000-0000-0000046E56D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 06:22:10PM +0200, Stelian Nirlu wrote:
> Signed-off-by: Stelian Nirlu <steliannirlu@gmail.com>
> ---
>  arch/s390/net/bpf_jit_comp.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
> index 0972e91..82f165f 100644
> --- a/arch/s390/net/bpf_jit_comp.c
> +++ b/arch/s390/net/bpf_jit_comp.c
> @@ -747,10 +747,9 @@ void bpf_jit_compile(struct sk_filter *fp)
> 
>  	if (!bpf_jit_enable)
>  		return;
> -	addrs = kmalloc(fp->len * sizeof(*addrs), GFP_KERNEL);
> +	addrs = kcalloc(fp->len, sizeof(*addrs), GFP_KERNEL);
>  	if (addrs == NULL)
>  		return;
> -	memset(addrs, 0, fp->len * sizeof(*addrs));

Applied, thanks!

