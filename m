Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab3EGQBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:01:42 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:43609 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202Ab3EGQBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:01:40 -0400
Message-ID: <51892560.7090202@linaro.org>
Date: Tue, 07 May 2013 09:01:36 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Feng Tang <feng.tang@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fwd: [GIT PULL] timer changes for v3.10
References: <20130430074322.GA20110@gmail.com> <20130506230137.GA16801@amd.pavel.ucw.cz> <CA++bM2scosWgBpC3_LzcKYOjG4EQQzN5Vf4rZFds-5qRVRwvDQ@mail.gmail.com> <20130507023853.GA2945@feng-snb> <20130507065348.GF17705@gmail.com>
In-Reply-To: <20130507065348.GF17705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 11:53 PM, Ingo Molnar wrote:
> * Feng Tang <feng.tang@intel.com> wrote:
>
>>> is even worse than that. Machine can stay is s2ram for weeks (for a
>>> lot more if it is desktop and you do s2ram for powersaving). Also
>>> temperature of CPU varies a lot between active and s2ram states. Is
>>> TSC good enough?
>> Yes, I think it is relatively precise. Per our test, system time backed
>> by the S3 non stop TSC only has 1 second drift after 4 days running
>> (with mixed running and S3 states). And before using this feature, we've
>> seen many time drift problems due to the RTC HW or system FW with our
>> platforms.
> Nice result ...
>
> Is that with NTP running?
>
> Without NTP, the TSC fast-calibration on bootup is not (expected to be)
> nearly as precise as the 1:345600 precision you've measured.

We also do refined calibration now on the TSC asynchronously over a 
period of seconds at boot up that gives us much better accuracy then the 
fast calibration. This helps provide much more consistent boot-to-boot 
TSC frequencies.

thanks
-john

