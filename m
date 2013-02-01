Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab3BAQOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 11:14:12 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37310 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab3BAQOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:14:10 -0500
Message-ID: <510BE9BC.9090701@ti.com>
Date: Fri, 1 Feb 2013 11:13:48 -0500
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <sboyd@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        <paulmck@linux.vnet.ibm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, <marc.zyngier@arm.com>,
        <linus.walleij@linaro.org>
Subject: Re: [PATCH v4 00/13] ARM LPAE Fixes - Part 1
References: <1359669512-31276-1-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1301312252230.6300@xanadu.home> <510BDAED.8060805@ti.com> <20130201151410.GR23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130201151410.GR23505@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 10:14 AM, Russell King - ARM Linux wrote:
> On Fri, Feb 01, 2013 at 10:10:37AM -0500, Cyril Chemparathy wrote:
>> With this, I ran simple network and filesystem performance tests to
>> compare the code-patching vs. non-code-patching variants.  These tests
>> didn't yield any significant performance difference between the two on
>> an ARMv7 (Cortex-A8) platform.
>
> It's not network and fs activity that this kind of stuff is likely to
> show up in, but more to do with walking pages tables and the like -
> remember that page tables are stored using physical addresses, and any
> walks of them have to convert those physical addresses to virtual
> addresses and back again.
>
> So, things like page scanning for eviction (eg, page aging, page
> faults even those which just re-use a page from the page cache) have
> to use the v:p / p:v translation macros.
>

Thanks, Russell.  Any recommendations on how to best benchmark this?

Thanks
-- Cyril.
