Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaAIByc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 20:54:32 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37271 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAIBya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 20:54:30 -0500
Message-ID: <52CE0154.4030803@codeaurora.org>
Date: Wed, 08 Jan 2014 17:54:28 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Courtney Cavin <courtney.cavin@sonymobile.com>,
        Borislav Petkov <bp@alien8.de>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 3/6] ARM: Add Krait L2 accessor functions
References: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org> <1388434457-4194-4-git-send-email-sboyd@codeaurora.org> <20140109005332.GB23276@sonymobile.com>
In-Reply-To: <20140109005332.GB23276@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/14 16:53, Courtney Cavin wrote:
> On Mon, Dec 30, 2013 at 09:14:14PM +0100, Stephen Boyd wrote:
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
>>  4 files changed, 82 insertions(+)
>>  create mode 100644 arch/arm/common/krait-l2-accessors.c
>>  create mode 100644 arch/arm/include/asm/krait-l2-accessors.h
> [...]
>> +
>> +extern void set_l2_indirect_reg(u32 addr, u32 val);
>> +extern u32 get_l2_indirect_reg(u32 addr);
> As these are Krait specific, please rename the functions to reflect
> this.
>

Ok. Borislav, should I resend to add krait_ before these functions?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

