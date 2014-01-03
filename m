Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159AbaACFlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 00:41:00 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:50458 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaACFk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 00:40:59 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1401021233280.16351@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1312111751180.9686@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1312111937570.23022@file01.intranet.prod.int.rdu2.redhat.com>
	<CAKohpo=_0i43EDSoOAm2ROwEmu9__p+MyoObcLPoZWxUB5XmDA@mail.gmail.com>
	<alpine.LRH.2.02.1401021233280.16351@file01.intranet.prod.int.rdu2.redhat.com>
Date: Fri, 3 Jan 2014 11:10:58 +0530
Message-ID: <CAKohpok=exdOO-T+SFxsyqCBZ1N8ZFBMcVNn-AYsxxMw74DeJQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] powernow-k6: disable cache when changing frequency
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 January 2014 23:08, Mikulas Patocka <mpatocka@redhat.com> wrote:
> Flushing the cache and changing frequency takes approximatelly 500us. The
> patch increases policy->cpuinfo.transition_latency to that value.

Its not about how fast caches get cleaned but how much time would
be wasted to get them filled again as same data could be required again
which is just flushed out. That would impact performance more than
flushing caches.
