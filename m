Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab3LEUMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:12:55 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40808 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3LEUMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:12:53 -0500
Message-ID: <52A0DE42.3080602@codeaurora.org>
Date: Thu, 05 Dec 2013 15:12:50 -0500
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: =?ISO-8859-1?Q?Adrien_Verg=E9?= <adrienverge@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: Re: [PATCH 0/3] ARM Coresight: Enhance ETM tracing control
References: <CANsc=4VRLWhaVA15HrBEeM+FJC0tS+b5KKopDb7bP8nxzR8=zA@mail.gmail.com> <20131204070442.GA31665@kroah.com> <CANsc=4UHEG5cmg9SD3r3rsuJnM9zqq2WiTQdUwrYFr_kkbsVvg@mail.gmail.com> <20131204170703.GA14859@kroah.com> <CANsc=4X7ThCvgz9bfu1ZZg9FCti5SMdbXL5tA584z-oZ_HEByg@mail.gmail.com> <20131204230239.GB9205@kroah.com> <CANsc=4UGi5sMdUW5qQDzEJx4h8NDU+-b=xOLBAZtzbV5ugz3Fg@mail.gmail.com> <20131205040104.GA14641@kroah.com>
In-Reply-To: <20131205040104.GA14641@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 12/04/2013 11:01 PM, Greg Kroah-Hartman wrote:
> On Wed, Dec 04, 2013 at 10:49:25PM -0500, Adrien Vergé wrote:
>> 2013/12/4 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>>> How much overhead does the existing tracing code have on ARM?  Is ETM
>>> still even needed?  Why not just use ETM for the core tracing code
>>> instead?

I think support for the Embedded Trace Macrocell is desirable. (Maybe it's not
necesarily *needed*, but in the same way that graphics and audio aren't
necessarily needed when using a desktop machine.) Plugging the ETM into the
core tracing code or maybe into the perf events framework would be
interesting, but do these patches make that work any more difficult?

>> Coresight ETM is not just faster than /sys/kernel/debug/tracing, it
>> provides more detailed and customisable info. For instance, you can
>> trace every load, store, instruction fetch, along with the number of
>> cycles taken, with almost zero-overhead.
> 
> Can't you already do that with the 'perf' tool the kernel provides
> without the ETM driver?

With perf one can get a count of how many instructions have been executed,
with little overhead, but not the full list of opcodes and addresses. (One can
also sample the Program Counter intermittently, which might suffice for
performance analysis, but probably doesn't for most debugging use cases.) I
think with perf one can have a handful of watchpoints looking at a very few
loads and stores, with large overhead. As I understand it, ETM can handle
arbitrarily large regions, with little overhead.

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
