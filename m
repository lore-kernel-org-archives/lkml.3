Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbaDHL7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 07:59:03 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57433 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756551AbaDHL7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:59:00 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, l.majewski@samsung.com
Subject: Re: [PATCH V2 1/4] cpufreq: ia64: don't set .driver_data to index
Date: Tue, 08 Apr 2014 14:14:59 +0200
Message-ID: <2698524.P4nWCs3Rzq@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <57f831e4e1d45b7d81bc4cf4a94946db57360366.1396013927.git.viresh.kumar@linaro.org>
References: <57f831e4e1d45b7d81bc4cf4a94946db57360366.1396013927.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 28, 2014 07:11:44 PM Viresh Kumar wrote:
> .driver_data field is only required to be filled if drivers want to preserve
> some data in there which they can use according to the value of .frequency
> field. But this driver isn't using this field at all, but just setting it equal
> to the index value. Which isn't required. Fix it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

All four queued up for the next pull request, thanks!

> ---
> V1->V2: No Change
> 
> Hi Rafael,
> 
> To avoid confusion I am sending all related cpufreq patches again.
> 
>  drivers/cpufreq/ia64-acpi-cpufreq.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
> index a22b5d1..beb191b 100644
> --- a/drivers/cpufreq/ia64-acpi-cpufreq.c
> +++ b/drivers/cpufreq/ia64-acpi-cpufreq.c
> @@ -275,7 +275,6 @@ acpi_cpufreq_cpu_init (
>  	/* table init */
>  	for (i = 0; i <= data->acpi_data.state_count; i++)
>  	{
> -		data->freq_table[i].driver_data = i;
>  		if (i < data->acpi_data.state_count) {
>  			data->freq_table[i].frequency =
>  			      data->acpi_data.states[i].core_frequency * 1000;
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
