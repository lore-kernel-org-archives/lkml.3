Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbaCRSwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 14:52:44 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:59379 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbaCRSwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 14:52:42 -0400
Message-ID: <532895DF.2090100@linux.vnet.ibm.com>
Date: Wed, 19 Mar 2014 00:22:15 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Patrick Marlier <patrick.marlier@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH v2 2/2] intel_pstate: Set core to min P state during core
 offline
References: <16035918.jZXKnQ3yiq@vostro.rjw.lan> <1394831037-15553-1-git-send-email-dirk.j.brandewie@intel.com> <1394831037-15553-3-git-send-email-dirk.j.brandewie@intel.com> <CAOh2x=kFC5cwdYVgFCwNgqZAwWaE-CFQoyYizBuv1W6MOnQ9DA@mail.gmail.com> <53285FDB.40102@gmail.com>
In-Reply-To: <53285FDB.40102@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031818-6102-0000-0000-000005289325
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 08:31 PM, Dirk Brandewie wrote:
> On 03/17/2014 10:44 PM, Viresh Kumar wrote:
>> On Sat, Mar 15, 2014 at 2:33 AM,  <dirk.brandewie@gmail.com> wrote:
>>> +
>>>   static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
>>>   {
>>>          struct cpudata *cpu;
>>> @@ -818,7 +824,7 @@ static struct cpufreq_driver intel_pstate_driver = {
>>>          .setpolicy      = intel_pstate_set_policy,
>>>          .get            = intel_pstate_get,
>>>          .init           = intel_pstate_cpu_init,
>>> -       .exit           = intel_pstate_cpu_exit,
>>> +       .stop           = intel_pstate_cpu_stop,
>>
>> Probably, keep exit as is and only change P-state in stop(). So that
>> allocation of resources happen in init() and they are freed in exit()?
>>
> I looked at doing just that but it junked up the code.  if stop() is called
> during PREPARE then init() will be called via __cpufreq_add_dev() in the
> ONLINE
> and DOWN_FAILED case. So once stop() is called the driver will be ready for
> init() to be called exactly like when exit() is called.
>

I'm sorry, but that didn't make much sense to me. Can you be a little
more specific as to what problems you hit while trying to have a
->stop() which sets min P state and a separate ->exit() which frees
the resources? I think we can achieve this with almost no trouble.

If you ignore the failure case (such as DOWN_FAILED) for now, do you
still see any serious roadblocks?

Regards,
Srivatsa S. Bhat

