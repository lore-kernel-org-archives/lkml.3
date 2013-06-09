Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab3FIWB5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 18:01:57 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:60926 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab3FIWB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 18:01:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: Stratos Karafotis <stratosk@semaphore.gr>, Borislav Petkov <bp@suse.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of target frequency
Date: Mon, 10 Jun 2013 00:11:04 +0200
Message-ID: <2414473.nDRDW2UoEh@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130609211449.GA5517@pd.tnic>
References: <q46r5iepl3sunqe5eemv66hk.1370694869222@email.android.com> <7661669.NhG4BEI8zO@vostro.rjw.lan> <20130609211449.GA5517@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 09, 2013 11:14:49 PM Borislav Petkov wrote:
> On Sun, Jun 09, 2013 at 10:58:51PM +0200, Rafael J. Wysocki wrote:
> > Can you possibly prepare a graph showing both the execution time
> > and energy consumption for several different loop durations in your
> > program (let's keep the 5000 us sleep for now), including multiples of
> > sampling_rate as well as some other durations?
> 
> Judgind by the times in C0 one of the cores spent, this small program
> is single-threaded and is a microbenchmark.

Yes, it is single-threaded, but that can be easily addressed by running
multiple copies of it in parallel. :-)

And yes, it is a microbenchmark, ->

> And you know how optimizing against a microbenchmark doesn't really make
> a lot of sense.

-> but this is more about finding possible issues that about optimizing.

I'm regarding this change as a substantial code simplification in the first
place, both in terms of conceptual complexity and the actual code size, so I'd
like to know what is *likely* to be affected by it (be it a microbenchmark or
whatever).

IOW, try to play a devil's advocate and find something that get's worse after
applying these changes.  If we can't find anything like that, there won't be
any reason not to apply them.

> I wonder if lmbench or aim9 or whatever would make more sense to try here...

I think we'll need to try them too.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
