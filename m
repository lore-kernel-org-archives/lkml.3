Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab3K0DNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 22:13:15 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:39321 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab3K0DNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 22:13:11 -0500
MIME-Version: 1.0
In-Reply-To: <4253729.doK7ubnxKx@vostro.rjw.lan>
References: <cover.1385374819.git.viresh.kumar@linaro.org>
	<40779593.MBXsTetiKz@vostro.rjw.lan>
	<CAKohpok0E=m=63KXM22usiW7Rsu59cD7Q=+k3tRcW=8269tZnQ@mail.gmail.com>
	<4253729.doK7ubnxKx@vostro.rjw.lan>
Date: Wed, 27 Nov 2013 08:43:10 +0530
Message-ID: <CAKohpomm_2iWVOt8MyWFr6=zrEfuBo1z-fPvkaFk-H873-74cw@mail.gmail.com>
Subject: Re: [PATCH V3 1/6] cpufreq: suspend governors on system suspend/hibernate
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2013 01:53, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, November 26, 2013 07:56:19 AM Viresh Kumar wrote:
>> On 26 November 2013 04:59, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:

>> > This appears to be racy.  Is it really racy, or just seemingly?
>>
>> Why does it look racy to you? Userspace should be frozen by now,
>> policy_list should be stable as well as nobody would touch it.
>
> You're stopping governors while they may be in use in principle.  Do we have
> suitable synchronization in place for that?

At what point exactly in suspend cycle do we suspend timers and workqueues.
I thought userspace would be frozen by now and so would be the governors..
