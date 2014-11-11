Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaKKTtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:49:16 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbaKKTtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:49:14 -0500
Message-ID: <54626835.40503@nod.at>
Date: Tue, 11 Nov 2014 20:49:09 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Tanya Brokhman <tlinder@codeaurora.org>, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V6] UBI: Extend UBI layer debug/messaging capabilities
References: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org>		 <5460F7D8.2030100@nod.at> <5461C5AD.5040705@nod.at>	 <1415707434.22887.158.camel@sauron.fi.intel.com> <5462003C.9090509@nod.at> <1415712477.22887.172.camel@sauron.fi.intel.com>
In-Reply-To: <1415712477.22887.172.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.11.2014 um 14:27 schrieb Artem Bityutskiy:
> On Tue, 2014-11-11 at 13:25 +0100, Richard Weinberger wrote:
>> Am 11.11.2014 um 13:03 schrieb Artem Bityutskiy:
>>> On Tue, 2014-11-11 at 09:15 +0100, Richard Weinberger wrote:
>>>>> Do we really want the function name in every log message?
>>>>> IMHO this is not wise except for pure debug logs.
>>>>
>>>> BTW: Why UBI-X? This looks odd. Either use UBIX or ubiX.
>>>
>>> How about something like this (untested):
>>>
>>>
>>> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>>> Date: Tue, 11 Nov 2014 13:56:34 +0200
>>> Subject: [PATCH] UBI: clean-up printing helpers
>>>
>>> Let's prefix UBI messages with 'ubiX' instead of 'UBI-X' - this is more
>>> consistent with the way we name UBI devices.
>>>
>>> Also, commit "32608703 UBI: Extend UBI layer debug/messaging capabilities"
>>> added the function name print to 'ubi_msg()' - lets revert this change, since
>>> these messages are supposed to be just informative messages, and not debugging
>>> messages.
>>
>> What is the benefit of having the function name still in ubi_warn() and ubi_err()?
> 
> The benefit is that it is easier to find the source code where the
> message comes from. And not necessarily because the message is
> "cryptic", but because you may want to check the possible reasons of the
> problem from the code.
> 
>> e.g.
>> [   95.511825] ubi0 error: ubi_attach_mtd_dev: mtd0 is already attached to ubi0
>>
>> If the log message is so cryptic that you need to lookup it in the source to understand it,
>> we better fix the message.
> 
> UBI messages are usually not cryptic, and I think we did try to keep
> them user-friendly. If you hit a cryptic error or warning message, do
> not hesitate to improve it please. Debug messages are often cryptic.

That's my point. UBI has very good messages. From the message you
know in most cases exactly what is going on and in what sub-system you
have to look.

> I am OK with removing function names from warnings and errors, though.
> But they were there since the very beginning, and changing this is a
> separate subject, so I'd prefer someone else to submit a corresponding
> patch.

If we keep the function names away from ubi_msg() I'm perfectly fine. :-)

Thanks,
//richard
