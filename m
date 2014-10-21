Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaJUJfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:35:05 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39006 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaJUJfC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:35:02 -0400
Message-ID: <544628BF.8010809@arm.com>
Date: Tue, 21 Oct 2014 10:34:55 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Bjorn Andersson <bjorn@kryo.se>
CC: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: Re: [PATCH] genirq: Introduce irq_read_line()
References: <1408479811-26088-1-git-send-email-bjorn.andersson@sonymobile.com> <CAJAp7OgGPZZuCgC8iUiW2jrEVubK=KCATxd6eazdT1x1sSrffg@mail.gmail.com> <alpine.DEB.2.11.1410211120430.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410211120430.5308@nanos>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 21 Oct 2014 09:34:56.0118 (UTC) FILETIME=[46456160:01CFED12]
X-MC-Unique: 114102110350002701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 21/10/14 10:22, Thomas Gleixner wrote:
> On Thu, 4 Sep 2014, Bjorn Andersson wrote:
> 
>> On Tue, Aug 19, 2014 at 1:23 PM, Bjorn Andersson
>> <bjorn.andersson@sonymobile.com> wrote:
>>> Introduce the irq_read_line() function to allow device drivers to read
>>> the current logical state of an input when the hardware only exposes
>>> this through status bits in the interrupt controller.
>>>
>>> The new function is backed by a new callback function in the irq_chip -
>>> irq_read_line() - that can be implemented by irq_chips that owns such
>>> status bits.
>>>
>>> Based on rfc patch from April 2011 by Abhijeet.
>>>
>>> Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
>>> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>>
>> ping?
> 
> Sorry, slipped through the cracks. I was talking about this to Marc
> last week and he needs it for yet another reason. He had some thoughts
> about the state representation, so I wait for him to comment.

Thanks for putting me in the loop. For the record, here's the RFC I
posted back in June:

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/266328.html

and the patch implementing a similar concept:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/266331.html

Basic idea is that you can read (and possibly write back) various
low-level attributes (pending, masked, active) that an interrupt
controller may implement. Given your use case, we should loose the
checks on the interrupt being forwarded, as this makes little sense
outside of virtualization.

I'm planning to respin the series this week, as I have a number of
changes (there is hardly any need for the various states to be reported
atomically, for example), and a number of bugs have been found.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

