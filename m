Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab3KVHGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 02:06:16 -0500
Received: from mail-qe0-f47.google.com ([209.85.128.47]:54998 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3KVHGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 02:06:14 -0500
Message-ID: <528F025E.70202@linaro.org>
Date: Fri, 22 Nov 2013 12:36:06 +0530
From: viresh kumar <viresh.kumar@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
CC: Nishanth Menon <nm@ti.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sripa Bagadia <ceh@ti.com>
Subject: Re: [PATCH] cpufreq: Make sure CPU is running on a freq from freq-table
References: <de5c3ff26e9d06a6e0b06f8ba3da6d8c3ff82304.1385017369.git.viresh.kumar@linaro.org> <CAKohpo=fZ8Fr=CMDzCy3daBU+mZBJ+9fOks6L7WLOZzE7WaAaQ@mail.gmail.com> <528E4950.9030507@gmail.com> <1980582.Pd2pT79ZWp@vostro.rjw.lan>
In-Reply-To: <1980582.Pd2pT79ZWp@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 November 2013 03:13 AM, Rafael J. Wysocki wrote:
> On Thursday, November 21, 2013 09:56:32 AM Dirk Brandewie wrote:

>> The scaling driver for the CPU has already loaded and its .init procedure has 
>> been called so .target better be callable.

Yeah..

>> Since the scaling driver is responsible maintaining the set of valid frequencies
>> and setting policy->cur I think it is reasonable to have the scaling driver
>> ensure that policy->cur returned from its .init

I agree..

>> and the operating frequency are
>> in sync and match one of the values in its frequency table.

Hmmm, that doesn't necessarily lie in driver's domain but maybe at a common
place like core. That's why we had this patch..

> From that I infer that we should not continue on errors here.  Which also is my
> opinion.

Okay.. Code modified to return error on failure.. Will send V2 as soon as patch
is tested by Nishanth..
