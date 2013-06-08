Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab3FHKON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 06:14:13 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:59668 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3FHKOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 06:14:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130608092133.GI18614@n2100.arm.linux.org.uk>
References: <51B2F1ED.2090801@kernel.org>
	<20130608092133.GI18614@n2100.arm.linux.org.uk>
Date: Sat, 8 Jun 2013 18:14:11 +0800
Message-ID: <CAN1soZxjfcqyyvfpB=QEtGK5sa-XRnPnNjJOf1KnavLP18c4cw@mail.gmail.com>
Subject: Re: Arm sub architectures missing clk_round_rate()
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jonathan Cameron <jic23@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 8, 2013 at 5:21 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Jun 08, 2013 at 09:57:17AM +0100, Jonathan Cameron wrote:
>> At least one Arm subarch (pxa) does no provide an implementation of this
>> function.  As far as I can see there is no way for a driver wishing to use
>> it to detect it's absence.  This is marked in clk.h as being optional
>> for 'Machine Class support'. Obvious solutions to this are:
>>
>> 1) It is effectively only usable by platform specific drivers as no
>>    more generic driver can know it is available.  Perhaps even a stub that
>>    returns an appropriate error would be acceptable.
>>
>> 2) It is not as optional as the header implies and should always be implemented
>>    if the rest of the clk framework is.
>>
>> 3) There should be some means of detecting its absense so that drivers can
>>    be dependant on its presene.
>>
>> Which is the correct one?
>
> The right answer is (2) now that we have things like the clk framework and
> soo many users.

Yes, we need to fix it. I'll handle it.

Regards
Haojian
