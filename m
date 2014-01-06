Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbaAFURU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:17:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254AbaAFURS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:17:18 -0500
Date: Mon, 6 Jan 2014 15:17:13 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] powernow-k6: disable cache when changing frequency
In-Reply-To: <CAKohpok=exdOO-T+SFxsyqCBZ1N8ZFBMcVNn-AYsxxMw74DeJQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1401061514450.25034@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1312111751180.9686@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1312111937570.23022@file01.intranet.prod.int.rdu2.redhat.com> <CAKohpo=_0i43EDSoOAm2ROwEmu9__p+MyoObcLPoZWxUB5XmDA@mail.gmail.com>
 <alpine.LRH.2.02.1401021233280.16351@file01.intranet.prod.int.rdu2.redhat.com> <CAKohpok=exdOO-T+SFxsyqCBZ1N8ZFBMcVNn-AYsxxMw74DeJQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Jan 2014, Viresh Kumar wrote:

> On 2 January 2014 23:08, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > Flushing the cache and changing frequency takes approximatelly 500us. The
> > patch increases policy->cpuinfo.transition_latency to that value.
> 
> Its not about how fast caches get cleaned but how much time would
> be wasted to get them filled again as same data could be required again
> which is just flushed out. That would impact performance more than
> flushing caches.

I didn't see any performance degradation when I tried changing the 
frequency manually with or without the cache flush patch - the overhead of 
running cpufreq (8ms) is far worse than the frequency transition itself.

Mikulas
