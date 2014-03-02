Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaCBU3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 15:29:52 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:50165 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaCBU3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 15:29:50 -0500
X-Auth-Info: OkcPx3Rg2lWmdIKMAGDninuJ0WFKsFJyXQZCoL16L+E=
Date: Sun, 2 Mar 2014 21:29:40 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] clk: CCF clock primitives + custom IO accessors
Message-ID: <20140302202940.GQ3327@book.gsilab.sittig.org>
References: <1393630495-29689-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393630495-29689-1-git-send-email-soren.brinkmann@xilinx.com>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 15:34 -0800, Soren Brinkmann wrote:
> 
> [ MMIO registers assumed for clock control modules, but I2C
> communication may be involved in other hardware, individual for
> a (set of) clock(s) and not for an architecture or platform ]
> 
> Does anybody have a good idea how we could avoid all this code
> duplication while enabling usage of the clock primitives with different
> IO accessors?
> Especially the divider and mux primitive have a lot of code that would
> be painful to maintain twice.

Hasn't past discussion already reached the point where code
duplication of the clock control logic was considered
undesirable, and "low level ops" were outlined?  I.e. extending
the compile time decision for a specific clk_{read,write}l()
implementation by another potential redirection that is specific
to a clock item?

Re-submitting a series which duplicates complete clock types,
while the difference is only in how registers get accessed, is
quite saddening.


> In the next step, I encountered a divider clock whose divider is stored
> in 2 I2C registers. So now, the simple IO access replacement doesn't
> work anymore either since this clock needs 2 registers to be read and
> then shifting around the bitfields accordingly.

Are the registers adjacent and contain only bit fields for one
clock?  Or do registers share parameters for several clocks, or
are not adjacent?

In the former case you may use a table from "divider value" to
"bit pattern to read/write".  In the latter case, the clock
control module is rather special, and may not be easily get
mapped to the common primitives.  Unless the ll_ops can implement
the required special handling.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
