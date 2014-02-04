Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936056AbaBDWg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:36:58 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49807 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933521AbaBDWgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 17:36:53 -0500
Message-ID: <52F16B4F.2010801@ti.com>
Date: Wed, 5 Feb 2014 00:35:59 +0200
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <rob@landley.net>, <linux@arm.linux.org.uk>, <galak@codeaurora.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <daniel.lezcano@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <grygorii.strashko@ti.com>
Subject: Re: [PATCH v4 1/3] clocksource: timer-keystone: introduce clocksource
 driver for Keystone
References: <1391513453-21140-1-git-send-email-ivan.khoronzhuk@ti.com> <1391513453-21140-2-git-send-email-ivan.khoronzhuk@ti.com> <alpine.DEB.2.02.1402041715220.24986@ionos.tec.linutronix.de> <52F11B5C.40407@ti.com> <alpine.DEB.2.02.1402042113270.24986@ionos.tec.linutronix.de> <52F1668B.9040507@ti.com>
In-Reply-To: <52F1668B.9040507@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes. I'll send with __iowmb() instead of wmb().

On 02/05/2014 12:15 AM, Santosh Shilimkar wrote:
> On Tuesday 04 February 2014 03:17 PM, Thomas Gleixner wrote:
>> On Tue, 4 Feb 2014, Ivan Khoronzhuk wrote:
>>
>> Please do not top post.
>>
>>> It was so in v1. But it was decided to use explicit memory barriers,
>>> because we're always sure the memory barriers are there and that
>>> they're properly documented. Also in this case I don't need to add
>>> keystone readl/writel relaxed function variants and to use mixed calls of
>>> writel/writel_relaxed functions.
>>>
>>> See:
>>> http://www.spinics.net/lists/arm-kernel/msg294941.html
>> Fair enough, but we want a proper explanation for explicit barriers in
>> the code and not in some random discussion of patch version X on some
>> random mailing list.
>>
>> Aside of that it should be iowmb(), but I might miss something ...
>>
> Agree. __iowmb() seems to be more appropriate.
>
> Regards,
> Santosh
>

-- 
Regards,
Ivan Khoronzhuk

