Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaLLX0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 18:26:34 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:54719 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752125AbaLLX0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 18:26:33 -0500
Date: Fri, 12 Dec 2014 23:26:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Really fix deadlock with mmap_sem
Message-ID: <20141212232626.GY11285@n2100.arm.linux.org.uk>
References: <1418425456-19364-1-git-send-email-sboyd@codeaurora.org>
 <20141212230543.GX11285@n2100.arm.linux.org.uk>
 <20141212232416.20398.58297@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141212232416.20398.58297@quantum>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 03:24:16PM -0800, Mike Turquette wrote:
> Quoting Russell King - ARM Linux (2014-12-12 15:05:43)
> > On Fri, Dec 12, 2014 at 03:04:16PM -0800, Stephen Boyd wrote:
> > > Commit 6314b6796e3c (clk: Don't hold prepare_lock across debugfs
> > > creation, 2014-09-04) forgot to update one place where we hold
> > > the prepare_lock while creating debugfs directories. This means
> > > we still have the chance of a deadlock that the commit was trying
> > > to fix. Actually fix it by moving the debugfs creation outside
> > > the prepare_lock.
> > > 
> > > Reported-by: Russell King - ARM Linux <linux@arm.linux.org.uk>
> > 
> > Please use "Russell King <rmk+kernel@arm.linux.org.uk>" rather than this
> > address, thanks.
> 
> Applied to clk-next and fixed up the email address locally.

Please make sure it gets into stable kernels too as v3.18 suffers from
this bug, thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
