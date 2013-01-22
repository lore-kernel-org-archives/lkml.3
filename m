Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3AVDZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:25:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:18935 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab3AVDZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:25:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,511,1355126400"; 
   d="scan'208";a="250508270"
Date: Tue, 22 Jan 2013 04:25:13 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Anmar Oueja <anmar.oueja@linaro.org>,
        stable@kernel.org
Subject: Re: [PATCH v2] mfd: tc3589x: use simple irqdomain
Message-ID: <20130122032513.GG7409@sortiz-mobl>
References: <1357134014-31203-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357134014-31203-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Jan 02, 2013 at 02:40:14PM +0100, Linus Walleij wrote:
> This fixes a regression in the TC3589x driver introduced in
> commit 15e27b1088245a2de3b7d09d39cd209212eb16af
> "mfd: Provide the tc3589x with its own IRQ domain"
> 
> If a system with a TC3589x expander is booted and a base
> IRQ is passed from platform data, a legacy domain will
> be used. However, since the Ux500 is now switched to use
> SPARSE_IRQ, no descriptors get allocated on-the-fly,
> and we get a crash.
> 
> Fix this by switching to using the simple irqdomain that
> will handle this uniformly and also allocates descriptors
> explicitly.
> 
> Also fix two small whitespace errors in the vicinity while
> we're at it.
> 
> Cc: stable@kernel.org
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> ChangeLog v1->v2:
> - Update commit message after comments from Lee, add ACK, no
>   changes to the patche per se.
> 
> Hi Sam, this should go into the fixes for stable unless issues
> are found, it fixes a regression for us.
Applied to my for-linus branch. On its way to 3.8.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
