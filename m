Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaBYQmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 11:42:24 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:33415 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaBYQmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:42:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKedQu30rX=k8U5Harzki1jAzKhG3OyPT75y=K+by7pVw@mail.gmail.com>
References: <1392956661-28787-1-git-send-email-joelf@ti.com>
	<20140221121548.GF8783@e106331-lin.cambridge.arm.com>
	<53078E9B.5010806@ti.com>
	<CAL_JsqKedQu30rX=k8U5Harzki1jAzKhG3OyPT75y=K+by7pVw@mail.gmail.com>
Date: Tue, 25 Feb 2014 10:42:09 -0600
Message-ID: <CAD=GYpaTypACGGvf5twNa2J0Ngr3X1yMFvTaEFuYuagFdkjfpw@mail.gmail.com>
Subject: Re: [PATCH] ARM: EDMA: Use platform_get_resource functions for DT
From: Joel Fernandes <agnel.joel@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Joel Fernandes <joelf@ti.com>, Mark Rutland <mark.rutland@arm.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        "nsekhar@ti.com" <nsekhar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your suggestions.

On Tue, Feb 25, 2014 at 10:22 AM, Rob Herring <robherring2@gmail.com> wrote:
> On Fri, Feb 21, 2014 at 11:36 AM, Joel Fernandes <joelf@ti.com> wrote:
>> On 02/21/2014 06:15 AM, Mark Rutland wrote:
>>>> Also, while at it get rid of the assumption in the code that "CC" is at reg
>>>> index 0 in the DT and xbar is at offset 1. Instead use reg-names to get the
>>>> memory resource in concern keeping things much cleaner and simpler. This also
>>>> makes it possible to have multiple channel controllers.
>>>
>>> While this is nice I think we have to have a fallback to the existing
>>> behaviour if there's no reg-names property present, unless we know for
>>> certain no-one is possibly using an existing DTB.
>>
>> Yes, its true it break existing DTBs but currently only 2 TI SoCs use EDMA this
>> way, the vast majority of EDMA users are yet to follow where we can do it right.
>>  Further, the old bindings are really limiting specially the 2 CC case and if
>> additionally memory maps are used in the future. So keeping the old binding is
>> limiting in this regard.
>>
>> Here is what the platform_data used to look like when used by mach-davinci:
>>
>> static struct resource da850_edma_resources[] = {
>>         {
>>                 .name   = "edma_cc0",
>>                 .start  = DA8XX_TPCC_BASE,
>>                 .end    = DA8XX_TPCC_BASE + SZ_32K - 1,
>>                 .flags  = IORESOURCE_MEM,
>>         },
>>         {
>>                 .name   = "edma_tc0",
>>                 .start  = DA8XX_TPTC0_BASE,
>>                 .end    = DA8XX_TPTC0_BASE + SZ_1K - 1,
>>                 .flags  = IORESOURCE_MEM,
>>         },
>>         {
>>                 .name   = "edma_tc1",
>>                 .start  = DA8XX_TPTC1_BASE,
>>                 .end    = DA8XX_TPTC1_BASE + SZ_1K - 1,
>>                 .flags  = IORESOURCE_MEM,
>>         },
>>         {
>>                 .name   = "edma_cc1",
>>                 .start  = DA850_TPCC1_BASE,
>>                 .end    = DA850_TPCC1_BASE + SZ_32K - 1,
>>                 .flags  = IORESOURCE_MEM,
>>         },
>>
>> As you can see, there are several memory maps and different interpretations.
>> Considering this, IMO- it makes sense to pay a small price to keep the semantics
>> sane.
>
> Then do 1 compatible string per interpretation. That can then define
> the number of CCs and TCs.

Ok.

>>
>> On the other hand, the other 2 options are:
>> 1. We add a fallback if reg-names look up fails.
>
> reg-names is supposed to be optional, so you should already have that fallback.

With the new binding, without reg-names not sure how to fall back
there can variable number of different reg entries of different types.
There's no way to know when one ends and the other begins. The fall
back I mentioned can only work for old dtbs that only specify 1 CC.

Thanks,
-Joel
