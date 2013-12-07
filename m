Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab3LGPYO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 10:24:14 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:49437 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754840Ab3LGPYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 10:24:12 -0500
Message-ID: <1386429849.9737.7.camel@x41.thuisdomein>
Subject: Re: [PATCH V4] cpufreq: suspend governors on system
 suspend/hibernate
From: Paul Bolle <pebolle@tiscali.nl>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Kgene Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-tegra@vger.kernel.org, jinchoi@broadcom.com,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sebastian Capella <sebastian.capella@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Date: Sat, 07 Dec 2013 16:24:09 +0100
In-Reply-To: <87vbz0j55p.fsf@nemi.mork.no>
References: <28d493f20239a242a7b26dfe1efed40d83bf1e10.1385523340.git.viresh.kumar@linaro.org>
	 <3057132.zHNVNQZ8pP@vostro.rjw.lan>
	 <CAKohpondYbBeObUJJqNZLe04dmN9tLMZv9KrjzqLr2NDorRtLw@mail.gmail.com>
	 <1781198.iCUX9ZdW7W@vostro.rjw.lan>
	 <CAKohpomA9r5a4GkfA-Huh0ectc-hXjSxcdLkJhF6DZvL22yY4w@mail.gmail.com>
	 <87vbz0j55p.fsf@nemi.mork.no>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 07 Dec 2013 15:24:10.0392 (UTC) FILETIME=[60A15980:01CEF360]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-07 at 12:01 +0100, Bjørn Mork wrote:
> Sorry to be making noise here again, but I was eager to verify that the
> fixes in v3.13-rc3 were OK on my system.  Unfortunately it seems this
> patch completely broke suspend for me.  Hibernete ended up with a blank
> console and no visible activity, without ever writing any image to disk.
> 
> There really weren't that many suspects between v3.13-rc2 and v3.13-rc3,
> so I went directly to reverting 5a87182aa21d ("cpufreq: suspend
> governors on system suspend/hibernate") which fixed the problem. I
> didn't bother debugging it further from there. I don't think there is
> anything magic about my system which should make this problem specific
> to it.
> 
> I am still using the acpi-cpufreq driver on an old x86_64 laptop if that
> matters.

On an x86 (32 bits) laptop hibernate also broke in v3.13-rc3. On that
machine hibernation itself worked, or at least seemed to work, but the
machine would basically stop after thawing (directly after loading the
hibernation image).

And reverting commit 5a87182aa21d ("cpufreq: suspend governors on system
suspend/hibernate"), on top of v3.13-rc3, also lead to a successful
hibernation/thaw cycle.


Paul Bolle

