Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab3GOGVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 02:21:41 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38130 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3GOGVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 02:21:40 -0400
Message-ID: <51E3941C.2010101@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 11:48:04 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl,
        toralf.foerster@gmx.de, robert.jarzmik@intel.com,
        durgadoss.r@intel.com, tianyu.lan@intel.com, lantianyu1986@gmail.com,
        dirk.brandewie@gmail.com, stern@rowland.harvard.edu,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] cpufreq: Revert commit a66b2e to fix cpufreq regression
 during suspend/resume
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com> <20130711221527.547.46447.stgit@srivatsabhat.in.ibm.com> <CAKohpomVo5FEN1fOHQQ9jQuLnrRfHcNkH7QcnJG7x6x-Xd7J-A@mail.gmail.com> <1373719585.1359.3.camel@x61.thuisdomein>
In-Reply-To: <1373719585.1359.3.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071506-7014-0000-0000-000003515390
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2013 06:16 PM, Paul Bolle wrote:
> On Fri, 2013-07-12 at 12:48 +0530, Viresh Kumar wrote:
>> On 12 July 2013 03:45, Srivatsa S. Bhat
>> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>>> commit a66b2e (cpufreq: Preserve sysfs files across suspend/resume) has
>>> unfortunately caused several things in the cpufreq subsystem to break subtly
>>> after a suspend/resume cycle.
>>>
>>> The intention of that patch was to retain the file permissions of the
>>> cpufreq related sysfs files across suspend/resume. To achieve that, the commit
>>> completely removed the calls to cpufreq_add_dev() and __cpufreq_remove_dev()
>>> during suspend/resume transitions. But the problem is that those functions
>>> do 2 kinds of things:
>>>   1. Low-level initialization/tear-down that are critical to the correct
>>>      functioning of cpufreq-core.
>>>   2. Kobject and sysfs related initialization/teardown.
>>>
>>> Ideally we should have reorganized the code to cleanly separate these two
>>> responsibilities, and skipped only the sysfs related parts during
>>> suspend/resume. Since we skipped the entire callbacks instead (which also
>>> included some CPU and cpufreq-specific critical components), cpufreq
>>> subsystem started behaving erratically after suspend/resume.
>>>
>>> So revert the commit to fix the regression. We'll revisit and address the
>>> original goal of that commit separately, since it involves quite a bit of
>>> careful code reorganization and appears to be non-trivial.
>>>
>>> (While reverting the commit, note that another commit f51e1eb "cpufreq:
>>> Fix cpufreq regression after suspend/resume" already reverted part of the
>>> original set of changes. So revert only the remaining ones).
>>>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>>> ---
>>>
>>>  drivers/cpufreq/cpufreq.c       |    4 +++-
>>>  drivers/cpufreq/cpufreq_stats.c |    6 ++----
>>>  2 files changed, 5 insertions(+), 5 deletions(-)
>>
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> This seems to fix the "core stuck at some frequency after resume" issue
> I ran into since v3.10. So:
> 
> Tested-by: Paul Bolle <pebolle@tiscali.nl>
> 

Thanks Paul!
 
Regards,
Srivatsa S. Bhat

