Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab3EGHy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:54:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:59227 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027Ab3EGHyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:54:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,627,1363158000"; 
   d="scan'208";a="333026814"
Date: Tue, 7 May 2013 10:59:04 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: David Cohen <david.a.cohen@intel.com>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio-langwell: fix irq conflicts when DT is not used
Message-ID: <20130507075904.GE20562@intel.com>
References: <1367881863-6025-1-git-send-email-david.a.cohen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367881863-6025-1-git-send-email-david.a.cohen@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 04:11:03PM -0700, David Cohen wrote:
> When DT is not used IOAPIC does not register irq domain. As result
> IOAPIC won't care about gpio-langwell's virq and may cause conflict if
> an irq number is equal to gpio-langwell's virq mapped beforehand.
> 
> This patch tells gpio_langwell to not ignore irq_base if != 0 and
> preferably use it to avoid the conflict.
> 
> If DT is used, irq_base can safely be 0.
> 
> Signed-off-by: David Cohen <david.a.cohen@intel.com>

Presuming that you have tested this on Medfield and it still works there.

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
