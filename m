Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab3GaX4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 19:56:06 -0400
Received: from muin.pair.com ([209.68.1.55]:62037 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab3GaX4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 19:56:02 -0400
X-Greylist: delayed 661 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jul 2013 19:56:02 EDT
MIME-Version: 1.0
In-Reply-To: <20130731071630.GI8868@codeaurora.org>
References: <1375187900-17582-1-git-send-email-B44344@freescale.com>
	<1375187900-17582-3-git-send-email-B44344@freescale.com>
	<20130731071630.GI8868@codeaurora.org>
Date: Wed, 31 Jul 2013 18:44:58 -0500
Message-ID: <CAOZdJXVvNBR-qf7LXNOHZVstH_Rebxwn-wAkSaBS53Wn55mYCw@mail.gmail.com>
Subject: Re: [PATCH 2/2] Convert PowerPC macro spin_event_timeout() to
 architecture independent macro
From: Timur Tabi <timur@tabi.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Arpit Goel <B44344@freescale.com>, linux@arm.linux.org.uk,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 2:16 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>
> What do you do here if jiffies aren't incrementing (i.e
> interrupts are disabled). The time_before() check won't work
> there and it would be nice if we were able to use this in such
> situations. I think powerpc gets around this by reading the
> hardware timer directly?

I believe that jiffies is always a global variable.  It should behave
the same on PowerPC as on other architectures.

The answer to your question is that you should not use
spin_event_timeout() in interrupt context, because it yields.

(FYI, I'm the author of spin_event_timeout(), so please CC: me on all
changes to it)
