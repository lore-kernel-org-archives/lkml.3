Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbbAPRpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 12:45:20 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36266 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751683AbbAPRpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 12:45:19 -0500
Date: Fri, 16 Jan 2015 18:45:16 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] clocksource: don't suspend/resume when unused
Message-ID: <20150116184516.735cd2de@bbrezillon>
In-Reply-To: <1421427439-11699-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421427439-11699-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015 17:57:17 +0100
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> This is a quite naive implementation to track whether a clocksource is enabled.
> I chose not to add a member in struct clocksource and use a flag instead.
> 
> I found that timekeeping.c is the only consumer for clocksource and I converted
> it to use clocksource_enable and clocksource_disable.

To the whole series:

Reviewed-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> 
> Changes in v2:
>  - removed the check on enable in timekeeping.c to ensure all clocksources are
>    going through clocksource_enable
>  - rework clocksource_enable to set CLOCK_SOURCE_USED when enable is successful
>    if present
> 
> Alexandre Belloni (2):
>   clocksource: track usage
>   clocksource: don't suspend/resume when unused
> 
>  include/linux/clocksource.h |  4 ++++
>  kernel/time/clocksource.c   | 34 ++++++++++++++++++++++++++++++++--
>  kernel/time/timekeeping.c   |  8 +++-----
>  3 files changed, 39 insertions(+), 7 deletions(-)
> 



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
