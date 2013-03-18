Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3CRSq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:46:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21798 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3CRSq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:46:27 -0400
X-IronPort-AV: E=Sophos;i="4.84,865,1355126400"; 
   d="scan'208";a="30405935"
Message-ID: <51476103.40901@codeaurora.org>
Date: Mon, 18 Mar 2013 11:46:27 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCHv2 3/3] ARM: Work around faulty ISAR0 register in some
 Krait CPUs
References: <1363631337-13816-1-git-send-email-sboyd@codeaurora.org> <1363631337-13816-4-git-send-email-sboyd@codeaurora.org> <20130318183435.GD31193@mudshark.cambridge.arm.com>
In-Reply-To: <20130318183435.GD31193@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/13 11:34, Will Deacon wrote:
> On Mon, Mar 18, 2013 at 06:28:57PM +0000, Stephen Boyd wrote:
>> From: Stepan Moskovchenko <stepanm@codeaurora.org>
>>
>> Some early versions of the Krait CPU design incorrectly indicate
>> that they only support the UDIV and SDIV instructions in Thumb
>> mode when they actually support them in ARM and Thumb mode. It
>> seems that these CPUs follow the DDI0406B ARM ARM which has two
>> possible values for the divide instructions field, instead of the
>> DDI0406C document which has three possible values.
>>
>> Work around this problem by checking the MIDR against Krait CPUs
>> with this faulty ISAR0 register and force the hwcaps to indicate
>> support in both modes.
>>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
>> [sboyd: Rewrote commit text to reflect real reasoning now that
>> 	we autodetect udiv/sdiv]
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  arch/arm/mm/proc-v7.S | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
> Acked-by: Will Deacon <will.deacon@arm.com>
>

Thanks. Put all three in the patch tracker.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

