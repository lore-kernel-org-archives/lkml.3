Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab3GMKQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 06:16:39 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:63501 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537Ab3GMKQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 06:16:38 -0400
Message-ID: <1373710596.1352.26.camel@x61.thuisdomein>
Subject: Re: [PATCH] cpufreq: Fix cpufreq regression after suspend/resume
From: Paul Bolle <pebolle@tiscali.nl>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 13 Jul 2013 12:16:36 +0200
In-Reply-To: <51DDC8FA.4020609@gmx.de>
References: <51C08370.4050906@gmx.de>
	 <CAKohpok1gThXL925Yz5UgC54vTVQgymBA1cLGER_g-dgZu0JLA@mail.gmail.com>
	 <51CF1E53.6060902@gmx.de> <8029836.CFiJCXmRQ0@vostro.rjw.lan>
	 <51D05DF4.50704@linux.vnet.ibm.com> <51D06556.7080204@gmx.de>
	 <51D07E7F.2030709@linux.vnet.ibm.com> <51DDC8FA.4020609@gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Jul 2013 10:16:36.0141 (UTC) FILETIME=[0E50DDD0:01CE7FB2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-10 at 22:50 +0200, Toralf Förster wrote:
> I tested the patch several times on top of a66b2e5 - the origin issue is
> fixed

Srivatsa's patch became commit f51e1eb63d ("cpufreq: Fix cpufreq
regression after suspend/resume").

>  but - erratically another issue now appears : all 4 cores are runs
> after wakeup at 2.6 GHz.

Well, a laptop I use seems to run into something related: the second of
its two cores can get stuck at a fixed frequency after resume. Often
it's its maximum frequency. That makes the CPU run hot, without actually
doing much work. But it can also get stuck at its lowest frequency.

Please note that commit f51e1eb63d, which is part of v3.10.1-rc1,
doesn't seem to cause this behavior. This issue can already be seen when
running v3.10.0. So perhaps that commit just made this issue more
noticeable to Toralf. But it's not clear to me what Toralf's origin(al?)
issue actually was.

Anyhow, I suspect that the stuck frequency is a regression introduced in
v3.10.0. But I have been unable to pinpoint it to a commit added in the
v3.10 cycle through bisecting. I must have marked a commit good that was
actually bad, just because a few suspend and resume cycles didn't
trigger this issue. To be continued...
 
> The temporary hot fix is to switch between governor performance and
> ondemand for all 4 cores.

That workaround works here too. I switch the core that is stuck at a
particular frequency to some other governor and then back to ondemand.

Thanks,


Paul Bolle

