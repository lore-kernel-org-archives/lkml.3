Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaJJPLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 11:11:14 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:64089 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaJJPLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 11:11:10 -0400
Date: Fri, 10 Oct 2014 09:11:06 -0600
From: Lina Iyer <lina.iyer@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: khilman@linaro.org, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        daniel.lezcano@linaro.org
Subject: Re: [PATCH v3 3/4] irq: Allow multiple clients to register for irq
 affinity notification
Message-ID: <20141010151106.GC2128@ilina-mac.qualcomm.com>
References: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org>
 <1409170479-29955-4-git-send-email-lina.iyer@linaro.org>
 <alpine.DEB.2.10.1408272239190.3323@nanos>
 <20140902184305.GB91995@ilina-mac.local>
 <alpine.DEB.2.10.1409022109050.3333@nanos>
 <20140925155027.GG1004@ilina-mac.local>
 <alpine.DEB.2.11.1410081623210.4292@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410081623210.4292@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08 2014 at 09:03 -0600, Thomas Gleixner wrote:
>On Thu, 25 Sep 2014, Lina Iyer wrote:
>> > How would a general "keep track of the targets of all interrupts in
>> > the system" mechanism make use of this?
>> Sorry, I do not understand your question.
>> PM QoS is only interested in the IRQs specified in the QoS request. If
>> there are no requests that need to be associated with an IRQ, then PM
>> QoS will not register for an affinity change notification.
>
>Right, and I really hate the whole per irq notifier. It's a rats nest
>of life time issues and other problems.
>
>It also does not tell you whether an irq is disabled, reenabled or
>removed, which will change the qos constraints as well unless you
>plaster all drivers with updates to qos for those cases.
>
>So what about adding a qos field to irq_data itself, have a function
>to update it and let the irq core keep track of the per cpu irq
>relevant qos constraints and provide an evaluation function or a
>notifier for the PM/idle code?
If that isnt intrusive in the IRQ core, then we can make it work for PM
QoS. The issue that I am concerned is that, it might result in back and
forth between IRQ and PM QoS frameworks. If that doesnt happen, then we
are good with this approach.
>
>That's going to need some serious thought as well, but it should avoid
>most of the nasty notifier and lifetime issue which the per irq
>notifiers provide.
Sure. I will look into this.
>
>Thoughts?

Thank you.

Lina
>
>
>
>
