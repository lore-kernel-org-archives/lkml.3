Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab3FCKss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:48:48 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57270 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110Ab3FCKsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:48:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stratos Karafotis <stratosk@semaphore.gr>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand: Change the calculation of target frequency
Date: Mon, 03 Jun 2013 12:57:47 +0200
Message-ID: <2413427.Abjbfkms0Z@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpo=EyudEW+EX=b7=Wp-7ceqjVksDTwwSJf77_LNFaaNL3w@mail.gmail.com>
References: <51A7BFA6.3070800@semaphore.gr> <CAKohpokGDFvtaBMKxLTJCkx_WN+HN4eZ7LZ2upBLsXAsmcq7kA@mail.gmail.com> <CAKohpo=EyudEW+EX=b7=Wp-7ceqjVksDTwwSJf77_LNFaaNL3w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 03, 2013 12:25:02 PM Viresh Kumar wrote:
> Sent half written mail.. sorry.. will continue from where I left.
> 
> On 3 June 2013 12:21, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> 
> > So, obviously the calculations aren't the same..
> 
> Now, this is how I understood these two different variables:
> - cpuinfo.max_freq: maximum frequency (in kHz) which is
> supported by this CPU
> - policy->max: Maximum frequency forced by user or governor
> 
> When somebody sets policy->max, he expects cpufreq core to
> use the range between min and max as the slope cpufreq core
> has and adjust its frequencies accordingly..
> 
> Don't know if I am right or wrong :(

The reality is that the set of frequencies to use is constant and changing
policy->max doesn't change that set.  There are just fewer frequencies the
governor can choose from if policy->max is below cpuinfo.max_freq.

The question is if we want policy->max to re-scale them effectively (i.e. to
change weights so that the maximum load maps to the highest frequency available
at the moment) or if we want policy->max to work as a cap (i.e. to map all
loads above certain value to the maximum frequency available at the moment, so
that the criteria for selecting the lower frequencies don't change).  In my
opinion the second option is better, because it means "OK, we can't use some
high frequencies, but let's not hurt performance for the loads that wouldn't
require them anyway".  Otherwise, we'll effectively throttle all loads and
that not only causes performance to drop, but also causes more energy to be
used overall.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
