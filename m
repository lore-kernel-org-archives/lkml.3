Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab3FTGlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 02:41:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56672 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab3FTGlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 02:41:17 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-d0-51c2a40b9e5b
Date: Thu, 20 Jun 2013 08:41:08 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH v3 1/3] cpufreq: Add boost frequency support in core
Message-id: <20130620084108.39b188aa@amdc308.digital.local>
In-reply-to: <CAKohponTEb_XQnGTpDVC78jknCuwumnckCKZk6cObq45RmWpFA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <20130617155156.4c729b5a@amdc308.digital.local>
 <CAKohpo=_=u35wTb-ZUXrR2hNno+ryAqq4gSC3EiJr=-bmgb9JQ@mail.gmail.com>
 <3258927.Qds4G9CTyG@vostro.rjw.lan>
 <20130618154456.56d99e18@amdc308.digital.local>
 <20130619091612.60e4d69d@amdc308.digital.local>
 <CAKohponTEb_XQnGTpDVC78jknCuwumnckCKZk6cObq45RmWpFA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42I5/e+xgC73kkOBBvNeWls0XA2x+PN2OavF
	06Yf7BbzPstadJ59wmzRu+Aqm8WbR9wWl3fNYbP43HuE0eJ24wo2i/6FvUwWHUe+MVts/Orh
	wOtx59oeNo91094ye/RtWcXo8WhxC6PH501yAaxRXDYpqTmZZalF+nYJXBkvV89kLDjDV7Ho
	8ybmBsbt3F2MnBwSAiYSj1beYoGwxSQu3FvPBmILCSxilPh0sbSLkQvIbmeSuDnrAStIgkVA
	VWLT5CmMIDabgJ7E57tPmboYOThEBLQkXt5MBalnFpjJIvH/xyF2kBphAQ+Jc0emgdXzClhL
	PGtbzAhSzykQLLHyphrE/H5miSurb4DN5xeQlGj/94MZ4iA7iXOfNrBD9ApK/Jh8D+xQZqBd
	m7c1sULY8hKb17xlnsAoOAtJ2SwkZbOQlC1gZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJ
	ERwxz6R2MK5ssDjEKMDBqMTDq3H5YKAQa2JZcWXuIUYJDmYlEd7UOYcChXhTEiurUovy44tK
	c1KLDzFKc7AoifMeaLUOFBJITyxJzU5NLUgtgskycXBKNTByv9GaWPP7blvXdYU3Ebq5vFkX
	Ph4JiOd9VTdJrLDh68oCiZTwHTvStNd+2jhN0lUrbN7VvzWcjd1x32wlc+PlfbXUtmutt3yu
	ebbigjzjA4X63TpPHx1/ETNHjOl93bJNBxsjGT8wlB2b0f7TyeXO6YdMKfsyFQ5VKutv//Yp
	5sihTo+JL3uVWIozEg21mIuKEwE9veRflAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013 10:41:41 +0530, Viresh Kumar wrote:
> On 19 June 2013 12:46, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > I would like to clarify the above issue.
> >
> > When I've discussed with Viresh previous version of this patch, we
> > have agreed, that "boost" sysfs attribute [*]:
> > /sys/devices/system/cpu/cpufreq/boost
> >
> > would be only visible when boost_supported flag is set at cpufreq
> > driver.
> 
> Yes.
> 
> > When acpi-cpufreq driver doesn't support boost, the attribute [*]
> > won't be exported at all. This contradicts the documentation and
> > legacy acpi-cpufreq behaviour.
> 
> No they aren't contradictory. What the documentation meant was:
> acpi-cpufreq driver is used by lots of different x86 processors. Now
> all processors might not support boost inside x86 also. And for them
> we will keep 'boost' file readonly. This is done by following
> statement

Thanks for explanation.

> 
> 	if (boot_cpu_has(X86_FEATURE_CPB) ||
> boot_cpu_has(X86_FEATURE_IDA)) { boost_supported = true;
>                 ....
> 	} else
> 		global_boost.attr.mode = 0444;

Grrr.... So simple and obvious solution [1]. 

> 
> Documentation file doesn't talk about any other cpufreq driver, for
> them there is no concept like boost.
> 
> You need to preserve this functionality.

Yes the idea [1], solves problem with legacy API.

> 
> > Since I'm affraid to break API (with all its consequences :-) ), I
> > would like to be sure that this is OK, and thereof I'm allowed to
> > rewrite documentation accordingly.
> >
> > I simply need explicit permission from both maintainers :-).
> 
> For me its okay to rewrite documentation.

I will extent documentation about the SW managed boost.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
