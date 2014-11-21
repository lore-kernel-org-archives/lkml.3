Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750810AbaKUFAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 00:00:51 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:33668 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaKUFAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 00:00:49 -0500
Message-ID: <546EC6FE.1030807@gmail.com>
Date: Fri, 21 Nov 2014 00:00:46 -0500
From: Linda Knippers <ljklists@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Ethan Zhao <ethan.kernel@gmail.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>
CC: Ethan Zhao <ethan.zhao@oracle.com>,
        "<dirk.j.brandewie@intel.com>" <dirk.j.brandewie@intel.com>,
        "<viresh.kumar@linaro.org>" <viresh.kumar@linaro.org>,
        "<rjw@rjwysocki.net>" <rjw@rjwysocki.net>,
        "<corbet@lwn.net>" <corbet@lwn.net>,
        "<linux-doc@vger.kernel.org>" <linux-doc@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-pm@vger.kernel.org>" <linux-pm@vger.kernel.org>,
        "<joe.jin@oracle.com>" <joe.jin@oracle.com>,
        "<brian.maly@oracle.com>" <brian.maly@oracle.com>
Subject: Re: [PATCH 3/3] intel_pstate: add module and kernel command line
 parameter to ignore ACPI _PPC
References: <1416299826-15813-1-git-send-email-ethan.zhao@oracle.com>	<1416299826-15813-8-git-send-email-ethan.zhao@oracle.com>	<20141119110548.24a0a808@kcaccard-desk.amr.corp.intel.com>	<41ADCDB8-C204-4661-833B-F68E7D687B61@gmail.com>	<20141120132317.00ad7210@kcaccard-desk.amr.corp.intel.com> <CABawtvO57bTEs2qCd1SRaOX-R24_VJYmHFLAoUatTRnmuenrdg@mail.gmail.com>
In-Reply-To: <CABawtvO57bTEs2qCd1SRaOX-R24_VJYmHFLAoUatTRnmuenrdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/20/2014 10:07 PM, Ethan Zhao wrote:
> Kristen,
>    Whatever I would like there is a way to load intel_pstate and give
> it a try even it does not support all the PM features.
>    I think 'force' is OK.
> Linda,
>   Do you like it ? if the 'intel_pstate=force' would force the driver
> to be loaded on to HP too ?

I'd prefer that it didn't.  If you force the intel_pstate driver when
the platform thinks it's doing power management, then the OS and the
firmware are trying to manage the power at the same time.  That's a
mess.  If you want that for testing or debugging, what are you actually
testing or debugging?  On an Oracle box, the firmware wouldn't stop
doing whatever it's doing just because the intel_pstate driver is
loaded, would it?

I also wonder what it means to "force" the intel_pstate driver
on systems with processors that aren't supported by the intel_pstate
driver.  It wouldn't really be forced, would it?

-- ljk

> 
> Thanks,
> Ethan
> 
> On Fri, Nov 21, 2014 at 5:23 AM, Kristen Carlson Accardi
> <kristen@linux.intel.com> wrote:
>> On Thu, 20 Nov 2014 08:57:34 +0800
>> ethan <ethan.kernel@gmail.com> wrote:
>>
>>>
>>>
>>>> 在 2014年11月20日，03:05，Kristen Carlson Accardi <kristen@linux.intel.com> 写道：
>>>>
>>>> On Tue, 18 Nov 2014 17:37:06 +0900
>>>> Ethan Zhao <ethan.zhao@oracle.com> wrote:
>>>>
>>>>> Add kernel command line parameter
>>>>> intel_pstate = ignore_acpi_ppc
>>>>> and module parameter
>>>>> ignore_acpi_ppc = 1
>>>>> to allow driver to ignore the ACPI _PPC existence even for Sun x86 servers.
>>>>> These parameter could be used for debug\test\workaround etc purpose.
>>>>>
>>>>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>>>>
>>>> What if we used a more generic parameter like "force" that would bypass
>>>> any vendor specific checks and just load anyway?  This way we don't have
>>>> to add new parameters everything some new thing shows up that we want to
>>>> ignore.
>>>>
>>> To be honest, I prefer more generic parameter. But to avoid the possible negative affect
>>> To another vendors. I back to this way.
>>
>> Well, your parameter can still impact other vendors as it is.  it
>> is pretty typical to assume that using a parameter like "force" means
>> you know what you are doing and accept the risks.  Especially if its
>> documented as such.
>>
>>>
>>> Thanks,
>>> Ethan
>>>>> ---
>>>>> Documentation/kernel-parameters.txt | 3 +++
>>>>> drivers/cpufreq/intel_pstate.c      | 8 +++++++-
>>>>> 2 files changed, 10 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>>>>> index 4c81a86..f502b85 100644
>>>>> --- a/Documentation/kernel-parameters.txt
>>>>> +++ b/Documentation/kernel-parameters.txt
>>>>> @@ -1446,6 +1446,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>>>>               disable
>>>>>                 Do not enable intel_pstate as the default
>>>>>                 scaling driver for the supported processors
>>>>> +               ignore_acpi_ppc
>>>>> +             Ignore the existence of ACPI method _PPC for Sun x86 servers
>>>>> +             and load the driver.
>>>>>
>>>>>    intremap=    [X86-64, Intel-IOMMU]
>>>>>            on    enable Interrupt Remapping (default)
>>>>> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
>>>>> index 7c5faea..388387b 100644
>>>>> --- a/drivers/cpufreq/intel_pstate.c
>>>>> +++ b/drivers/cpufreq/intel_pstate.c
>>>>> @@ -870,6 +870,7 @@ static struct cpufreq_driver intel_pstate_driver = {
>>>>> };
>>>>>
>>>>> static int __initdata no_load;
>>>>> +static unsigned int  ignore_acpi_ppc;
>>>>>
>>>>> static int intel_pstate_msrs_not_valid(void)
>>>>> {
>>>>> @@ -990,7 +991,7 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
>>>>>            intel_pstate_no_acpi_pss())
>>>>>            return true;
>>>>>        if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
>>>>> -            intel_pstate_has_acpi_ppc())
>>>>> +            intel_pstate_has_acpi_ppc() && !ignore_acpi_ppc)
>>>>>            return true;
>>>>>    }
>>>>>
>>>>> @@ -1066,11 +1067,16 @@ static int __init intel_pstate_setup(char *str)
>>>>>
>>>>>    if (!strcmp(str, "disable"))
>>>>>        no_load = 1;
>>>>> +    if (!strcmp(str, "ignore_acpi_ppc"))
>>>>> +        ignore_acpi_ppc = 1;
>>>>>    return 0;
>>>>> }
>>>>> early_param("intel_pstate", intel_pstate_setup);
>>>>> #endif
>>>>>
>>>>> +module_param(ignore_acpi_ppc, uint, 0644);
>>>>> +MODULE_PARM_DESC(ignore_acpi_ppc,
>>>>> +    "value 0 or non-zero. non-zero -> ignore ACPI _PPC and load this driver");
>>>>> MODULE_AUTHOR("Dirk Brandewie <dirk.j.brandewie@intel.com>");
>>>>> MODULE_DESCRIPTION("'intel_pstate' - P state driver Intel Core processors");
>>>>> MODULE_LICENSE("GPL");
>>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
