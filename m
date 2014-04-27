Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaD0TNe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 15:13:34 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:53818 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751326AbaD0TNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 15:13:32 -0400
Date: Sun, 27 Apr 2014 20:12:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] clkdev: only fall through to clk_get_sys() if DT
	indicates no entry
Message-ID: <20140427191238.GE26756@n2100.arm.linux.org.uk>
References: <E1We4rQ-0001mv-Ps@rmk-PC.arm.linux.org.uk> <535D55C6.9090609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535D55C6.9090609@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 09:08:54PM +0200, Sylwester Nawrocki wrote:
> On 04/26/2014 05:49 PM, Russell King wrote:
>> There are two failures which DT can return when looking up a phandle:
>> -ENOENT - when DT finds that the desired property/index is not present
>> -EINVAL - when DT finds that the desired property/index is present, but
>>   there is a problem parsing it.
>>
>> We should only fall through to clk_get_sys() (the table driven clock
>> lookup) when DT indicates that there was no entry in the OF tables
>> for the clock.  Doing otherwise causes the clk API to always indicate
>> that there is no entry for this clock, which is not correct behaviour.
>>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
>> ---
>> Grant, Rob,
>>
>> Please let me know ASAP if this gives you any cause for concern.  This
>> looks to me like a long standing bug which really needs fixing.  Part
>> of the motivation here is similar to Jean-Francois' patch to clkdev
>> which allows a DT specified clock which isn't get present to have
>> clk_get() and friends return -EPROBE_DEFER - again, something that I
>> think really should happen.  Jean-Francois hasn't been able to get
>> much traction for his patch, so let's start with fixing this bug first.
>
> How about upstream commit a34cd4666f3da84228a82f70c94b8d9b692034ea,
> I thought it already solves the issue you're trying to address in
> this patch ?

FFS.  You know, I thought _I_ was the clkdev maintainer, not Mike.

That commit is wrong for the reasons I've stated above.  Why should we
fall through to clk_get_sys() if the DT stuff returns -EINVAL?

Okay, I'll re-spin against that patch and fix this crap.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
