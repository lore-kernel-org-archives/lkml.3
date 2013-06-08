Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab3FHJdE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 05:33:04 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:41471 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab3FHJdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 05:33:02 -0400
Message-ID: <51B2FA44.4020100@jic23.retrosnub.co.uk>
Date: Sat, 08 Jun 2013 10:32:52 +0100
From: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Jonathan Cameron <jic23@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: Arm sub architectures missing clk_round_rate()
References: <51B2F1ED.2090801@kernel.org> <20130608092133.GI18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130608092133.GI18614@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'd Eric and Haojian, sorry should have done that in the first place.

On 06/08/2013 10:21 AM, Russell King - ARM Linux wrote:
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
> The right answer is (2) now that we have things like the clk framework and
> soo many users.
