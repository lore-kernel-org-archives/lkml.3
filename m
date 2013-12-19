Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3LSUYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:24:25 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:60947 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab3LSUYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:24:23 -0500
X-Auth-Info: ChldQ+xsqZ+rvuOcWFZafl43Y3zXA2+NbC3P9l2IDNw=
Date: Thu, 19 Dec 2013 21:24:19 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 04/12] clk: Add regmap core helpers for
 enable/disable/is_enabled
Message-ID: <20131219202419.GS8064@book.gsilab.sittig.org>
Mail-Followup-To: Mike Turquette <mturquette@linaro.org>,
	Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
	Saravana Kannan <skannan@codeaurora.org>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1381909214-12693-1-git-send-email-sboyd@codeaurora.org>
 <1381909214-12693-5-git-send-email-sboyd@codeaurora.org>
 <20131219045050.23538.94293@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219045050.23538.94293@quantum>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 20:50 -0800, Mike Turquette wrote:
> 
> Adding all of this stuff to struct clk_hw makes me a sad panda. You are
> essentially sharing a common set of ops for clocks that use regmap as
> their io operation back-end, and that is a good thing.
> 
> However, why not just do this as drivers/clk/clk-regmap.c, or
> drivers/clk/clk-gate-regmap.c? Putting the clk_ops callback functions in
> drivers/clk/clk.c is a little weird and putting those struct members
> into struct clk_hw is definitely strange.

Wasn't the idea to extend the set of register accessor routines
in <linux/clk-provider.h> such that memory mapped I/O as well as
regmap style becomes possible?  This is what I understood from
past iterations of discussing this approach.

I agree that duplicating the clock gate's implementation just to
access the register in a different way feels strange and somehow
unfortunate.

There still may be the issue of expensive operations only being
allowed within prepare and unprepare, while enable and disable
are supposed to be "cheap and straight forward", and should not
block and thus may not use external communication.  But that
appears to be orthogonal to the API which wraps register access.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
