Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab3LEXyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:54:51 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:63615 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab3LEXyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:54:50 -0500
MIME-Version: 1.0
In-Reply-To: <52A101F8.3060104@codeaurora.org>
References: <CANsc=4VRLWhaVA15HrBEeM+FJC0tS+b5KKopDb7bP8nxzR8=zA@mail.gmail.com>
	<20131204070442.GA31665@kroah.com>
	<CANsc=4UHEG5cmg9SD3r3rsuJnM9zqq2WiTQdUwrYFr_kkbsVvg@mail.gmail.com>
	<20131204170703.GA14859@kroah.com>
	<CANsc=4X7ThCvgz9bfu1ZZg9FCti5SMdbXL5tA584z-oZ_HEByg@mail.gmail.com>
	<20131204230239.GB9205@kroah.com>
	<CANsc=4UGi5sMdUW5qQDzEJx4h8NDU+-b=xOLBAZtzbV5ugz3Fg@mail.gmail.com>
	<20131205040104.GA14641@kroah.com>
	<52A0DE42.3080602@codeaurora.org>
	<20131205201659.GA14539@kroah.com>
	<52A101F8.3060104@codeaurora.org>
Date: Thu, 5 Dec 2013 18:54:49 -0500
Message-ID: <CANsc=4Vb-2br+K51NWsyQV25R3eJo_=YfpnXsh1G1ecRVDYc3w@mail.gmail.com>
Subject: Re: [PATCH 0/3] ARM Coresight: Enhance ETM tracing control
From: =?UTF-8?Q?Adrien_Verg=C3=A9?= <adrienverge@gmail.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg and Christopher,

Thank you for your feedback.

2013/12/4 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> What is it's purpose then?  At first glance, this seems to be exactly
> what 'perf' provides already.  Doesn't perf work on ARM today?

On ARM, perf is unable to trace every instruction, and certainly not
recording the number of cycles taken by every of them. Also, ETM is
not just tracing the execution flow. It can trace data, trigger
tracing on events such as address matching, data matching, context ID
change, monitor CPRT... It would be sad not to use these capabilities.

If we want perf to use ETM's full functionality, its framework clearly
needs to be extended. Future Intel processors will embed Processor
Trace [1], which seems to have similar capabilities as ETM on ARM. At
that point, it will be easier to decide what should be in the kernel
or in perf.

I the meantime, while ETM is not supported elsewhere than in sysfs, it
should at least be configurable. The current implementation is almost
not usable.

> Well, these patches were incorrect, so that's not really a valid
> question :)

Should I correct the pid size and send them again?

Thanks,

Adrien

[1]: http://software.intel.com/en-us/blogs/2013/09/18/processor-tracing
