Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab3IIElD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 00:41:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52683 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751359Ab3IIElB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 00:41:01 -0400
Message-ID: <522D515A.30308@free-electrons.com>
Date: Mon, 09 Sep 2013 06:40:58 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: paul.mckenney@linaro.org, akpm@linux-foundation.org, decot@googlers.com,
        amirv@mellanox.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] genirq: add IRQF_NONE
References: <1378698519-4780-1-git-send-email-michael.opdenacker@free-electrons.com> <20130909040244.GA1157@leaf>
In-Reply-To: <20130909040244.GA1157@leaf>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On 09/09/2013 06:02 AM, Josh Triplett wrote:
> On Mon, Sep 09, 2013 at 05:48:39AM +0200, Michael Opdenacker wrote:
>> What about adding an IRQF_NONE flag as in the below patch?
>>
>> I'm currently working on removing the use of the deprecated
>> IRQF_DISABLED flag, and frequently have to replace
>> IRQF_DISABLED by 0, typically in request_irq() arguments.
>>
>> Using IRQF_NONE instead of 0 would make the code more readable,
>> at least for people reading driver code for the first time.
>>
>> Would it worth it?
>>
>> I'm sure this kind of idea has come up many times before...
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> I don't think it makes sense, no; it's a flags field, meant to receive a
> set of flags, and 0 is the standard empty set of flags.  I think
> IRQF_NONE would actually reduce readability, especially for readers who
> haven't seen it before, because it isn't immediately obvious that it
> just corresponds to the 0 of "no flags".  My first guess reading it
> would be that it's some non-zero flag with some non-obvious semantic,
> such as "don't actually allocate an IRQ", or something strange like
Thanks for your feedback. It's true that 0 for a flag is clear enough,
and that IRQF_NONE will be more confusing.

I was just thinking the IRQF_NONE would make it clearer that the
corresponding argument is a flag. This way, people reading "0" wouldn't
have to lookup the prototype of request_irq() to know what type of
argument this is (flag, number of resources, boolean....)

So, this may be a little helpful for completely new people, but more
confusing for people with a little more experience, as you explained.

I agree not to sacrifice the latter.

Thanks again,

Michael.

-- 
Michael Opdenacker, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

