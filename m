Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3AUXXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 18:23:32 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:23774 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752351Ab3AUXXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 18:23:30 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19UP07Sjwpl9PJjExxXiEFy
Date: Mon, 21 Jan 2013 15:23:22 -0800
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Matt Sealey <matt@genesi-usa.com>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Ben Dooks <ben@simtec.co.uk>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
Message-ID: <20130121232322.GK15361@atomide.com>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com>
 <201301212041.17951.arnd@arndb.de>
 <20130121210341.GW23505@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121210341.GW23505@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [130121 13:07]:
> 
> As for Samsung and the rest I can't comment.  The original reason OMAP
> used this though was because the 32768Hz counter can't produce 100Hz
> without a .1% error - too much error under pre-clocksource
> implementations for timekeeping.  Whether that's changed with the
> clocksource/clockevent support needs to be checked.

Yes that's why HZ was originally set to 128. That value (or some multiple)
still makes sense when the 32 KiHZ clock source is being used. Of course
we should rely on the local timer when running for the SoCs that have
them.

Regards,

Tony
