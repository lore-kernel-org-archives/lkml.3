Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab3KNIuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:50:15 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:33344 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3KNIuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:50:11 -0500
MIME-Version: 1.0
In-Reply-To: <4743540.rTIWauTJHg@avalon>
References: <20131113225927.21449.78044.sendpatchset@w520>
	<1906707.rpHAsqdqKq@avalon>
	<CANqRtoR+ngS5o77Lw1gUUzq-qcHuBZtfiiAnALvH_GsNMvNN7A@mail.gmail.com>
	<4743540.rTIWauTJHg@avalon>
Date: Thu, 14 Nov 2013 17:50:09 +0900
Message-ID: <CANqRtoSkTBG1o1Vrfay_qPxwoyCuitH5cJNCjDdEuiPf0XjvUw@mail.gmail.com>
Subject: Re: [PATCH 01/03] gpio: rcar: Use lazy disable and mask on suspend
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Simon Horman [Horms]" <horms@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Thu, Nov 14, 2013 at 11:17 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus,
>
> On Thursday 14 November 2013 11:03:06 Magnus Damm wrote:
>> On Thu, Nov 14, 2013 at 9:07 AM, Laurent Pinchart wrote:
>> > On Thursday 14 November 2013 07:59:36 Magnus Damm wrote:
>> >> From: Magnus Damm <damm@opensource.se>
>> >>
>> >> Set the ->irq_enable() and ->irq_disable() methods to NULL
>> >> to enable lazy disable of interrupts.
>> >
>> > Is that just for optimization purpose, or is there another reason ?
>>
>> It is needed for IRQCHIP_MASK_ON_SUSPEND operation, which in turn is
>> needed for Suspend-to-RAM.
>>
>> >> Also extend the code to set IRQCHIP_MASK_ON_SUSPEND which tells the core
>> >> that only IRQs marked as wakeups need to stay enabled during
>> >> Suspend-to-RAM.
>> >
>> > Shouldn't this be split to a separate patch ?
>>
>> I could split them up, but since there is a dependency and since I
>> mainly care about making sure Suspend-to-RAM works I preferred to keep
>> them together.
>
> Fine with me. Could you then please update the commit message to mention that
> lazy disabling is required for IRQCHIP_MASK_ON_SUSPEND ? Same comment for
> patch 03/03.

Since when is it common practise to describe the dependencies for the
various components included in a single commit? My opinion is that the
person reading the code if requiring more information will have to
grep for IRQCHIP_MASK_ON_SUSPEND in the friendly source code and learn
how the subsystem is held together.

In the case you have some special detailed commit message that you
would like me to use then please feel free to propose that. If not
then I will then split up the patches.

/ magnus
