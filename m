Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaDCOo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:44:28 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:63700 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaDCOoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:44:24 -0400
MIME-Version: 1.0
In-Reply-To: <or61mqio12.fsf@livre.home>
References: <254471b8cee296f860d24368cc467c00b5a07336.1396413826.git.viresh.kumar@linaro.org>
	<or61mqio12.fsf@livre.home>
Date: Thu, 3 Apr 2014 20:14:24 +0530
Message-ID: <CAKohpo=HfZMmSsHdNyZ5cGhOAyMHkHNH8bBrOwk7kC9eBK_VbQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: loongson2_cpufreq: don't declare local variable
 as static
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Alexandre Oliva <oliva@gnu.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 April 2014 18:10, Alexandre Oliva <oliva@gnu.org> wrote:
> FWIW, the same mistake is present in at32.

I will check others as well now :)

> I've just finished bisecting the cpufreq regression on loongson2.
> Indeed, this s/static// patch does not fix it, but it was 652ed95d5fa,
> the patch that moved cpuclk into loongson2_cpufreq_cpu_init, that caused
> the regression.
>
> Reverting all the changes to loongson2_cpufreq.c in 652ed95d5fa makes
> cpufreq work again, as opposed to printing nan% in all cpufreq stats in
> cpufreq-info's output, and freezing shortly thereafter.

You must have a look at this:

https://lkml.org/lkml/2014/4/2/426 : [PATCH] MIPS/loongson2_cpufreq:
fix CPU clock rate setting
