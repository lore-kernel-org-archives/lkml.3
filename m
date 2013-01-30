Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab3A3Lmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:42:47 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56246 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3A3Lmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:42:43 -0500
Date: Wed, 30 Jan 2013 12:42:33 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/5] cpufreq: handle SW coordinated CPUs
Message-ID: <20130130114233.GD32315@balto.lan>
References: <1356620142-8680-1-git-send-email-fabio.baltieri@linaro.org>
 <1356620142-8680-2-git-send-email-fabio.baltieri@linaro.org>
 <CAOh2x==SG32h-BbrnLN8gwiYNz7bS-REVcmXN67fdYPqFVmCiA@mail.gmail.com>
 <20130130091453.GA32315@balto.lan>
 <20130130110429.GC32315@balto.lan>
 <CAKohpo=_oim1FN+Cu+kMKLRpH1c+6-wuQACEdpVS8yHoANHhcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=_oim1FN+Cu+kMKLRpH1c+6-wuQACEdpVS8yHoANHhcA@mail.gmail.com>
X-Operating-System: Linux balto 3.8.0-rc3-00668-g55706d3 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 04:47:58PM +0530, Viresh Kumar wrote:
> On 30 January 2013 16:34, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> > Small sidenote, actually what I'm going to drop here i *cdbs, as I need
> > cpu for schedule_delayed_work_on and can't use cdbs->cpu for that as
> > it's the master's one.
> 
> I can't find code which would do j_cdbs->cpu = j and so j_cdbs->cpu is
> un-initialized. So, if that's true, you can initialize that and drop
> cpu param too.

Right, it looks like cdbs->cpu is not really needed anymore.  Anyway I'm
quite happy with how it came out passing cpu number, code is a bit more
compact, so I'm sending that version and than we can discuss if recycle
cdbs->cpu or just drop it.

Fabio

-- 
Fabio Baltieri
