Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab3K1DUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 22:20:39 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:44389 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3K1DUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 22:20:22 -0500
MIME-Version: 1.0
In-Reply-To: <5408313.YdNvR1b3g5@vostro.rjw.lan>
References: <046513da96dfec919a1a41d270c167147d4a9c8d.1385353358.git.viresh.kumar@linaro.org>
	<4759452.7dXrrSTGCc@vostro.rjw.lan>
	<CAKohpomXk34aaG3bKX9AuOcn7ZEXcKrc858jCUhcB2bavcnarQ@mail.gmail.com>
	<5408313.YdNvR1b3g5@vostro.rjw.lan>
Date: Thu, 28 Nov 2013 08:50:20 +0530
Message-ID: <CAKohponPOFP3pxZYngZcFneBMNozNkCyB1Yevj4801TqfAxHbw@mail.gmail.com>
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

On 28 November 2013 01:51, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> I have a concern that on some systems you can't really say what frequency
> you're running at the moment, however.

Which ones? I know ACPI tries to play smart by handling the frequency stuff
itself by marking CPUs not-related to each other for the kernel where they
might actually be sharing clock line... But probably in these cases as well,
atleast the cpufreq core should believe that it is running on a valid frequency
even if actual hardware is running at something different..

Any other platforms you are aware of that implement ->target/target_index
and where we can't say what freq are they running at?

> So there should be a flag for
> drivers indicating whether or not frequencies (or operation points in
> general) are directly testable and the check should only be done for
> the drivers with the flag set.

Probably a flag with properties exactly opposite to what you mentioned,
so that we don't need to modify most of the drivers..
