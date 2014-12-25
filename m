Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaLYQkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 11:40:43 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51285 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaLYQkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 11:40:39 -0500
Message-ID: <ed67f4786374535ed10d119860e76b15.squirrel@www.codeaurora.org>
In-Reply-To: <5481C7F9.1020909@ti.com>
References: <1417104021-2997-1-git-send-email-ygardi@codeaurora.org>
    <20141204155451.GA29255@infradead.org> <5481C7F9.1020909@ti.com>
Date: Thu, 25 Dec 2014 16:40:38 -0000
Subject: Re: [PATCH v4] scsi: ufs: add support of generic PHY and ICE in
 Qualcomm chips
From: ygardi@codeaurora.org
To: "Kishon Vijay Abraham I" <kishon@ti.com>
Cc: "Christoph Hellwig" <hch@infradead.org>,
        "Yaniv Gardi" <ygardi@codeaurora.org>,
        james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org,
        subhashj@codeaurora.org, noag@codeaurora.org, draviv@codeaurora.org,
        "Rob Herring" <robh+dt@kernel.org>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        "Vinayak Holikatti" <vinholikatti@gmail.com>,
        "James E.J. Bottomley" <jbottomley@parallels.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Christoph Hellwig" <hch@lst.de>,
        "Sujit Reddy Thumma" <sthumma@codeaurora.org>,
        "Raviv Shvili" <rshvili@codeaurora.org>,
        "Sahitya Tummala" <stummala@codeaurora.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks for inputs.
shortly I will upload a new version, where I address you comments

thanks,
Yaniv


>
> On Thursday 04 December 2014 09:24 PM, Christoph Hellwig wrote:
>> On Thu, Nov 27, 2014 at 05:59:58PM +0200, Yaniv Gardi wrote:
>>> In this change we add support to the generic PHY framework.
>>> Two UFS phys are implemented:
>>> qmp-20nm and qmp-28nm.
>>>
>>> Also, the files in this change implement the UFS HW (controller & PHY)
>>> specific behavior in Qualcomm chips.
>>> Relocation of a few header files is needed in order to expose routines
>>> and data structures between PHY driver and UFS driver.
>>>
>>> Also, this change include the implementation of Inline Crypto Engine
>>> (ICE)
>>> in Qualcomm chips.
>>
>> This whole patch is a mess.  It does way to many things in one patch,
>> and it doesn't explain enough of it.
>>
>> Please explain why you need it.  Especially as the PHY API is a generic
>> phy abstraction, so having to share defintions between the provider and
>> consumer seems wrong.  Even if you need some shared bits keep them to an
>> absolute minium insted of moving so much out of the driver directory.
>> Also if at all possible keep the shared data in a single header under
>> include/linux instead of having lots of global headers in a deep
>> directory structure.
>>
>> Second split this into patches that do a single things, and explain why
>> you're doing each:
>>
>>  1) header move if/as needed
>>  2) add 20nm phy driver
>>  3) add 28nm phy driver
>>  4) add ufs-qcom driver
>>  5) add ufs-qcom-ice support
>>
>> and so on.
>
> +1
>
> -Kishon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


