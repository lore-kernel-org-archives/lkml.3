Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515Ab3K1NlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 08:41:20 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:32811 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab3K1NlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 08:41:18 -0500
MIME-Version: 1.0
In-Reply-To: <14305907.pSqK27Oikr@vostro.rjw.lan>
References: <046513da96dfec919a1a41d270c167147d4a9c8d.1385353358.git.viresh.kumar@linaro.org>
	<5408313.YdNvR1b3g5@vostro.rjw.lan>
	<CAKohponPOFP3pxZYngZcFneBMNozNkCyB1Yevj4801TqfAxHbw@mail.gmail.com>
	<14305907.pSqK27Oikr@vostro.rjw.lan>
Date: Thu, 28 Nov 2013 19:11:17 +0530
Message-ID: <CAKohpokyY0ueNXBQn+Vt5A9V65_ko7D5R=iruUzi6cD9YuXOig@mail.gmail.com>
Subject: Re: [PATCH V2] cpufreq: Make sure CPU is running on a freq from freq-table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Carlos Hernandez <ceh@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 November 2013 18:39, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> acpi-cpufreq is one at least.
>
> Anyway, this isn't about ACPI or anything like that, but hardware.  Generally
> speaking, on modern Intel hardware the processor itself chooses the frequency
> to run at and it may do that behind your back.  Moreover, it can choose a
> frequency different from the one you asked for.  And it won't choose one that
> it can't run at for that matter. :-)
>
> Overall, I don't believe that the problem you're trying to address is relevant
> for any non-exotic x86 hardware.

Okay.. So wouldn't it be better that we add this special flag only when we
face a real problem? Otherwise this flag might stay unused for long time
and then we might end up removing it..

>> > So there should be a flag for
>> > drivers indicating whether or not frequencies (or operation points in
>> > general) are directly testable and the check should only be done for
>> > the drivers with the flag set.
>>
>> Probably a flag with properties exactly opposite to what you mentioned,
>> so that we don't need to modify most of the drivers..
>
> That would work too if you prefer it.

In case we need this flag, what should we name it?
ALLOW_UNKNOWN_FREQ ??
