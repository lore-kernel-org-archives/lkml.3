Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaAGXKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:10:08 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35615 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaAGXKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:10:02 -0500
Message-ID: <52CC8947.7020900@codeaurora.org>
Date: Tue, 07 Jan 2014 15:09:59 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 3/6] ARM: Add Krait L2 accessor functions
References: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org> <1388434457-4194-4-git-send-email-sboyd@codeaurora.org> <20140107230725.GG4164@pd.tnic>
In-Reply-To: <20140107230725.GG4164@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/14 15:07, Borislav Petkov wrote:
> On Mon, Dec 30, 2013 at 12:14:14PM -0800, Stephen Boyd wrote:
>> Krait CPUs have a handful of L2 cache controller registers that
>> live behind a cp15 based indirection register. First you program
>> the indirection register (l2cpselr) to point the L2 'window'
>> register (l2cpdr) at what you want to read/write.  Then you
>> read/write the 'window' register to do what you want. The
>> l2cpselr register is not banked per-cpu so we must lock around
>> accesses to it to prevent other CPUs from re-pointing l2cpdr
>> underneath us.
>>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  arch/arm/common/Kconfig                   |  3 ++
>>  arch/arm/common/Makefile                  |  1 +
>>  arch/arm/common/krait-l2-accessors.c      | 58 +++++++++++++++++++++++++++++++
>>  arch/arm/include/asm/krait-l2-accessors.h | 20 +++++++++++
> I'm no ARM guy but out of curiosity, why is this code not part of the
> krait edac driver? IOW, is there a compelling reason for it to be in
> arch/arm/common/?

This is used for more than just the edac driver. In the future, we'll
need this for the cpufreq driver and the l2 performance monitor driver.
I suppose I could have stated that in the commit text.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

