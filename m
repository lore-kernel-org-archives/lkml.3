Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaHLHq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:46:28 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:61999 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbaHLHq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:46:27 -0400
MIME-Version: 1.0
In-Reply-To: <97078cc7-f961-4575-ab72-ec88e6f30b9e@email.android.com>
References: <4708675.eITUXPv8Ih@spock>
	<2651364.4shODVy8cx@spock>
	<CAOh2x=k2xpfqz+VjYpPbQy6Z5aeo8DxkYmk7JSmrAZxQOJSU9Q@mail.gmail.com>
	<1827037.Yd5d4GH5Ub@spock>
	<CAOh2x=k09cQ40EiK72ELfDH8e2M9_ZYbrtK3wz9_1dtYU1+DCQ@mail.gmail.com>
	<97078cc7-f961-4575-ab72-ec88e6f30b9e@email.android.com>
Date: Tue, 12 Aug 2014 13:16:25 +0530
X-Google-Sender-Auth: u1X4XMiopYYiaMIU61J9f0-QWP8
Message-ID: <CAOh2x=nJTuKKKyM72MUFSkrsH1eh1YgRUbfLcTCpfZzO85q80w@mail.gmail.com>
Subject: Re: [BUG] oops in cpufreq driver with AMD Kaveri CPU
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 12:56 PM, Oleksandr Natalenko
<oleksandr@natalenko.name> wrote:
> Got that and will try to investigate ASAP.
>
> Just to note: I tried to use powersave governor and got the same result. I believe notifiers are used with powersave governor as well. Am I wrong?

Notifiers are used from the cpufreq core when frequency is changed.
And the powersave governor should have changed the frequency only
ONCE, i.e. to go to lowest frequency.

So, it probably happened at the first & only change at that time as well..
But it shouldn't happen any later. So, see what the log looks like on
that crash.
