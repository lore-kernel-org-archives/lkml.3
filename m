Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbaENNz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:55:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:10219 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605AbaENNzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:55:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1052,1389772800"; 
   d="scan'208";a="432041445"
Date: Wed, 14 May 2014 16:55:49 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mike Turquette <mturquette@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Li Aubrey <aubrey.li@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] clk: new basic clk type for fractional divider
Message-ID: <20140514135548.GC12238@xps8300>
References: <1399983233-18037-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1399983233-18037-4-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399983233-18037-4-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 03:13:52PM +0300, Heikki Krogerus wrote:
> +static unsigned long clk_fd_recalc_rate(struct clk_hw *hw,
> +					unsigned long parent_rate)
> +{
> +	struct clk_fractional_divider *fd = to_clk_fd(hw);
> +	unsigned long flags = 0;
> +	u64 n, m;
> +	u32 val;
> +
> +	if (fd->lock)
> +		spin_lock_irqsave(fd->lock, flags);
> +
> +	val = clk_readl(fd->reg);
> +
> +	if (fd->lock)
> +		spin_unlock_irqrestore(fd->lock, flags);
> +
> +	m = (val & fd->mmask) >> fd->mshift;
> +	n = (val & fd->nmask) >> fd->nshift;
> +
> +	return parent_rate * m / n;
> +}

Andy noticed an issue here but he commented it outside the list. I
need to use do_div() here. He had also some nitpicks for the other
patches, so I'll prepare a new version for all of these tomorrow.


-- 
heikki
