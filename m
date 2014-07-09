Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaGIHY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:24:59 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:45110 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbaGIHY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:24:57 -0400
Message-ID: <1404890669.16296.5.camel@iivanov-dev>
Subject: Re: [PATCH 1/3] mfd: pm8921: Expose pm8xxx_read_irq_status
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 09 Jul 2014 10:24:29 +0300
In-Reply-To: <CAJAp7Ogy3=tZvMAUojbf5sy8EMmQOT+imA3=TRVcGXXA_y7CtA@mail.gmail.com>
References: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com>
	 <1404782785-1824-2-git-send-email-bjorn.andersson@sonymobile.com>
	 <53BC7CBD.2060901@codeaurora.org>
	 <CAJAp7Ogy3=tZvMAUojbf5sy8EMmQOT+imA3=TRVcGXXA_y7CtA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-08 at 16:43 -0700, Bjorn Andersson wrote:
> On Tue, Jul 8, 2014 at 4:20 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > On 07/07/14 18:26, Bjorn Andersson wrote:

<snip>

> [...]
> > Sad, the header file came back. I guess there isn't a way to put the
> > pinctrl driver inside the core mfd driver? Then we wouldn't need to
> > expose an "irq read line" function.
> >
> 
> I continued my search and this needs to be accessed by gpio, mpp, adc,
> charger, bms and usb(?). So we have to expose it in some form.
> 
> > Actually Abhijeet proposed such an API in 2011 but it didn't go
> > anywhere[1]. If we had that API we should be able to call
> > read_irq_line() from the pinctrl driver whenever we want to get the
> > state of the gpio, plus the API is generic. We're going to need that API
> > anyway for things like USB insertion detection so it might make sense to
> > add it sooner rather than later.
> >
> > [1]
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2011-April/048319.html
> 
> From what I can see of this thread it was exposed as a way for drivers
> to be able to query if an interrupt handler was called on raising or
> falling edge. And based on the locking limitations of the
> implementation we couldn't have used it anyways.
> 
> Our use case is different in that we're at any point in time
> interested in reading out the status of the irq line, as the only way
> of getting that status.

How about using extcon framework? 

Regards,
Ivan

