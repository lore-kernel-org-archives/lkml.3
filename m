Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab3DBWuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:50:17 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50397 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073Ab3DBWuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:50:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Nathan Zimmer <nzimmer@sgi.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/2] cpufreq: split the cpufreq_driver_lock and use the rcu
Date: Wed, 03 Apr 2013 00:57:50 +0200
Message-ID: <8456428.Vj8uefv4LI@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpokXbeRp-pHaJRAOjnF+R+wy8R9We67Yr2C2nyoVXyJd6w@mail.gmail.com>
References: <5159C147.70800@sgi.com> <20130402145536.GA31757@gulag1.americas.sgi.com> <CAKohpokXbeRp-pHaJRAOjnF+R+wy8R9We67Yr2C2nyoVXyJd6w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 02, 2013 08:29:12 PM Viresh Kumar wrote:
> On 2 April 2013 20:25, Nathan Zimmer <nzimmer@sgi.com> wrote:
> > The lock is unneeded if we expect register and unregister driver to not be
> > called from muliple threads at once.  I didn't make that assumption.
> 
> Hmm.. But doesn't rcu part take care of that too?? Two writers
> updating stuff simultaneously?

RCU doesn't cover that in general.  Additional locking is needed to provide
synchronization between writers.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
