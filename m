Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3JDCxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 22:53:54 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:57339 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab3JDCxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 22:53:52 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <e689bd437918e56ae50541a90a4b9c606bfb8bf4.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
	<e689bd437918e56ae50541a90a4b9c606bfb8bf4.1379063063.git.viresh.kumar@linaro.org>
Date: Thu, 3 Oct 2013 19:53:51 -0700
Message-ID: <CAOesGMjE9s4KqHaAbkejZ-2GG4zv4Y1AxpgWzcMKovuMJFZ_-w@mail.gmail.com>
Subject: Re: [PATCH 038/228] cpufreq: sa11x0: Expose frequency table
From: Olof Johansson <olof@lixom.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, Patch Tracking <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 5:59 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> This patch exposes sa11x0's frequency table to cpufreq core. It always existed
> but not as an array frequencies and not in the format cpufreq core wants it to.
> Also it was present in the unit of 100kHz earlier which is made consistent with
> cpufreq core now, i.e. kHz.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

This causes breakage in linux-next for any SA1100 target:

In file included from ../../arch/arm/mach-sa1100/irq.c:24:0:
../../arch/arm/mach-sa1100/generic.h:24:39: error: array type has
incomplete element type
 extern struct cpufreq_frequency_table sa11x0_freq_table[];

-Olof
