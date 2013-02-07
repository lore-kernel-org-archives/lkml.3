Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab3BGG1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:27:53 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:46632 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab3BGG1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:27:50 -0500
Date: Thu, 7 Feb 2013 10:27:44 +0400
From: Artem Savkov <artem.savkov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [BUG] cpufreq: sleeping function called from invalid context at
 kernel/workqueue.c:2811
Message-ID: <20130207062743.GA4388@thinkpad.lan>
References: <20130206202513.GA5626@thinkpad.lan>
 <1543919.ZBNJa64WB5@vostro.rjw.lan>
 <1873989.qC1mdEKIl9@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1873989.qC1mdEKIl9@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 01:41:57AM +0100, Rafael J. Wysocki wrote:
> On Wednesday, February 06, 2013 10:11:25 PM Rafael J. Wysocki wrote:
> > On Thursday, February 07, 2013 12:25:13 AM Artem Savkov wrote:
> > > I get the following BUG on suspend using systemd-sleep(this doesn't
> > > happen with pm-suspend). This seems to be introduced by some of the
> > > Viresh's patches.
> > 
> > Which branch from which day?

The log is from linux-next-20130205, still reproducible on -20130206

> OK, I've reproduced it and the appended patch fixes it for me.  Can you please
> try it and report back?

I've tried the patch and the bug is still reproducible. I might be wrong
but it seems that the bug happens on first __cpufreq_remove_dev
call(CPU1) on __cpufreq_governor(data, CPUFREQ_GOV_STOP) call (line
~1050) but changes in your patch are all below that call.

-- 
Kind regards,
Artem
