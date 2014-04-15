Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaDOLAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:00:19 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:56233 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754422AbaDOLAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:00:12 -0400
Message-ID: <534D1138.90409@semaphore.gr>
Date: Tue, 15 Apr 2014 14:00:08 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/20] cpufreq: acpi-cpufreq: Use cpufreq_for_each_entry
 macro for iteration
References: <534C4E36.9060208@semaphore.gr> <CAKohpok5+Eai=OOs9J+uYp4NaYmovXqkkg_Bvx0025_XyS4xTQ@mail.gmail.com>
In-Reply-To: <CAKohpok5+Eai=OOs9J+uYp4NaYmovXqkkg_Bvx0025_XyS4xTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/2014 08:32 πμ, Viresh Kumar wrote:
> On 15 April 2014 02:38, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>> The cpufreq core supports the cpufreq_for_each_entry macro helper
>> for iteration over the cpufreq_frequency_table, so use it.
>>
>> It should have no functional changes.
>>
>> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
>> ---
>>  drivers/cpufreq/acpi-cpufreq.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
>> index 000e4e0..12a5750 100644
>> --- a/drivers/cpufreq/acpi-cpufreq.c
>> +++ b/drivers/cpufreq/acpi-cpufreq.c
>> @@ -213,7 +213,7 @@ static unsigned extract_io(u32 value, struct acpi_cpufreq_data *data)
>>
>>  static unsigned extract_msr(u32 msr, struct acpi_cpufreq_data *data)
>>  {
>> -       int i;
>> +       struct cpufreq_frequency_table *pos;
>>         struct acpi_processor_performance *perf;
>>
>>         if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
>> @@ -223,11 +223,11 @@ static unsigned extract_msr(u32 msr, struct acpi_cpufreq_data *data)
>>
>>         perf = data->acpi_data;
>>
>> -       for (i = 0; data->freq_table[i].frequency != CPUFREQ_TABLE_END; i++) {
>> -               if (msr == perf->states[data->freq_table[i].driver_data].status)
>> -                       return data->freq_table[i].frequency;
>> +       cpufreq_for_each_entry(pos, data->freq_table) {
>> +               if (msr == perf->states[pos->driver_data].status)
>> +                       return pos->frequency;
>>         }
>> -       return data->freq_table[0].frequency;
>> +       return data->freq_table->frequency;
> 
> This isn't a related change, isn't it? Also it make it less readable.
> So probably
> just leave it as is.
> 

I thought that since we use pointer notation it would be more clear.
But, I will change it according to your suggestion.


Stratos
