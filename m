Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbaCRTZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:25:23 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51851 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715AbaCRTZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:25:21 -0400
Message-ID: <53289D9A.8070805@gmail.com>
Date: Tue, 18 Mar 2014 12:25:14 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: dirk.brandewie@gmail.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        patrick.marlier@gmail.com, viresh.kumar@linaro.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH v3 0/2] Add stop callback to the cpufreq_driver interface.
References: <1394831037-15553-1-git-send-email-dirk.j.brandewie@intel.com> <1395163361-26380-1-git-send-email-dirk.j.brandewie@intel.com> <532899B2.2060106@linux.vnet.ibm.com>
In-Reply-To: <532899B2.2060106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 12:08 PM, Srivatsa S. Bhat wrote:
> On 03/18/2014 10:52 PM, dirk.brandewie@gmail.com wrote:
>> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
>>
>
> I don't mean to nitpick, but generally its easier to deal with
> patchsets if you post the subsequent versions in fresh email threads.
> Otherwise it can get a bit muddled along with too many other email
> discussions in the same thread :-(
>
>> Changes:
>> v2->v3
>> Changed the calling of the ->stop() callback to be conditional on the
>> core being the last core controlled by a given policy.
>>
>
> Wait, why? I'm sorry if I am not catching up with the discussions on
> this issue quickly enough, but I don't see why we should make it
> conditional on _that_. I thought we agreed that we should make it
> conditional in the sense that ->stop() should be invoked only for
> ->setpolicy drivers, right?

This was done at Viresh's suggestion since thought there might be value
for ->target drivers.

Any of the options work for me
    called only for set_policy scaling drivers
    called unconditionally for all scaling drivers
    called for last core controlled by a given policy

>
> The way I look at it, ->stop() gives you a chance to stop managing
> the CPU going offline. As in "stop this CPU". ->exit() is your chance
> to cleanup the policy, since all its users have gone offline (or this
> is the last CPU belonging to that policy which is going offline).
>
> With this in mind, we should invoke ->stop() every time we take a
> CPU offline, and invoke ->exit() only when the last CPU in the policy
> goes offline.

This is exactly what will happen for intel_pstate since the policies cover
a single core.

I will defer to you and Viresh how policies that affect more that one
cpu should be handled.

What intel_pstate needs it to be called during the PREPARE phase of the
offline process.

>
> What am I missing?
>
> Regards,
> Srivatsa S. Bhat
>

