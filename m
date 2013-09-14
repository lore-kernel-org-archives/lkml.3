Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab3INEBp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 00:01:45 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:53197 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3INEBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 00:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130913.174711.268706749518726971.davem@davemloft.net>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
	<56edbe14da9944ad026497bc1a0dc4aaa283d506.1379063063.git.viresh.kumar@linaro.org>
	<20130913.174711.268706749518726971.davem@davemloft.net>
Date: Sat, 14 Sep 2013 09:31:41 +0530
Message-ID: <CAKohpokM=5W+qAtCgurtiZvMV2A98xD_M2908Veop0pjD2-FSQ@mail.gmail.com>
Subject: Re: [PATCH 012/228] cpufreq: sparc: call cpufreq_frequency_table_get_attr()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: David Miller <davem@davemloft.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        sparclinux@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 September 2013 03:17, David Miller <davem@davemloft.net> wrote:
> From: Viresh Kumar <viresh.kumar@linaro.org>
> Date: Fri, 13 Sep 2013 18:29:18 +0530
>
>> This exposes frequency table of driver to cpufreq core and is required for core
>> to guess what the index for a target frequency is, when it calls
>> cpufreq_frequency_table_target(). And so this driver needs to expose it.
>>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: sparclinux@vger.kernel.org
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Wait a second, later in this series you add the put_attr() call claiming
> it's a fix.
>
> But you're the one adding the "bug" here.
>
> So if you are going to add a get_attr() call you should be adding the
> necessary put_attr() call in the same patch.  Otherwise this patch
> introduces a bug.

Yeah, my mistake.. It was required to be added at both places for
very few drivers and so made this mistake..

I will merge both of those patches together..
