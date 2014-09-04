Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaIDRbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:31:05 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:57958 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaIDRbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:31:03 -0400
MIME-Version: 1.0
In-Reply-To: <CANLsYkzAE1a8SmbEtGz5f14NfHX0R51RBAUkZZv==OkZBJzTFw@mail.gmail.com>
References: <1409159852-7249-1-git-send-email-mathieu.poirier@linaro.org>
	<1409159852-7249-8-git-send-email-mathieu.poirier@linaro.org>
	<CACRpkdZO7Mo_JaecjypR_kXKwaatgU+4oLLKheQ22OcNMG_-nQ@mail.gmail.com>
	<CANLsYkzAE1a8SmbEtGz5f14NfHX0R51RBAUkZZv==OkZBJzTFw@mail.gmail.com>
Date: Thu, 4 Sep 2014 19:31:02 +0200
Message-ID: <CACRpkda6Rj0ZJ4NfKtqV=0p_OVEpjmSLNsUM7Z0MC3UMn43HGg@mail.gmail.com>
Subject: Re: [PATCH 07/11 v5] coresight-etm: add CoreSight ETM/PTM driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        Kaixu Xia <kaixu.xia@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>,
        "r.sengupta@samsung.com" <r.sengupta@samsung.com>,
        Robert Marklund <robbelibobban@gmail.com>,
        Tony Armitstead <Tony.Armitstead@arm.com>,
        Patch Tracking <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 7:19 PM, Mathieu Poirier
<mathieu.poirier@linaro.org> wrote:
> [Me]:
>> I would rewrite the last function like this:
>>
>> static inline unsigned int etm_readl(struct etm_drvdata *drvdata, u32 off)
>> {
>>        u32 val;
>>
>>        if (drvdata->use_cp14)
>>                asm_volatile()...
>>        else
>>                val = readl_relaxed(drvdata->base + off);
>>        return val;
>> }
>
> That unfortunately won't work.  "u32 off" is a numerical value and it
> works well in the case were CP14 accesses aren't needed.  On the flip
> side that numerical value isn't sufficient to deduce all 3 arguments
> (crn, crm, op2) required by instructions mcr/mrc for the right access
> to happen - there is simply no correlation between the offset of an
> APB bus memory mapped address and the corresponding CP14 access.

You're right, I oversimplified it in my head grossly...

Jens Wiklander pointed me to the macros used in OP-TEE for CP15
access with the same unpredictable patterns:
https://github.com/OP-TEE/optee_os/tree/master/core/arch/arm32/include

Yours,
Linus Walleij
