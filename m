Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaABRia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:38:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbaABRi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:38:27 -0500
Date: Thu, 2 Jan 2014 12:38:08 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] powernow-k6: disable cache when changing frequency
In-Reply-To: <CAKohpo=_0i43EDSoOAm2ROwEmu9__p+MyoObcLPoZWxUB5XmDA@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1401021233280.16351@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1312111751180.9686@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1312111937570.23022@file01.intranet.prod.int.rdu2.redhat.com> <CAKohpo=_0i43EDSoOAm2ROwEmu9__p+MyoObcLPoZWxUB5XmDA@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Dec 2013, Viresh Kumar wrote:

> On 12 December 2013 06:08, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > During frequency transition the processor is in "EPM Stop Grant" state.
> > The documentation says that the processor doesn't respond to inquiry
> > requests in this state. Consequently, coherency of processor caches and
> > bus master devices is not maintained, causing the system instability.
> >
> > This patch flushes the cache during frequency transition. It fixes the
> > instability.
> 
> I don't have much idea of these systems but wouldn't this affect performance
> badly?

Flushing the cache and changing frequency takes approximatelly 500us. The 
patch increases policy->cpuinfo.transition_latency to that value.

I suppose that the governors should be smart enough to not do frequency 
transitions so often so that majority of time is spent doing the 
transition.

Mikulas
