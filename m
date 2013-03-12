Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab3CLNks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:40:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33305 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3CLNkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:40:47 -0400
Date: Tue, 12 Mar 2013 13:40:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Bill Huang <bilhuang@nvidia.com>
Cc: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [RFC 1/1] clk: Add notifier support in
	clk_prepare_enable/clk_disable_unprepare
Message-ID: <20130312134032.GU4977@n2100.arm.linux.org.uk>
References: <1363091861-21534-1-git-send-email-bilhuang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363091861-21534-1-git-send-email-bilhuang@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 05:37:41AM -0700, Bill Huang wrote:
> Add the below four notifier events so drivers which are interested in
> knowing the clock status can act accordingly. This is extremely useful
> in some of the DVFS (Dynamic Voltage Frequency Scaling) design.
> 
> PRE_CLK_ENABLE
> POST_CLK_ENABLE
> PRE_CLK_DISABLE
> POST_CLK_DISABLE
> 
> Signed-off-by: Bill Huang <bilhuang@nvidia.com>

NAK.  *Sigh* NO, this is the wrong level to be doing stuff like this.

The *ONLY* thing that clk_prepare_enable() and clk_prepare_disable() should
*EVER* be doing is calling clk_prepare(), clk_enable(), clk_disable() and
clk_unprepare().  Those two functions are *merely* helpers for drivers
who don't wish to make the individual calls.

Drivers are still completely free to call the individual functions, at
which point your proposal breaks horribly - and they _do_ call the
individual functions.
