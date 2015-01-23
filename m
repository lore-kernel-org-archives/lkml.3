Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbbAWREd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:04:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39507 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015AbbAWREa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:04:30 -0500
Date: Fri, 23 Jan 2015 18:04:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 1/3] swiotlb: Warn on allocation failure in
 swiotlb_alloc_coherent
Message-ID: <20150123170425.GI22635@pd.tnic>
References: <1420555874-11506-1-git-send-email-joro@8bytes.org>
 <1420555874-11506-2-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420555874-11506-2-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 03:51:12PM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Print a warning when all allocation tries have been failed
> and the function is about to return NULL. This prepares for
> calling the function with __GFP_NOWARN to suppress
> allocation failure warnings before all fall-backs have
> failed.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---

...

> @@ -677,6 +677,13 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  	memset(ret, 0, size);
>  
>  	return ret;
> +
> +err_warn:
> +	pr_warn("swiotlb: coherent allocation failed for device %s size=%zu\n",
> +		dev_name(hwdev), size);
> +	dump_stack();

Are we really sure we want to be that noisy about it? What happens if
that fails, we can't do DMA anymore or should we free some precious DMA
memory, as a compromise?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
