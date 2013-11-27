Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3K0HUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 02:20:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:43962 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab3K0HUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 02:20:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,780,1378882800"; 
   d="scan'208";a="442866238"
Message-ID: <52959A74.70007@intel.com>
Date: Wed, 27 Nov 2013 15:08:36 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Kgene Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-tegra@vger.kernel.org, jinchoi@broadcom.com,
        Sebastian Capella <sebastian.capella@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCH V3 1/6] cpufreq: suspend governors on system suspend/hibernate
References: <cover.1385374819.git.viresh.kumar@linaro.org> <CAKohpok0E=m=63KXM22usiW7Rsu59cD7Q=+k3tRcW=8269tZnQ@mail.gmail.com> <4253729.doK7ubnxKx@vostro.rjw.lan> <4787675.sJF8mqYyxv@vostro.rjw.lan> <CAKohpo=iSJSh_x3Xj3h-GRE6S25ptsdHf34MftMuD6JVSZw=rg@mail.gmail.com>
In-Reply-To: <CAKohpo=iSJSh_x3Xj3h-GRE6S25ptsdHf34MftMuD6JVSZw=rg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年11月27日 11:07, Viresh Kumar wrote:
> On 27 November 2013 07:12, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> Anyway, if you did what I asked you to do and put the cpufreq suspend/resume
>> into dpm_suspend/resume_noirq(), I'd probably take this for 3.13.  However,
>> since you've decided to put those things somewhere else thus making the
>> change much more intrusive, I can only queue it up for 3.14.
>>
>> This means I'm going to take the Tianyu's patch as a stop gap for 3.13.
> 

Hi Viresh:
	First, I agree the new solution you are working on. :)
But actually I don't totally agree my origin patch have design issue.
Because I think governor should have the ability to check whether it has
been EXIT when doing INIT and it should return error code at that point.
The design is to make governor code stronger to deal with the case that
governor is reinitialized before EXIT. Just from my view.
Sorry for noise.

> There were design issues with that patch actually, as I pointed out earlier
> (handling EXIT part in core and INIT in governors).. And so in case we
> need to get something for v3.13, I will send a short version of this series
> with callbacks from suspend_noirq.


> 
> Get that one instead.
> 
> --
> viresh
> 


-- 
Best regards
Tianyu Lan
