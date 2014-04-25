Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaDYIkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:40:42 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:48301 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaDYIkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:40:37 -0400
Message-ID: <535A1F53.5040806@linux.vnet.ibm.com>
Date: Fri, 25 Apr 2014 14:09:47 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Meelis Roos <mroos@linux.ee>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] cpufreq, longhaul: Fix double invocation of cpufreq_freq_transition_begin/end
References: <20140425081728.10258.63980.stgit@srivatsabhat.in.ibm.com> <20140425081804.10258.8324.stgit@srivatsabhat.in.ibm.com> <CAKohpo=0wppEthZzoRGTqurtt=135NWeVTKJ2y=mwy82+O7-zQ@mail.gmail.com>
In-Reply-To: <CAKohpo=0wppEthZzoRGTqurtt=135NWeVTKJ2y=mwy82+O7-zQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042508-4790-0000-0000-0000010396EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 02:07 PM, Viresh Kumar wrote:
> On 25 April 2014 13:48, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> 
>> diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
> 
>> @@ -269,8 +269,6 @@ static void longhaul_setstate(struct cpufreq_policy *policy,
> 
> This routine has this code as well:
> 
> mult = mults[mults_index & 0x1f];
> if (mult == -1)
>         return;
> speed = calc_speed(mult);
> if ((speed > highest_speed) || (speed < lowest_speed))
>         return;
> 
> And so it might return without changing frequency and that's why I
> left this driver earlier for this change.. So, please return -EINVAL
> from here..
> 

Ok, I'll address this in the next version. Thanks for pointing
this out!

Regards,
Srivatsa S. Bhat

