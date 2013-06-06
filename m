Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab3FFKKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:10:18 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:55321 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588Ab3FFKKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:10:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130606100138.GC21181@pd.tnic>
References: <51AF60D5.3080605@semaphore.gr>
	<20130605161703.GA29958@pd.tnic>
	<51AF71B6.6030408@semaphore.gr>
	<105446113.ZumbZWCbSi@vostro.rjw.lan>
	<20130606100138.GC21181@pd.tnic>
Date: Thu, 6 Jun 2013 15:40:13 +0530
Message-ID: <CAKohpo=cwxvcicw4svcvyKJOzGD9j+gzTyg=4yYg4EsY89C3EQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of
 target frequency
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Stratos Karafotis <stratosk@semaphore.gr>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 June 2013 15:31, Borislav Petkov <bp@suse.de> wrote:

> Hold on, you say above "easily saturate minimum frequency and lead the
> CPU to max". I read this as we jump straight to max P-state where we
> even boost.

Probably he meant: "At lowest levels of frequencies, a small load on system
may look like a huge one. like: 20-30% load on max freq can be 95% load
on min freq. And so we jump to max freq even for this load and return back
pretty quickly as this load doesn't sustain for longer. over that we wait for
load to go over up_threshold to increase freq."

> "CPU to max" finishes the work faster than middle frequencies, if you're
> CPU-bound.

He isn't removing this feature at all.

Current code is:

if (load > up_threshold)
   goto maxfreq.
else
   don't increase freq, maybe decrease it in steps

What he is doing is:

if (load > up_threshold)
   goto maxfreq.
else
   increase/decrease freq based on current load.

So, if up_threshold is 95 and load remains < 95, his patch will
give significant improvement both power & performance wise.

Else, it shouldn't decrease it.
