Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaCCTiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:38:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40999 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbaCCTiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:38:51 -0500
Message-ID: <5314DA49.9060001@codeaurora.org>
Date: Mon, 03 Mar 2014 11:38:49 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Gerhard Sittig <gsi@denx.de>, Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] clk: CCF clock primitives + custom IO accessors
References: <1393630495-29689-1-git-send-email-soren.brinkmann@xilinx.com> <20140302202940.GQ3327@book.gsilab.sittig.org> <19206d89-cd0d-4fea-9170-3fd0a8482bf5@VA3EHSMHS045.ehs.local> <20140303190736.GU3327@book.gsilab.sittig.org> <87e0d582-77a2-4645-a52a-c303b7cd8b84@VA3EHSMHS007.ehs.local>
In-Reply-To: <87e0d582-77a2-4645-a52a-c303b7cd8b84@VA3EHSMHS007.ehs.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/14 11:13, Sören Brinkmann wrote:
> On Mon, 2014-03-03 at 08:07PM +0100, Gerhard Sittig wrote:
>> On Mon, Mar 03, 2014 at 09:35 -0800, Sören Brinkmann wrote:
>>> It would be nice if we could use the logic provided in the mux, div etc
>>> primitives independently of how the HW is accessed and what is
>>> necessary to shift and mask those register values around, right? I
>>> mean, at then end we want to model a clk-(div|mux) and not a
>>> clk-(div|mux) which has only a single, memory-mapped control register,
>>> that does not overlap with other things, ...
>> Did you lookup the ll_ops discussion in the thread that
>> originated from
>> http://article.gmane.org/gmane.linux.ports.arm.kernel/289895 and
>> did you see the outlined logic in
>> http://article.gmane.org/gmane.linux.ports.arm.omap/109233 and
>> http://article.gmane.org/gmane.linux.ports.arm.omap/109381 ?
>>
>> Support for regmap access instead of mere MMIO was one of the
>> things you could do with this approach.  You appear to be in the
>> situation where you need such an extension (or something similar,
>> but you really should look into the ll_ops thing).
> Thanks for those pointer, I have some reading to do. That seems to
> go into the right direction.  What is the status of those patches?
> Are they already merged or actively worked on?
>

Ugh. The ll_ops design is a simplified form of regmap. Why not just use
regmap? It seems like it would be possible to make a regmap per
clk_register_{basic_type}() call via regmap_init_mmio() while still
allowing those functions to take a void __iomem pointer. Then we could
remove clk_readl/clk_writel (after providing *_be variants of the
registration functions for PPC) and just use a regmap throughout the
basic clock type code. Finally we can introduce *_regmap() registration
functions that allow drivers to register basic clock types with regmaps.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

