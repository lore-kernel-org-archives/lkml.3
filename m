Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935087AbaBDWQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:16:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60350 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933980AbaBDWQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 17:16:32 -0500
Message-ID: <52F1668B.9040507@ti.com>
Date: Tue, 4 Feb 2014 17:15:39 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <daniel.lezcano@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <grygorii.strashko@ti.com>
Subject: Re: [PATCH v4 1/3] clocksource: timer-keystone: introduce clocksource
 driver for Keystone
References: <1391513453-21140-1-git-send-email-ivan.khoronzhuk@ti.com> <1391513453-21140-2-git-send-email-ivan.khoronzhuk@ti.com> <alpine.DEB.2.02.1402041715220.24986@ionos.tec.linutronix.de> <52F11B5C.40407@ti.com> <alpine.DEB.2.02.1402042113270.24986@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402042113270.24986@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 February 2014 03:17 PM, Thomas Gleixner wrote:
> On Tue, 4 Feb 2014, Ivan Khoronzhuk wrote:
> 
> Please do not top post.
> 
>> It was so in v1. But it was decided to use explicit memory barriers,
>> because we're always sure the memory barriers are there and that
>> they're properly documented. Also in this case I don't need to add
>> keystone readl/writel relaxed function variants and to use mixed calls of
>> writel/writel_relaxed functions.
>>
>> See:
>> http://www.spinics.net/lists/arm-kernel/msg294941.html
> 
> Fair enough, but we want a proper explanation for explicit barriers in
> the code and not in some random discussion of patch version X on some
> random mailing list.
> 
> Aside of that it should be iowmb(), but I might miss something ...
> 
Agree. __iowmb() seems to be more appropriate.

Regards,
Santosh

