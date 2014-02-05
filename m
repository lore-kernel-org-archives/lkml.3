Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbaBEANr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:13:47 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51124 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932164AbaBEANp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:13:45 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH v7 2/3] trivial: PM / Hibernate: clean up checkpatch in hibernate.c
Date: Wed, 05 Feb 2014 01:28:13 +0100
Message-ID: <2342041.V7doIJk0XQ@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <20140205000642.6803.8182@capellas-linux>
References: <1391546631-7715-1-git-send-email-sebastian.capella@linaro.org> <1593382.PUxxx0NMeh@vostro.rjw.lan> <20140205000642.6803.8182@capellas-linux>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 04, 2014 04:06:42 PM Sebastian Capella wrote:
> Quoting Rafael J. Wysocki (2014-02-04 16:03:29)
> > On Tuesday, February 04, 2014 03:22:22 PM Sebastian Capella wrote:
> > > Quoting Sebastian Capella (2014-02-04 14:37:33)
> > > > Quoting Rafael J. Wysocki (2014-02-04 13:36:29)
> > > > > >  static int __init resumedelay_setup(char *str)
> > > > > >  {
> > > > > > -     resume_delay = simple_strtoul(str, NULL, 0);
> > > > > > +     int ret = kstrtoint(str, 0, &resume_delay);
> > > > > > +     /* mask must_check warn; on failure, leaves resume_delay unchanged */
> > > > > > +     (void)ret;
> > > 
> > > One unintended consequence of this change is that it'll now accept a
> > > negative integer parameter.
> > 
> > Well, what about using kstrtouint(), then?
> I was thinking of doing something like:
> 
> 	int delay, res;
> 	res = kstrtoint(str, 0, &delay);
> 	if (!res && delay >= 0)
> 		resume_delay = delay;
> 	return 1;

It uses simple_strtoul() for a reason.  You can change the type of resume_delay
to match, but the basic question is:

Why exactly do you want to change that thing?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
