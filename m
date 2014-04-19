Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaDSQF7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 12:05:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56147 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaDSQFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 12:05:54 -0400
Date: Sat, 19 Apr 2014 18:05:53 +0200
From: Pavel Machek <pavel@denx.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH 09/28] nios2: Page table management
Message-ID: <20140419160552.GA19577@amd.pavel.ucw.cz>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
 <1397824031-4892-7-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397824031-4892-7-git-send-email-lftan@altera.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch adds support for page table management.
> 
> Signed-off-by: Ley Foon Tan <lftan@altera.com>

> +/*
> + * Initialize a new pgd / pmd table with invalid pointers.
> + */
> +static void pgd_init(pgd_t *pgd)
> +{
> +	unsigned long *p = (unsigned long *) pgd;
> +	int i;
> +
> +	for (i = 0; i < USER_PTRS_PER_PGD; i += 8) {
> +		p[i + 0] = (unsigned long) invalid_pte_table;
> +		p[i + 1] = (unsigned long) invalid_pte_table;
> +		p[i + 2] = (unsigned long) invalid_pte_table;
> +		p[i + 3] = (unsigned long) invalid_pte_table;
> +		p[i + 4] = (unsigned long) invalid_pte_table;
> +		p[i + 5] = (unsigned long) invalid_pte_table;
> +		p[i + 6] = (unsigned long) invalid_pte_table;
> +		p[i + 7] = (unsigned long) invalid_pte_table;
> +	}

Umm. Manual loop unrolling. Does it really improve performance? Is the
code hot enough to warrant the uglyness?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
