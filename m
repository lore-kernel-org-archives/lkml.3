Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3GJXCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 19:02:50 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:62634 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab3GJXCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 19:02:48 -0400
X-AuditID: cbfec37d-b7f036d000004805-17-51dde816cb8e
From: Shuah Khan <shuah.kh@samsung.com>
To: =?iso-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
Cc: "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "key@linux.vnet.ibm.com" <key@linux.vnet.ibm.com>,
        "mail@srajiv.net" <mail@srajiv.net>,
        "tpmdd@selhorst.net" <tpmdd@selhorst.net>,
        "tpmdd@sirrix.com" <tpmdd@sirrix.com>,
        "matthew.garrett@nebula.com" <matthew.garrett@nebula.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [tpmdd-devel] [PATCH 3/4] tpm: Convert tpm_tis driver to use
 dev_pm_ops from legacy pm_ops
Thread-topic: [tpmdd-devel] [PATCH 3/4] tpm: Convert tpm_tis driver to use
 dev_pm_ops from legacy pm_ops
Thread-index: AQHOfSNvkGU/clZYN0+5ktv00oxarA==
Date: Wed, 10 Jul 2013 23:02:45 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61738933@sisaex02sj>
References: <1373429409-3944-1-git-send-email-shuah.kh@samsung.com>
 <201307110051.04726.PeterHuewe@gmx.de>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9hP12xF3cDDVb+NrZYcvEqu8WSpgyL
	WRtvsFtc3jWHzeLDooVsFh8/2Vi83feT3WL1nhfMFo9XvGW32N/ZwWjx9aeDRcvvN0wWm/tv
	slr8f/+HxYHPY+esu+weHz7GeSzYVOqxZ+JJNo/Fe14yeTw4tJnFY/eCz0weC680M3k8vpjs
	0XTwDLvHvSMHmTymz/vJ5PF5k1wAbxSXTUpqTmZZapG+XQJXRu/rR8wFL7gres+sZm1gPM/Z
	xcjJISFgItG4Zw0jhC0mceHeejYQW0hgGaPE59PcXYxcQHYvk8T3GYuYIZz5jBLf93cxg1Sx
	CahLfH69g72LkYNDRMBU4ka/HUgNs8A3VolvHa/BJgkLZErM/P4eqiZL4kB7DUhYREBPYs29
	Z0wgNouAqsSSJzvAjuAVsJeYevs41BE5EpsftILFGYGO+35qDVg9s4C4RHPrTRaIowUkluw5
	zwxhi0q8fPyPFWSVhICixPbVVhDlOhK9378xQ9jaEk/eXWCFWCUo8WPyPZYJjGKzkEydhaRl
	FpKWWUhaFjCyrGIUKy1OLihOSk+tMNErTswtLs1L10vOz93ECEkLtTsY73+1OcQowMGoxMOr
	EXs3UIg1say4MvcQowQHs5II78kpQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MinfaFP/VM80v
	kAvflzF3IsvyA5OcI284vVB699bwREnw0UTjkNxVuo8lw6UZww4umXBNdZ5owrJCrZqpNzc7
	R79nzDHTip/aWbdLTSguxuiuOwND9aVXW0rnbXvgvfnZhnitz/dzjd/JR3r88o/XlDb6+OTb
	Qw2XLy9yfmg+nDBB9PBbRnUxJZbijERDLeai4kQAtDc4FukCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 04:43 PM, Peter Hüwe wrote:
> Hi,
>
> thanks for your patch
>>   static struct pnp_device_id tpm_pnp_tbl[] = {
>>   	{"PNP0C31", 0},		/* TPM */
>>   	{"ATM1200", 0},		/* Atmel */
>> @@ -835,9 +834,12 @@ static struct pnp_driver tis_pnp_driver = {
>>   	.name = "tpm_tis",
>>   	.id_table = tpm_pnp_tbl,
>>   	.probe = tpm_tis_pnp_init,
>> -	.suspend = tpm_tis_pnp_suspend,
>> -	.resume = tpm_tis_pnp_resume,
>>   	.remove = tpm_tis_pnp_remove,
>> +#ifdef CONFIG_PM_SLEEP
>> +	.driver	= {
>> +		.pm = &tpm_tis_pm,
>> +	},
>> +#endif
>>   };
>
>
> I don't think the #if CONFIG_PM_SLEEP is required here.
>
> Thanks,
> Peter
>

tpm_tis_resume() is defined originally in CONFIG_PM_SLEEP scope. I can 
make the change to have tpm_tis_resume() not be in CONFIG_PM_SLEEP scope 
and remove this CONFIG_PM_SLEEP when defining .pm. That does make sense 
looking at tpm_pm_suspend() and tpm_pm_resume() which are defined 
without CONFIG_PM_SLEEP scope. Sounds like the right approach? I will 
redo the patch and send v2.

I find that the use of CONFIG_PM, CONFIG_PM_SLEEP, and CONFIG_PM_RUNTIME 
are not very consistent. :)

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
