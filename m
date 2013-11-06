Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab3KFLPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:15:53 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42391 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab3KFLPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:15:52 -0500
Date: Wed, 6 Nov 2013 11:15:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: divider: fix rate calculation for fractional rates
Message-ID: <20131106111534.GW16735@n2100.arm.linux.org.uk>
References: <1383736008-22764-1-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383736008-22764-1-git-send-email-tomi.valkeinen@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 01:06:48PM +0200, Tomi Valkeinen wrote:
> This means that the following code works a bit oddly:
> 
> rate = clk_round_rate(clk, 123428572);
> clk_set_rate(clk, rate);

You're right, but the above sequence is quite a crass thing to do.  Why?

clk_round_rate() returns the clock rate that clk_set_rate() would give
you if you were to use this sequence:

	clk_rate_rate(clk, 123428572);
	rate = clk_get_rate(clk);

The difference is that it doesn't change the actual clock rate itself;
clk_round_rate() is meant to answer the question:

	"If I were to set _this_ rate, what clock rate would
	 the clock give me?"

thereby providing a method for drivers to inquire what the effect would
be when changing such a clock without actually affecting it.

So please, don't use clk_round_rate() followed by clk_set_rate().
