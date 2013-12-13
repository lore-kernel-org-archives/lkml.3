Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3LMWfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:35:05 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:57625 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3LMWfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:35:01 -0500
Message-ID: <52AB8B91.1020608@tremplin-utc.net>
Date: Fri, 13 Dec 2013 23:34:57 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
CC: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers: platform: Mark functions as static in hp_accel.c
References: <89355c5023baba63de7d1313b3f52818b0fb9202.1386919194.git.rashika.kheria@gmail.com> <20131213085839.GF4386@leaf>
In-Reply-To: <20131213085839.GF4386@leaf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-12-13 09:58, Josh Triplett wrote:
> On Fri, Dec 13, 2013 at 12:56:34PM +0530, Rashika Kheria wrote:
>> This patch marks the functions lis3lv02d_acpi_init(),
>> lis3lv02d_acpi_read() and lis3lv02d_acpi_write() as static in
>> x86/hp_accel.c because they are not used outside this file.
>>
>> Thus, it also eliminates the following warnings in x86/hp_accel.c:
>> drivers/platform/x86/hp_accel.c:91:5: warning: no previous prototype for ‘lis3lv02d_acpi_init’ [-Wmissing-prototypes]
>> drivers/platform/x86/hp_accel.c:109:5: warning: no previous prototype for ‘lis3lv02d_acpi_read’ [-Wmissing-prototypes]
>> drivers/platform/x86/hp_accel.c:132:5: warning: no previous prototype for ‘lis3lv02d_acpi_write’ [-Wmissing-prototypes]
>>
>> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Yes, looks fine.

Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>

Matthew, could you pick this patch up in the platform-driver-x86 branch?

Cheers,
Éric
>
>>   drivers/platform/x86/hp_accel.c |    6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
>> index a8e43cf..01b619e 100644
>> --- a/drivers/platform/x86/hp_accel.c
>> +++ b/drivers/platform/x86/hp_accel.c
>> @@ -88,7 +88,7 @@ MODULE_DEVICE_TABLE(acpi, lis3lv02d_device_ids);
>>    *
>>    * Returns 0 on success.
>>    */
>> -int lis3lv02d_acpi_init(struct lis3lv02d *lis3)
>> +static int lis3lv02d_acpi_init(struct lis3lv02d *lis3)
>>   {
>>   	struct acpi_device *dev = lis3->bus_priv;
>>   	if (acpi_evaluate_object(dev->handle, METHOD_NAME__INI,
>> @@ -106,7 +106,7 @@ int lis3lv02d_acpi_init(struct lis3lv02d *lis3)
>>    *
>>    * Returns 0 on success.
>>    */
>> -int lis3lv02d_acpi_read(struct lis3lv02d *lis3, int reg, u8 *ret)
>> +static int lis3lv02d_acpi_read(struct lis3lv02d *lis3, int reg, u8 *ret)
>>   {
>>   	struct acpi_device *dev = lis3->bus_priv;
>>   	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
>> @@ -129,7 +129,7 @@ int lis3lv02d_acpi_read(struct lis3lv02d *lis3, int reg, u8 *ret)
>>    *
>>    * Returns 0 on success.
>>    */
>> -int lis3lv02d_acpi_write(struct lis3lv02d *lis3, int reg, u8 val)
>> +static int lis3lv02d_acpi_write(struct lis3lv02d *lis3, int reg, u8 val)
>>   {
>>   	struct acpi_device *dev = lis3->bus_priv;
>>   	unsigned long long ret; /* Not used when writting */
>> --
>> 1.7.9.5
>>

