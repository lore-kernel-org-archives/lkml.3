Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab3HXPQv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 11:16:51 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:49289 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3HXPQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 11:16:49 -0400
Message-ID: <5218CE5B.1020906@gmail.com>
Date: Sat, 24 Aug 2013 17:16:43 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        jiada_wang@mentor.com, broonie@kernel.org, vapier@gentoo.org,
        ralf@linux-mips.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, shawn.guo@linaro.org,
        sebastian.hesselbarth@gmail.com, LW@KARO-electronics.de,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v3 3/5] clk: Add common __clk_get(), __clk_put() implementations
References: <1377270227-1030-1-git-send-email-s.nawrocki@samsung.com> <1377270227-1030-4-git-send-email-s.nawrocki@samsung.com> <20130823231314.GR6617@n2100.arm.linux.org.uk>
In-Reply-To: <20130823231314.GR6617@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2013 01:13 AM, Russell King - ARM Linux wrote:
> On Fri, Aug 23, 2013 at 05:03:45PM +0200, Sylwester Nawrocki wrote:
>> >  This patch adds common __clk_get(), __clk_put() clkdev helpers which
>> >  replace their platform specific counterparts when the common clock
>> >  API is enabled.
>> >
>> >  The owner module pointer field is added to struct clk so a reference
>> >  to the clock supplier module can be taken by the clock consumers.
>> >
>> >  Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> >  Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>
> I'm mostly happy with this now.
>
>> >  +int __clk_get(struct clk *clk)
>> >  +{
>> >  +	if (clk&&  !try_module_get(clk->owner))
>> >  +		return 0;
>> >  +
>> >  +	return 1;
>> >  +}
>> >  +EXPORT_SYMBOL(__clk_get);
>> >  +
>> >  +void __clk_put(struct clk *clk)
>> >  +{
>> >  +	if (WARN_ON_ONCE(IS_ERR(clk)))
>> >  +		return;
>> >  +
>> >  +	if (clk)
>> >  +		module_put(clk->owner);
>> >  +}
>> >  +EXPORT_SYMBOL(__clk_put);
>
> Why are these exported?  clkdev can only be built into the kernel, as can
> the common clk framework - they can't be modular.  So why would a module
> wish to access these directly?

I must have been mislead by the fact that some ARM sub-architecture exports
those, have added them initially and then didn't think enough about it and
left these in. Actually, at some point I noticed the exporting is not 
needed,
but never did get around to remove it. Thanks. The updated series to 
follow.




