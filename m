Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaKRGWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 01:22:12 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:46468 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaKRGWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 01:22:10 -0500
Date: Mon, 17 Nov 2014 23:22:05 -0700
From: Lina Iyer <lina.iyer@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: khilman@linaro.org, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        daniel.lezcano@linaro.org
Subject: Re: [PATCH v3 3/4] irq: Allow multiple clients to register for irq
 affinity notification
Message-ID: <20141118062205.GA770@linaro.org>
References: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org>
 <1409170479-29955-4-git-send-email-lina.iyer@linaro.org>
 <alpine.DEB.2.10.1408272239190.3323@nanos>
 <20140902184305.GB91995@ilina-mac.local>
 <alpine.DEB.2.10.1409022109050.3333@nanos>
 <20140925155027.GG1004@ilina-mac.local>
 <alpine.DEB.2.11.1410081623210.4292@nanos>
 <20141010151106.GC2128@ilina-mac.qualcomm.com>
 <alpine.DEB.2.11.1410170926220.2806@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410170926220.2806@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Fri, Oct 17 2014 at 01:29 -0600, Thomas Gleixner wrote:
>On Fri, 10 Oct 2014, Lina Iyer wrote:
>> On Wed, Oct 08 2014 at 09:03 -0600, Thomas Gleixner wrote:
>> > On Thu, 25 Sep 2014, Lina Iyer wrote:
>> > > > How would a general "keep track of the targets of all interrupts in
>> > > > the system" mechanism make use of this?
>> > > Sorry, I do not understand your question.
>> > > PM QoS is only interested in the IRQs specified in the QoS request. If
>> > > there are no requests that need to be associated with an IRQ, then PM
>> > > QoS will not register for an affinity change notification.
>> >
>> > Right, and I really hate the whole per irq notifier. It's a rats nest
>> > of life time issues and other problems.
>> >
>> > It also does not tell you whether an irq is disabled, reenabled or
>> > removed, which will change the qos constraints as well unless you
>> > plaster all drivers with updates to qos for those cases.
>> >
>> > So what about adding a qos field to irq_data itself, have a function
>> > to update it and let the irq core keep track of the per cpu irq
>> > relevant qos constraints and provide an evaluation function or a
>> > notifier for the PM/idle code?
>>
>> If that isnt intrusive in the IRQ core, then we can make it work for PM
>> QoS. The issue that I am concerned is that, it might result in back and
>> forth between IRQ and PM QoS frameworks. If that doesnt happen, then we
>> are good with this approach.
>
>I can't tell that upfront, but I think it's worth to explore it.
>
I was able to review the options and I attempted a few methods, but
off-loading the QoS onto the IRQ framework, made it quite complex to
manage it. QoS values for each of the four constraints and the
constraints could be one of 3 types - min, max or sum, makes it a whole
lot of mess handling it in IRQ code.

I was able to get QoS to be notified of IRQ affinity changes without
using notifiers, but, I still am yet to find a way to modify QoS
requests on enable/disable of IRQ.

I will send the RFC of the new patchset, would be interested in taking a
look and let me know what you think.

Thanks,
Lina
