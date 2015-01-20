Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbbATHTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:19:20 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36682 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbbATHTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:19:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAL_Jsq+5sdsm_-VW-ta+qV-NBao-XTHvsYWcbMdZmbP0Nw43Cw@mail.gmail.com>
References: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
	<1420681257-3078-3-git-send-email-cw00.choi@samsung.com>
	<CAL_Jsq+5sdsm_-VW-ta+qV-NBao-XTHvsYWcbMdZmbP0Nw43Cw@mail.gmail.com>
Date: Tue, 20 Jan 2015 12:49:15 +0530
Message-ID: <CAKohpomqosqxeDANC=NLBVmOUHyUoqd7Zhph7r6f7+ufYN48EQ@mail.gmail.com>
Subject: Re: [PATCHv3 2/8] devfreq: exynos: Add documentation for generic
 exynos memory bus frequency driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Mark Rutland <mark.rutland@arm.com>, a.kesavan@samsung.com,
        Tomasz Figa <tomasz.figa@gmail.com>,
        =?UTF-8?Q?Krzysztof_Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, InKi Dae <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 January 2015 at 02:48, Rob Herring <robherring2@gmail.com> wrote:
> Adding Viresh.

Sorry for being too late, I was very busy with other cpufreq stuff I was doing
and saved this thread for later as it required me to understand it properly..

>> +Required properties for memory bus block:
>> +- clock-names : the name of clock used by the memory bus, "memory-bus".
>> +- clocks : phandles for clock specified in "clock-names" property.
>> +- #clock-cells: should be 1.
>> +- frequency: the frequency table to support DVFS feature.
>
> So you have just defined a new OPP table format. We already have one
> and Viresh is working to create a more extendable one. He asked about
> what's needed in devfreq, so Viresh here you go. :)

I failed to understand what's new here, probably I need more clarity on
what we are doing here..

So, this is what I see from OPPs point of view, everything else stripped out.

>> +       memory_bus_int: memory_bus@1 {

>> +               operating-points = <
>> +                       400000 950000
>> +                       200000 950000
>> +                       133000 925000
>> +                       100000 850000
>> +                       80000  850000
>> +                       50000  850000>;

So these are the OPPs your "groups" support and below ones are
the frequencies that each block will support. Right ?

>> +               blocks {

>> +                               frequency = <
>> +                                       100000
>> +                                       100000
>> +                                       100000
>> +                                       100000

Why this replication here ?

>> +                                       50000
>> +                                       50000>;
>> +                       };

How are the above two tables (operating-points and frequency) related
here? What about the voltages at which these frequencies are possible ?

>> +                       display_block: memory_bus_block2 {

>> +                               frequency = <
>> +                                       200000
>> +                                       160000
>> +                                       100000
>> +                                       80000
>> +                                       80000
>> +                                       50000>;
>> +                       };

>> +                       isp_block: memory_bus_block3 {

>> +                               frequency = <
>> +                                       200000
>> +                                       200000
>> +                                       100000
>> +                                       80000
>> +                                       50000
>> +                                       50000>;
>> +                       };

>> +                       gps_block: memory_bus_block4 {

>> +                               frequency = <
>> +                                       300000
>> +                                       200000
>> +                                       133000
>> +                                       100000
>> +                                       50000
>> +                                       50000>;
>> +                       };

same for others as well..
