Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3H3NMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:12:16 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46806 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3H3NMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:12:15 -0400
Message-ID: <1377868330.3342.10.camel@hornet>
Subject: Re: [PATCH RFC v2 14/16] ARM: vexpress: remove custom .init_time
 hook
From: Pawel Moll <pawel.moll@arm.com>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 30 Aug 2013 14:12:10 +0100
In-Reply-To: <1377856951.3655.34.camel@linaro1.home>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
	 <1377638890-371-15-git-send-email-sebastian.hesselbarth@gmail.com>
	 <201308291535.53005.arnd@arndb.de> <521F901B.3090305@gmail.com>
	 <1377856951.3655.34.camel@linaro1.home>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 30 Aug 2013 13:12:10.0965 (UTC) FILETIME=[89637050:01CEA582]
X-MC-Unique: 113083014121200701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-30 at 11:02 +0100, Jon Medhurst (Tixy) wrote:
> On Thu, 2013-08-29 at 20:16 +0200, Sebastian Hesselbarth wrote:
> > On 08/29/13 15:35, Arnd Bergmann wrote:
> > > On Tuesday 27 August 2013, Sebastian Hesselbarth wrote:
> > >> @@ -422,16 +419,8 @@ void __init v2m_dt_init_early(void)
> > >>                          pr_warning("vexpress: DT HBI (%x) is not matching "
> > >>                                          "hardware (%x)!\n", dt_hbi, hbi);
> > >>          }
> > >> -}
> > >> -
> > >> -static void __init v2m_dt_timer_init(void)
> > >> -{
> > >> -       of_clk_init(NULL);
> > >>
> > >> -       clocksource_of_init();
> > >> -
> > >> -       versatile_sched_clock_init(vexpress_get_24mhz_clock_base(),
> > >> -                               24000000);
> > >> +       versatile_sched_clock_init(vexpress_get_24mhz_clock_base(), 24000000);
> > >>   }
> > >
> > > You are moving versatile_sched_clock_init() ahead of clocksource_of_init(), which I suspect
> > > won't work. Have you checked this?
> > 
> > "Checked" as in "Tested", no I haven't.
> > 
> > But non-DT v2m has it in v2m_init_early also, while v2m_sp804_init()
> > is called in v2m_timer_init().
> > 
> > That matches the above approach taken for DT v2m where
> > versatile_sched_clock_init() is now called from v2m_dt_init_early()
> > and clocksource_of_init() called from arch-wide .timer_init.
> > 
> > get_maintainer.pl did not spit out any additional maintainer except
> > Russell of course. You know someone who can test the above?
> 
> After adding of_clk_init(NULL) to time_init() things boot OK for me with
> this patch. However, do we know that sched_clock is never going to get
> read before time_init() has actually started the clock it reads? Are we
> making things more fragile?

The versatile_sched_clock_init() is currently completely independent of
the clocksource infrastructure, so no harm should be done at all by
moving it.

Paweł


