Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab3HAANI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:13:08 -0400
Received: from muin.pair.com ([209.68.1.55]:64929 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab3HAANG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:13:06 -0400
Message-ID: <51F9A80E.5010307@tabi.org>
Date: Wed, 31 Jul 2013 19:13:02 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
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
References: <1375187900-17582-1-git-send-email-B44344@freescale.com> <1375187900-17582-3-git-send-email-B44344@freescale.com> <20130731071630.GI8868@codeaurora.org> <CAOZdJXVvNBR-qf7LXNOHZVstH_Rebxwn-wAkSaBS53Wn55mYCw@mail.gmail.com> <51F9A5FE.8030608@codeaurora.org>
In-Reply-To: <51F9A5FE.8030608@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 07:04 PM, Stephen Boyd wrote:
> If it yields why are we using udelay? Why not usleep_range()? It would
> be useful to have a variant that worked in interrupt context and it
> looked like that was almost possible.

I've never heard of usleep_range() before, so I don't know if it
applies.  Apparently, udelay() includes its own call to cpu_relax().  Is
it possible that cpu_relax() is a "lightweight" yield, compared to sleeping?

FYI, you might want to look at the code reviews for spin_event_timeout()
on the linuxppc-dev mailing list, back in March 2009.

-- 
-- 
Timur Tabi
