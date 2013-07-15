Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab3GOG1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 02:27:40 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:44675 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab3GOG1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 02:27:39 -0400
Message-ID: <51E39583.5090601@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 11:54:03 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, toralf.foerster@gmx.de, robert.jarzmik@intel.com,
        durgadoss.r@intel.com, tianyu.lan@intel.com, lantianyu1986@gmail.com,
        dirk.brandewie@gmail.com, stern@rowland.harvard.edu,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] cpufreq: Add helper to perform alloc/free of policy
 structure
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com> <20130711221605.547.69988.stgit@srivatsabhat.in.ibm.com> <CAKohponVobWCLNf3ryPiEXpmru+qrp=EYLyX0zLh2SSabpf-SQ@mail.gmail.com>
In-Reply-To: <CAKohponVobWCLNf3ryPiEXpmru+qrp=EYLyX0zLh2SSabpf-SQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071506-5816-0000-0000-000008E84518
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 12:39 PM, Viresh Kumar wrote:
> On 12 July 2013 03:46, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> Separate out the allocation of the cpufreq policy structure (along with
>> its error handling) to a helper function. This makes the code easier to
>> read and also helps with some upcoming code reorganization.
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>>  drivers/cpufreq/cpufreq.c |   50 ++++++++++++++++++++++++++++++++-------------
>>  1 file changed, 35 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index f8c3100..ca14dc2 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -943,6 +943,37 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
>>  }
>>  #endif
>>
>> +static struct cpufreq_policy *cpufreq_policy_alloc(void)
>> +{
>> +       struct cpufreq_policy *policy;
>> +
>> +       policy = kzalloc(sizeof(struct cpufreq_policy), GFP_KERNEL);
> 
> sizeof(*policy) ??

Ah, thanks for pointing that. That must be a remnant from the old code.
But, to make it easier for people testing this patchset to fix their
cpufreq regressions, I'll hold off on posting newer versions of this patchset,
to avoid confusion. We can revisit this at a later point in time, IMHO.

Regards,
Srivatsa S. Bhat

