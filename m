Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab3CRRDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:03:51 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16608 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3CRRDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:03:49 -0400
X-IronPort-AV: E=Sophos;i="4.84,865,1355126400"; 
   d="scan'208";a="30368545"
Message-ID: <514748F5.70504@codeaurora.org>
Date: Mon, 18 Mar 2013 10:03:49 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH 3/3] ARM: Work around faulty ISAR0 register in some Krait
 CPUs
References: <1363138321-27849-1-git-send-email-sboyd@codeaurora.org> <1363138321-27849-4-git-send-email-sboyd@codeaurora.org> <20130317142854.GC19071@mudshark.cambridge.arm.com>
In-Reply-To: <20130317142854.GC19071@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/13 07:28, Will Deacon wrote:
> On Wed, Mar 13, 2013 at 01:32:01AM +0000, Stephen Boyd wrote:
>> Some early versions of the Krait CPU design incorrectly indicate
>> that they only support the UDIV and SDIV instructions in Thumb
>> mode when they actually support them in ARM and Thumb mode. It
>> seems that these CPUs follow the DDI0406B ARM ARM which has two
>> possible values for the divide instructions field, instead of the
>> DDI0406C document which has three possible values.
>>
>> Work around this problem by checking the MIDR against Krait CPUs
>> with this faulty ISAR0 register and force the detection code
>> to indicate support in both modes.
>>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  arch/arm/kernel/setup.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
> After all this, you might as well just pass the relevant HWCAPs for your
> krait entry in proc-v7.S rather than have an exception in the CPU-agnostic
> code.

Ok. Care to ack the previous patch I sent then?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

