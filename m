Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3HPIAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:00:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34477 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3HPH77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:59:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAOLK0pyVDSc6x1u8Ro6ng1dH8ELqc3P9jPHamgiXBn6sWDgm8w@mail.gmail.com>
References: <cover.1376619363.git.viresh.kumar@linaro.org>
	<333bf5868dfbfb6de474f060dc216fa6d33848e2.1376619363.git.viresh.kumar@linaro.org>
	<CAOLK0pz7e8nQVnZY0a-j_Fd_kFOqF8ZS4tRfYw1S+25Lv8GoFQ@mail.gmail.com>
	<CAOLK0pyVDSc6x1u8Ro6ng1dH8ELqc3P9jPHamgiXBn6sWDgm8w@mail.gmail.com>
Date: Fri, 16 Aug 2013 13:29:58 +0530
Message-ID: <CAKohpom7yk3Zq5JABZ6T+Z_AcMn5G1hoswZK8T=viYv0fp0mcg@mail.gmail.com>
Subject: Re: [PATCH 02/34] cpufreq: acpi: remove calls to cpufreq_notify_transition()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lan Tianyu <lantianyu1986@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 August 2013 13:24, Lan Tianyu <lantianyu1986@gmail.com> wrote:
> Sorry for misoperation.

No Problem...

>                 One concern. Target() callback may return before changing
> cpufreq actually due to some check failures. After this change, prechange
> event will be triggered when these check failures take place. I am not sure
> whether this should be took into account.

Yes, if you see the first patch of this series, it takes this into
account.. In case
target() failed and returned an error, we simply notify the POST CHANGE
notification with old frequencies instead of new ones. I believe that would be
enough..

This is exactly what acpi-cpufreq and others are doing currently.

Hope I answered your question well?

--
viresh
