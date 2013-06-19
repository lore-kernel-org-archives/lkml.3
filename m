Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219Ab3FSDAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 23:00:16 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:62129 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934183Ab3FSDAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 23:00:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAFgnuDe1bUub92uE1H9Fc9U7AJCYL=WKdyDe2bg00yEr=kMEbQ@mail.gmail.com>
References: <1371114118-19488-1-git-send-email-chenxg@marvell.com>
	<1912850.KuRKhn87Nf@vostro.rjw.lan>
	<CAFgnuDe1bUub92uE1H9Fc9U7AJCYL=WKdyDe2bg00yEr=kMEbQ@mail.gmail.com>
Date: Wed, 19 Jun 2013 08:30:11 +0530
Message-ID: <CAKohpo=ADC_MGpXFp-QssYS70PHwBBA6qzrWhYGEqZeeaZHLDQ@mail.gmail.com>
Subject: Re: [PATCH v5] cpufreq: fix governor start/stop race condition
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Xiaoguang Chen <chenxg.marvell@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Xiaoguang Chen <chenxg@marvell.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        njiang1@marvell.com, zjwu@marvell.com, ylmao@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 June 2013 06:50, Xiaoguang Chen <chenxg.marvell@gmail.com> wrote:
> 2013/6/19 Rafael J. Wysocki <rjw@sisk.pl>:
>> On Thursday, June 13, 2013 05:01:58 PM Xiaoguang Chen wrote:
>>> cpufreq governor stop and start should be kept in sequence.
>>> If not, there will be unexpected behavior, for example:
>>>
>>> we have 4 cpus and policy->cpu=cpu0, cpu1/2/3 are linked to cpu0.
>>
>> Please spell cpus as "CPUs".  And please start sequences from capitals.
>
> Ok, thanks for the remind
>
>>
>> [Yes, it *really* is a problem.]

Just wanted to know the reasoning behind it so that I can remind
others about it and then argue :)

>>> the normal sequence is as below:
>>>
>>> 1) Current governor is userspace, one application tries to set
>>> governor to ondemand. it will call __cpufreq_set_policy in which it
>>> will stop userspace governor and then start ondemand governor.
>>
>> Do I think correctly that this is for all CPUs?
>
> From current code design, it is for all CPUs.

Why? This can be for a single cpu (which would eventually force all
others CPUs sharing policy with it).
