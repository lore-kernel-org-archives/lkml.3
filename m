Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbbAPLHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:07:45 -0500
Received: from down.free-electrons.com ([37.187.137.238]:33385 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751249AbbAPLHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:07:44 -0500
Date: Fri, 16 Jan 2015 12:07:42 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] clocksource: don't suspend/resume when unused
Message-ID: <20150116110742.GJ3843@piout.net>
References: <1421399874-29119-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421399874-29119-3-git-send-email-alexandre.belloni@free-electrons.com>
 <alpine.DEB.2.11.1501161122320.5526@nanos>
 <20150116103530.GB3843@piout.net>
 <54B8EA54.5020002@linaro.org>
 <20150116104804.GE3843@piout.net>
 <54B8EF15.4000602@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B8EF15.4000602@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/01/2015 at 11:59:33 +0100, Daniel Lezcano wrote :
> On 01/16/2015 11:48 AM, Alexandre Belloni wrote:
> >Hi,
> >
> >On 16/01/2015 at 11:39:16 +0100, Daniel Lezcano wrote :
> >>>Isn't that already the case?
> >>>Right now, if you call clocksource_suspend, it doesn't matter whether
> >>>the clocksource has an enable or not, it will be suspended. Maybe I'm
> >>>mistaken but my patch doesn't seem to change that behaviour.
> >>
> >>Actually, if there is no enable/disable callback, then CLOCK_SOURCE_USED
> >>will be never set, hence the condition will always fail and the suspend
> >>callback won't be called.
> >>
> >
> >It is set in clocksource_enable/disable, even if there is no
> >enable/disable callback.
> 
> Ah, right. But shouldn't we set the flag only if the callback is present and
> succeed as Boris mentioned it ?
> 

What Boris was suggesting was that if the enable exist, set it only if
it succeed. Which gives something like that:

int clocksource_enable(struct clocksource *cs)
{
	int ret = 0;

	if (cs->enable)
		ret = cs->enable(cs);

	if (!ret)
		cs->flags |= CLOCK_SOURCE_USED;

	return 0;
}

I will use that version in v2.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
