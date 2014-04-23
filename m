Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbaDWNxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:53:36 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:53476 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756308AbaDWNwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:52:01 -0400
Message-ID: <5357C57E.9070007@semaphore.gr>
Date: Wed, 23 Apr 2014 16:51:58 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: powernow-k8: Fix checkpatch warnings
References: <5356DB92.1060600@semaphore.gr> <CAKohpo=6wTYHGvLcNUb4+MFdKeHobNA0A1W2Ta5yJqBCAceMhA@mail.gmail.com>
In-Reply-To: <CAKohpo=6wTYHGvLcNUb4+MFdKeHobNA0A1W2Ta5yJqBCAceMhA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/04/2014 07:46 πμ, Viresh Kumar wrote:
> On 23 April 2014 02:43, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>> @@ -342,7 +333,7 @@ static int core_voltage_pre_transition(struct powernow_k8_data *data,
>>                 return 1;
>>
>>         if (savefid != data->currfid) {
>> -               printk(KERN_ERR PFX "ph1 err, currfid changed 0x%x\n",
>> +               pr_err("ph1 err, currfid changed 0x%x\n",
>>                                 data->currfid);
> 
> This will come in single line?
> 
>> @@ -529,43 +510,39 @@ static int check_pst_table(struct powernow_k8_data *data, struct pst_s *pst,
>>
>>         for (j = 0; j < data->numps; j++) {
>>                 if (pst[j].vid > LEAST_VID) {
>> -                       printk(KERN_ERR FW_BUG PFX "vid %d invalid : 0x%x\n",
>> -                              j, pst[j].vid);
>> +                       pr_err(FW_BUG "vid %d invalid : 0x%x\n", j,
>> +                              pst[j].vid);
> 
> Same here.
> 
>>  static const char missing_pss_msg[] =
>>         KERN_ERR
> 
> remove this and use pr_err_once instead of printk_once()
> 
>> -       FW_BUG PFX "No compatible ACPI _PSS objects found.\n"
>> -       FW_BUG PFX "First, make sure Cool'N'Quiet is enabled in the BIOS.\n"
>> -       FW_BUG PFX "If that doesn't help, try upgrading your BIOS.\n";
>> +       FW_BUG KBUILD_MODNAME
>> +       "No compatible ACPI _PSS objects found.\n"
> 
> Don't break these, even if they cross 80 columns.
> 

Thanks for your review!

Stratos

