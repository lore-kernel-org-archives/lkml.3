Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab3H3KCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:02:35 -0400
Received: from smarthost01a.mail.zen.net.uk ([212.23.1.1]:42566 "EHLO
	smarthost01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755725Ab3H3KCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:02:34 -0400
X-Greylist: delayed 71661 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Aug 2013 06:02:34 EDT
Message-ID: <1377856951.3655.34.camel@linaro1.home>
Subject: Re: [PATCH RFC v2 14/16] ARM: vexpress: remove custom .init_time
 hook
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Pawel Moll <Pawel.Moll@arm.com>
Date: Fri, 30 Aug 2013 11:02:31 +0100
In-Reply-To: <521F901B.3090305@gmail.com>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
	 <1377638890-371-15-git-send-email-sebastian.hesselbarth@gmail.com>
	 <201308291535.53005.arnd@arndb.de> <521F901B.3090305@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-29 at 20:16 +0200, Sebastian Hesselbarth wrote:
> On 08/29/13 15:35, Arnd Bergmann wrote:
> > On Tuesday 27 August 2013, Sebastian Hesselbarth wrote:
> >> @@ -422,16 +419,8 @@ void __init v2m_dt_init_early(void)
> >>                          pr_warning("vexpress: DT HBI (%x) is not matching "
> >>                                          "hardware (%x)!\n", dt_hbi, hbi);
> >>          }
> >> -}
> >> -
> >> -static void __init v2m_dt_timer_init(void)
> >> -{
> >> -       of_clk_init(NULL);
> >>
> >> -       clocksource_of_init();
> >> -
> >> -       versatile_sched_clock_init(vexpress_get_24mhz_clock_base(),
> >> -                               24000000);
> >> +       versatile_sched_clock_init(vexpress_get_24mhz_clock_base(), 24000000);
> >>   }
> >
> > You are moving versatile_sched_clock_init() ahead of clocksource_of_init(), which I suspect
> > won't work. Have you checked this?
> 
> "Checked" as in "Tested", no I haven't.
> 
> But non-DT v2m has it in v2m_init_early also, while v2m_sp804_init()
> is called in v2m_timer_init().
> 
> That matches the above approach taken for DT v2m where
> versatile_sched_clock_init() is now called from v2m_dt_init_early()
> and clocksource_of_init() called from arch-wide .timer_init.
> 
> get_maintainer.pl did not spit out any additional maintainer except
> Russell of course. You know someone who can test the above?

After adding of_clk_init(NULL) to time_init() things boot OK for me with
this patch. However, do we know that sched_clock is never going to get
read before time_init() has actually started the clock it reads? Are we
making things more fragile?

(My testing was on a 3.11-rc6 based Linaro kernel on TC2 because that's
what I had to hand. So it's not a vanilla mainline kernel and I have
other vexpress changes in my tree.)

-- 
Tixy

