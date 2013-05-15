Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3EOHZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 03:25:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:25966 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab3EOHZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 03:25:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,675,1363158000"; 
   d="scan'208";a="337813187"
Message-ID: <1368602870.13665.7.camel@sauron.fi.intel.com>
Subject: Re: [PATCH V4 1/9] mtd: add more comment for ecc_strength/ecc_size
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 15 May 2013 10:27:50 +0300
In-Reply-To: <1366967337-5534-2-git-send-email-b32955@freescale.com>
References: <1366967337-5534-1-git-send-email-b32955@freescale.com>
	 <1366967337-5534-2-git-send-email-b32955@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 17:08 +0800, Huang Shijie wrote:
> Add more commit for ecc_strength and ecc_size fields.
> We can treat the comment as the initial semantics for the two fields.
> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>

Huang, let me drop the 3 patches I already merged. Please, re-send them
in v5. I think this is better because I see you start applying patches
on top of them, which is a bit confusing.

>   * @cellinfo:		[INTERN] MLC/multichip data from chip ident
>   * @ecc_strength:	[INTERN] ECC correctability from the datasheet.
> + *			The minimum number of bits correctability, if known;
> + *			if unknown, set to 0.

I find this confusing still. How about this comment.

ECC correctability from the datasheet. Minumum amount of bit errors per
@ecc_size guaranteed to be correctable). If unknown, set to zero.


>   * @ecc_size:		[INTERN] ECC size required by the @ecc_strength,
> - *                      also from the datasheet.
> + *                      also from the datasheet. It is the recommended ECC step
> + *			size, if known; if unknown, set to 0.

Silly question, why you call this one "ecc_size", and not "ecc_step"?

-- 
Best Regards,
Artem Bityutskiy

