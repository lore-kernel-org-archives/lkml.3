Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3GWHww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:52:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:25077 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab3GWHwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:52:50 -0400
X-IronPort-AV: E=Sophos;i="4.89,725,1367942400"; 
   d="scan'208";a="7989341"
Message-ID: <51EE36F3.2010308@cn.fujitsu.com>
Date: Tue, 23 Jul 2013 15:55:31 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86, acpi: Fix wrong checking condition in acpi_register_lapic().
References: <1374543541-4451-1-git-send-email-tangchen@cn.fujitsu.com> <20130723073950.GB13710@gmail.com>
In-Reply-To: <20130723073950.GB13710@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/23 15:50:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/23 15:50:47,
	Serialize complete at 2013/07/23 15:50:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 03:39 PM, Ingo Molnar wrote:
>
> * Tang Chen<tangchen@cn.fujitsu.com>  wrote:
>
>> We wanted to check if the acpi id is out of range. It should be:
>> 	if (id>= (MAX_LOCAL_APIC)).
>
> Does this have any practical impact, or can it wait until v3.12?

I haven't tested out any impact now, just found it when reading the code.
We can wait until v3.12.

>
>> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
>> ---
>>   arch/x86/kernel/acpi/boot.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
>> index d81a972..2a15ae7 100644
>> --- a/arch/x86/kernel/acpi/boot.c
>> +++ b/arch/x86/kernel/acpi/boot.c
>> @@ -199,7 +199,7 @@ static void __cpuinit acpi_register_lapic(int id, u8 enabled)
>>   {
>>   	unsigned int ver = 0;
>>
>> -	if (id>= (MAX_LOCAL_APIC-1)) {
>> +	if (id>= (MAX_LOCAL_APIC)) {
>
> The parentheses are now superfluous.

Oh, yes. I'll send a new version without the parentheses.

Thanks.

