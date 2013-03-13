Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab3CMJdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:33:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38442 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab3CMJdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:33:52 -0400
Message-ID: <51404854.8030303@ti.com>
Date: Wed, 13 Mar 2013 15:05:16 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Arjan van de Veen <arjan@infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Liu <liu.h.jason@gmail.com>
Subject: Re: [patch 0/7] tick: Optimize broadcast handling and prevent expiry
 ping pong
References: <20130306111351.883117670@linutronix.de>
In-Reply-To: <20130306111351.883117670@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Wednesday 06 March 2013 04:48 PM, Thomas Gleixner wrote:
> Jason decoded a problem related to the broadcast timer mode. The
> reprogramming of the cpu local timer causes a huge number of
> retries. Also there is a situation where the CPU which does not handle
> the broadcast timer interrupt exits and reenters broadcast mode before
> the broadcast interrupt got handled by another CPU. This can lead to
> an interesting ping pong of the broadcast and the cpu local timer
> code.
> 
> This series addresses these problems. The first two patches convert
> the broadcast code to proper cpumask_var_t instead of adding more
> bitmaps later.
> 
> The rest of the series is adopted from the quick patches which I
> posted earlier while discussing the issue with Jason et. al.
> 
> Please give it a proper testing on your affected hardware.
> 
I have tested this revised patches on OMAP4 and OMAP5 platforms
with CPUidle enabled against 3.9-rc2. As expected they seems to
work without any issue and also fixes the reported retry issue.

Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

