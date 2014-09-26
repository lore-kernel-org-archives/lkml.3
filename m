Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaIZJkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:40:21 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43724 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753438AbaIZJkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:40:19 -0400
Date: Fri, 26 Sep 2014 10:40:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kevin Hilman <khilman@kernel.org>, ulf.hansson@linaro.org,
        linux-pm@vger.kernel.org, daniel.lezcano@linaro.org, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, Lina Iyer <lina.iyer@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 3/4] irq: Allow multiple clients to register for irq
	affinity notification
Message-ID: <20140926094003.GL5182@n2100.arm.linux.org.uk>
References: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org> <1409170479-29955-4-git-send-email-lina.iyer@linaro.org> <alpine.DEB.2.10.1408272239190.3323@nanos> <20140902184305.GB91995@ilina-mac.local> <alpine.DEB.2.10.1409022109050.3333@nanos> <7htx3vbfqr.fsf@deeprootsystems.com> <alpine.DEB.2.11.1409261129220.4567@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409261129220.4567@nanos>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 11:29:56AM +0200, Thomas Gleixner wrote:
> On Thu, 25 Sep 2014, Kevin Hilman wrote:
> > Maybe I'm missing something, or maybe we're just lucky and nobody uses
> > them together, but irq_set_affinity_notifier() only allows a single
> > notifier to be registered at any given time.  So if you had a system
> 
> A single notifier per irq .....

So what about two drivers wanting to use this notifier, but sharing an
interrupt?

It sounds to me like this notifier was misdesigned from the very start,
and it should always have supported multiple notifiers.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
