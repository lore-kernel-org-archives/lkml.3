Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab3HABgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 21:36:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52197 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3HABgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 21:36:16 -0400
Message-ID: <51F9BB8D.6060907@codeaurora.org>
Date: Wed, 31 Jul 2013 18:36:13 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Timur Tabi <timur@tabi.org>, Andrew Morton <akpm@linux-foundation.org>
CC: Arpit Goel <B44344@freescale.com>, linux@arm.linux.org.uk,
        takata@linux-m32r.org, philb@gnu.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, linux390@de.ibm.com,
        David Miller <davem@davemloft.net>,
        Rob Herring <rob.herring@calxeda.com>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Warren <swarren@nvidia.com>, john.stultz@linaro.org,
        jesper.nilsson@axis.com, gregkh@linuxfoundation.org, sam@ravnborg.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org, linux-m68k@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        mattw@codeaurora.org
Subject: Re: [PATCH 2/2] Convert PowerPC macro spin_event_timeout() to architecture
 independent macro
References: <1375187900-17582-1-git-send-email-B44344@freescale.com> <1375187900-17582-3-git-send-email-B44344@freescale.com> <20130731071630.GI8868@codeaurora.org> <CAOZdJXVvNBR-qf7LXNOHZVstH_Rebxwn-wAkSaBS53Wn55mYCw@mail.gmail.com> <51F9A5FE.8030608@codeaurora.org> <51F9A80E.5010307@tabi.org> <51F9A8F1.9020704@codeaurora.org> <51F9A9CD.1040804@tabi.org>
In-Reply-To: <51F9A9CD.1040804@tabi.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/13 17:20, Timur Tabi wrote:
> On 07/31/2013 07:16 PM, Stephen Boyd wrote:
>> cpu_relax() is usually just a compiler barrier or an instruction hint to
>> the cpu that it should cool down because we're spinning in a tight loop.
>> It certainly shouldn't be calling into the  scheduler.
> Ah yes, I remember now.  So it does seem that if we can fix the problem
> of non-incrementing 'jiffies', then this macro can be used in interrupts.

That's encouraging. It looks like you introduced it to use in interrupt
context but then it got shot down[1]? I lost track in all the versions.

>
> Of course, that assumes that spinning in interrupt context is a good
> idea to begin with.  Maybe we shouldn't be encouraging it?

I read through the v5 discussion and it seems I'm about to walk through
some tall grass on the way to Cerulean City.

Andrew Morton, I choose you! Use your mind-power move to convince
everyone that having a macro for spinning on a register in interrupt
context is a good thing. At least it will be more obvious.

>
>>>> FYI, you might want to look at the code reviews for spin_event_timeout()
>>>> on the linuxppc-dev mailing list, back in March 2009.
>>>>
>> Sure. Any pointers? Otherwise I'll go digging around the archives.
> https://lists.ozlabs.org/pipermail/linuxppc-dev/2009-March/thread.html
>

[1] https://lists.ozlabs.org/pipermail/linuxppc-dev/2009-May/072521.html

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

