Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaBSR00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:26:26 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44601 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaBSR0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:26:24 -0500
Message-ID: <5304E93C.9000104@wwwdotorg.org>
Date: Wed, 19 Feb 2014 10:26:20 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Kgene Kim <kgene.kim@samsung.com>,
        jinchoi@broadcom.com, Lan Tianyu <tianyu.lan@intel.com>,
        Sebastian Capella <sebastian.capella@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCH V5 0/7] cpufreq: suspend early/resume late: dpm_{suspend|resume}()
References: <cover.1392273722.git.viresh.kumar@linaro.org>	<52FE71BD.3020103@wwwdotorg.org>	<2869027.iYHxWOSS2C@vostro.rjw.lan>	<52FEAECA.5080905@wwwdotorg.org>	<CAKohpomhvuQQ0JN3wgLBnrSpFUjC9J9QwWZpD9nA6AFYw+paKA@mail.gmail.com>	<5303C018.1020707@wwwdotorg.org> <CAKohponF7ag-tfv77JK0pDVukS6v3QeSY+G_br3FJGskMDCvVw@mail.gmail.com>
In-Reply-To: <CAKohponF7ag-tfv77JK0pDVukS6v3QeSY+G_br3FJGskMDCvVw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 09:15 PM, Viresh Kumar wrote:
> On 19-Feb-2014 1:48 AM, "Stephen Warren" <swarren@wwwdotorg.org> wrote:
>>
>> On 02/17/2014 02:20 AM, Viresh Kumar wrote:
>>> On 15 February 2014 05:33, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>> On 02/14/2014 03:23 PM, Rafael J. Wysocki wrote:
>>>
>>>>> Well, it would be good to verify which part, then.
>>>>
>>>> Patch 2/7 appears to stop that message from being printed during
>>>> suspend, and perhaps reduce the number of times it's printed during
>>>> resume. Patch 7/7 stops the message being printed at all.
>>>>
>>>> Looking at patch 7, I wonder if it's simply because tegra_target() was
>>>> modified never to return -EBUSY, so the bug is still there, but it's
>>>> just been hidden.
>>>
>>> No, the bug is removed now. Its hidden in current linus/master :)
>>
>> I'm not sure what that means; I still see the message:
> 
> I have given a better reply in one of the earlier mails in this thread.
> And skipped a more elaborative reply now.
> 
> So this failure was always there since long time, as you disable your
> target() fn early in suspend. But the message wasn't printed earlier.
> 
> A recently added core patch started printing this, so not a new bug.
> But this series fixes suspend resume completely and you wouldn't see it
> anymore.

OK, so I suppose we have two options:

a) Just ignore the kernel error spew since it's a known issue.

b) If I make the Tegra driver return 0 rather than -EBUSY, would that
work? It would certainly silence the error. However, I wonder if it
would cause the cpufreq core to get out of sync with HW; the core would
think that it'd set some frequency, which the driver ignored, and if it
later wanted to switch frequency, the call might get skipped because the
core thought the HW was already set to that frequency?
