Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaL3MPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 07:15:20 -0500
Received: from service87.mimecast.com ([91.220.42.44]:54483 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaL3MPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 07:15:19 -0500
Message-ID: <54A29752.2060204@arm.com>
Date: Tue, 30 Dec 2014 12:15:14 +0000
From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: Fix SCTLR_EL1 initialisation
References: <1418831421-19370-1-git-send-email-suzuki.poulose@arm.com> <20141217173915.GF30307@arm.com>
In-Reply-To: <20141217173915.GF30307@arm.com>
X-OriginalArrivalTime: 30 Dec 2014 12:15:15.0025 (UTC) FILETIME=[44809C10:01D0242A]
X-MC-Unique: 114123012151701501
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/12/14 17:39, Will Deacon wrote:
> On Wed, Dec 17, 2014 at 03:50:21PM +0000, Suzuki K. Poulose wrote:
>> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
>>
>> We initialise the SCTLR_EL1 value by read-modify-writeback
>> of the desired bits, leaving the other bits (including reserved
>> bits(RESx)) untouched. However, sometimes the boot monitor could
>> leave garbage values in the RESx bits which could have different
>> implications. This patch makes sure that all the bits, including
>> the RESx bits, are set to the proper state, except for the
>> 'endianness' control bits, EE(25) & E0E(24)- which are set early
>> in the el2_setup.
>>
>> Updated the state of the Bit[6] in the comment to RES0 in the
>> comment.
>>
>> Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> ---
>
> Looks good to me:
>
>    Acked-by: Will Deacon <will.deacon@arm.com>
>
> Is this 3.19 material, or simply a cleanup/being cautious?
Sorry, for the late response. Yes this is kind of being cautious.

Suzuki


