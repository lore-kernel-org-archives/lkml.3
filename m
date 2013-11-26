Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3KZCBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:01:54 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:51950 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab3KZCBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:01:51 -0500
MIME-Version: 1.0
In-Reply-To: <2997050.eogEtPXZyL@vostro.rjw.lan>
References: <046513da96dfec919a1a41d270c167147d4a9c8d.1385353358.git.viresh.kumar@linaro.org>
	<CAKohpok0QJ2xP5uoSaAsX76KwD5yi9Z54pgNyQ7CW3c4Fkbq2A@mail.gmail.com>
	<52938C5F.7000307@gmail.com>
	<2997050.eogEtPXZyL@vostro.rjw.lan>
Date: Tue, 26 Nov 2013 07:31:50 +0530
Message-ID: <CAKohpon22PxGdTFcaOqzpLpVZd75OPP470Wyy95GjBhG2gViyQ@mail.gmail.com>
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

On 26 November 2013 02:43, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Monday, November 25, 2013 09:43:59 AM Dirk Brandewie wrote:
>> This is a platform specific bug fix AFAICT and belongs in a platform
>> specific piece of code

In case we end up doing that, we will do lots of code redundancy in
cpufreq drivers. And as Rafael said, some platforms might never
know they have booted with an out of table frequency and so taking
care of this at a single place is better, where we are sure that it
will get fixed.

>> The core should not be working around bootloader bugs IMHO.  Silently
>> fixing it is evil IMHO at a minimum the core should complain LOUDLY
>> about this happening otherwise the bootloaders will have no incentive to
>> get their act together.

That looks correct..

> Yes, we can add a WARN_ON() there.  Still, though, the core's responsibility
> is to ensure that (a) either we can continue safely or (b) we can't, in which
> case it should just fail the initialization.  Whether or not it should panic()
> I'm not sure.

But is this that big crime, that we do a WARN on it? CPU was running on
a workable frequency, it wasn't mentioned in the table, that's it.

Probably just throw an print message that CPU found to be running on
out of table frequency, and that got fixed..
