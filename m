Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab3CKQ3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:29:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60649 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab3CKQ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:29:30 -0400
Date: Mon, 11 Mar 2013 16:22:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: john.stultz@linaro.org, tglx@linutronix.de, viresh.kumar@linaro.org,
        jacob.jun.pan@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        santosh.shilimkar@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, rickard.andersson@stericsson.com,
        vincent.guittot@linaro.org, linus.walleij@stericsson.com
Subject: Re: [PATCH 4/4][V2] ARM: timer-sp: Set dynamic irq affinity
Message-ID: <20130311162255.GI4977@n2100.arm.linux.org.uk>
References: <1362219013-18173-1-git-send-email-daniel.lezcano@linaro.org> <1362219013-18173-5-git-send-email-daniel.lezcano@linaro.org> <513A03B7.7000004@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513A03B7.7000004@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 04:28:55PM +0100, Daniel Lezcano wrote:
> On 03/02/2013 11:10 AM, Daniel Lezcano wrote:
> > From: Viresh Kumar <viresh.kumar@linaro.org>
> > 
> > When a cpu goes to a deep idle state where its local timer is shutdown, it
> > notifies the time frame work to use the broadcast timer instead.
> > 
> > Unfortunately, the broadcast device could wake up any CPU, including an idle one
> > which is not concerned by the wake up at all.
> > 
> > This implies, in the worst case, an idle CPU will wake up to send an IPI to
> > another idle cpu.
> > 
> > This patch fixes this for ARM platforms using timer-sp, by setting
> > CLOCK_EVT_FEAT_DYNIRQ feature.
> > 
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> > ---
> 
> Hi Russell,
> 
> I asked Thomas if he could take this patch in its tree but it falls
> under your umbrella. Thomas agreed to take it if you ack this patch.
> 
> Is this patch acceptable for you ?

It's simple enough.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
