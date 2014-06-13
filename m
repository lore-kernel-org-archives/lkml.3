Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaFMOgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:36:24 -0400
Received: from cmta8.telus.net ([209.171.16.81]:34372 "EHLO cmta8.telus.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbaFMOgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:36:23 -0400
X-Authority-Analysis: v=2.0 cv=ffdzPTsF c=1 sm=2
 a=zJWegnE7BH9C0Gl4FFgQyA==:17 a=1chCufcSjPwA:10 a=LGgl8L9ij00A:10
 a=IkcTkHD0fZMA:10 a=aatUQebYAAAA:8 a=Pyq9K9CWowscuQLKlpiwfMBGOR0=:19
 a=6q6oBa1Ie56Ef3e0WqYA:9 a=QEXdDO2ut3YA:10 a=zJWegnE7BH9C0Gl4FFgQyA==:117
X-Telus-Outbound-IP: 173.180.45.4
From: "Doug Smythies" <dsmythies@telus.net>
To: "'Dirk Brandewie'" <dirk.brandewie@gmail.com>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Stratos Karafotis'" <stratosk@semaphore.gr>
Cc: <viresh.kumar@linaro.org>, <dirk.j.brandewie@intel.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1402490012-19969-1-git-send-email-stratosk@semaphore.gr> <00b301cf85ba$40fe4290$c2fac7b0$@net> <5399BACF.6060201@semaphore.gr> <1815178.vjJU51ubGD@vostro.rjw.lan> <539B0147.8020407@gmail.com>
In-Reply-To: <539B0147.8020407@gmail.com>
Subject: RE: [PATCH] cpufreq: intel_pstate: Fix rounding of core_pct
Date: Fri, 13 Jun 2014 07:36:21 -0700
Message-ID: <002201cf8714$d933cca0$8b9b65e0$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac+HDjoJmo05+LrzQhG7A2ef47PsAwAA/5Xg
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014.06.12 06:49 Dirk Brandewie wrote:
> On 06/12/2014 01:03 PM, Rafael J. Wysocki wrote:
>> On Thursday, June 12, 2014 05:35:59 PM Stratos Karafotis wrote:
>>> On 12/06/2014 12:15 πμ, Doug Smythies wrote:

>>>>> Could you please elaborate a little bit more what we need these 2 lines below?
>>>>>

> Sorry for being MIA on this thread I have been up to my eyeballs.

>>>>         if ((rem << 1) >= int_tofp(sample->mperf))
>>>>                 core_pct += 1;

> The rounding should have been
>        core_pct += (1 << (FRAC_BITS-1));
> Since core_pct is is in fixeded point notation at this point. Adding .5 to
> core_pct to round up.

> As Stratos pointed out the the current code only adds 1/256 to core_pct

> Since core_pct_busy stays in fixed point through out the rest of the
> calculations ans we only do the rounding when the PID is returning an
> int I think we can safely remove these two lines.

Absolutely, no.

That code was doing exactly what I wanted it to do.
But, as and I have already admitted, it was overkill, and yes the entire thing
can be changed to use div_64 instead.

We do not want to add 1/2 to core percent here at this spot.
You would just be bringing back the arbitrary and incorrect biasing
of core_pct upwards that used to be there in two spots before.

You would add 1/2 when you want to convert to an integer, not before (and we don't right now, for the call to trace_pstate_sample).

... Doug


