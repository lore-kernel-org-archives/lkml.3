Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab3KTO7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:59:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41052 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab3KTO7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:59:18 -0500
Message-ID: <528CCE42.2060307@ti.com>
Date: Wed, 20 Nov 2013 08:59:14 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@linaro.org>
CC: Shawn Guo <shawn.guo@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Carlos Hernandez <ceh@ti.com>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: Use a sane boot frequency when
 booting with a mismatched bootloader configuration
References: <1384568535-26611-1-git-send-email-nm@ti.com>	<20131116134445.GI11014@S2101-09.ap.freescale.net>	<CAKohponU-WFnG8Gx6ba=k3eJmWV_0eWtpsy9kDP8yA2KrdoKtg@mail.gmail.com>	<528A27F8.3070402@ti.com>	<20131118155753.GU11014@S2101-09.ap.freescale.net>	<528A4340.3020508@ti.com>	<20131119022133.GB18434@S2101-09.ap.freescale.net>	<CAKohpok_yRZr-XQEC+w8PLN+ZyW83uijFyZrDM1LB8G2X4h-fg@mail.gmail.com>	<528B72C1.5060006@ti.com>	<CAKohpo=hzCSuQBGreRStzkOuH6aFiZKTtK9SF+_eGEajkwSXEA@mail.gmail.com>	<528B7CE5.5040502@ti.com>	<CAKohponO7M6rYoPt=ePNTZh=y+iU=BEbFWBqxr1JQPbVptvgXA@mail.gmail.com>	<528B884C.7070908@ti.com> <CAKohpo=brpnLe68ExPRPg9h5ABMhg+GS85Ebn-+S5-vWaStrPQ@mail.gmail.com> <528BA355.4040008@ti.com> <528C478C.1070901@linaro.org>
In-Reply-To: <528C478C.1070901@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 11:24 PM, viresh kumar wrote:
> On Tuesday 19 November 2013 11:13 PM, Nishanth Menon wrote:
>> we depend on the first transition to take us to a sane configuration -
>> but we cannot predict when and if it will happen.
> 
> I really believe that it happens fairly quickly, isn't it? We straight away
> start the sampling of load and withing few milliseconds we must be fixing the freq..

that heavily depends on the governor - and we all know the variants of
ondemand governors that various distributions use. I cannot say
(having not studied all governors out there) if this will take place
in a few milliseconds or a few minutes or hours.

> 
> We aren't going to stay for the unknown, might be unstable, freq for ever..
> 
With the current governors that we have in upstream, the only one of
my concern has been userspace governor, but based on your comment
earlier in the thread, this is considered an non-issue since userspace
must trigger transition. However, this does put the SoC at risk
depending on distro and custom governors used.

If the opinion is that we dont care about these, well.. I can end my
complaints and depend on the stats to tell me if an unknown frequency
was ever attempted for debug (even though I might personally not be
too excited about it).

-- 
Regards,
Nishanth Menon
