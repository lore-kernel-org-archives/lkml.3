Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbbAENVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:21:41 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:58100 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbbAENVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:21:40 -0500
Date: Mon, 5 Jan 2015 14:21:33 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] s390: Remove unnecessary KERN_CONT
Message-ID: <20150105132133.GB4281@osiris>
References: <1420460958.2652.4.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420460958.2652.4.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010513-0029-0000-0000-0000028A06F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 04:29:18AM -0800, Joe Perches wrote:
> This has no effect as KERN_CONT is an empty string,
> 
> It's probably just a missing conversion artifact as the
> other pr_cont uses in the same file don't have this prefix.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/s390/mm/fault.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index 811937b..232c14e 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -171,7 +171,7 @@ static void dump_pagetable(unsigned long asce, unsigned long address)
>  		table = table + ((address >> 20) & 0x7ff);
>  		if (bad_address(table))
>  			goto bad;
> -		pr_cont(KERN_CONT "S:%016lx ", *table);
> +		pr_cont("S:%016lx ", *table);

Applied, thanks.

