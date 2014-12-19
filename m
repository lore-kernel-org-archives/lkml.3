Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaLSTds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 14:33:48 -0500
Received: from mail-bl2on0103.outbound.protection.outlook.com ([65.55.169.103]:2128
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751279AbaLSTdq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 14:33:46 -0500
X-WSS-ID: 0NGUH00-08-JEE-02
X-M-MSG: 
Message-ID: <54947D88.90306@amd.com>
Date: Fri, 19 Dec 2014 13:33:28 -0600
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>, <rjw@rjwysocki.net>, <lenb@kernel.org>,
        <hdegoede@redhat.com>, <tj@kernel.org>, <arnd@arndb.de>,
        <mjg59@srcf.ucam.org>
CC: <leo.duran@amd.com>, <graeme.gregory@linaro.org>,
        <linux-ide@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-acpi@lists.linaro.org>
Subject: Re: [RFC PATCH 1/2] ACPI / scan: Add support for ACPI _CLS device
 matching
References: <1418858195-22857-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1418858195-22857-2-git-send-email-suravee.suthikulpanit@amd.com>
 <54943CB5.2030206@linaro.org> <549472C6.9090908@amd.com>
In-Reply-To: <549472C6.9090908@amd.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(57704003)(189002)(51704005)(377454003)(479174004)(24454002)(51914003)(199003)(164054003)(76176999)(65816999)(50986999)(83506001)(106466001)(46102003)(86362001)(105586002)(120886001)(77156002)(33656002)(99396003)(62966003)(84676001)(120916001)(54356999)(101416001)(87936001)(50466002)(19580395003)(19580405001)(4396001)(64126003)(23676002)(68736005)(65956001)(31966008)(36756003)(2950100001)(20776003)(92566001)(64706001)(2201001)(21056001)(93886004)(77096005)(107046002)(65806001)(97736003)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB193;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR02MB193;
X-Forefront-PRVS: 0430FA5CB7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2014 19:33:42.2855
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB193
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2014 12:47 PM, Suravee Suthikulanit wrote:
> On 12/19/2014 8:56 AM, Hanjun Guo wrote:
>> Hi Suravee,
>>
>> On 2014年12月18日 07:16, Suravee Suthikulpanit wrote:
>>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>>
>>> Device drivers typically use ACPI _HIDs/_CIDs listed in struct
>>> device_driver
>>> acpi_match_table to match devices. However, for generic drivers, we do
>>> not want to list _HID for all supported devices, and some device classes
>>> do not have _CID (e.g. SATA, USB). Instead, we can leverage ACPI _CLS,
>>> which specifies PCI-defined class code (i.e. base-class, subclass and
>>> programming interface).
>>>
>>> This patch adds support for matching ACPI devices using the _CLS method.
>>>
>>> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>> ---
>>>   drivers/acpi/scan.c             | 73
>>> +++++++++++++++++++++++++++++++++++++++++
>>>   include/acpi/acnames.h          |  1 +
>>>   include/linux/acpi.h            | 12 ++++++-
>>>   include/linux/device.h          |  1 +
>>>   include/linux/mod_devicetable.h |  6 ++++
>>>   5 files changed, 92 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
>>> index d670158..6406648 100644
>>> --- a/drivers/acpi/scan.c
>>> +++ b/drivers/acpi/scan.c
>>> @@ -864,6 +864,79 @@ int acpi_match_device_ids(struct acpi_device
>>> *device,
>>>   }
>>>   EXPORT_SYMBOL(acpi_match_device_ids);
>>>
>>> +/**
>>> + * acpi_match_device_cls - Match a struct device against a ACPI _CLS
>>> method
>>> + * @dev_cls: A pointer to struct acpi_device_cls object to match
>>> against.
>>> + * @dev: The ACPI device structure to match.
>>> + *
>>> + * Check if @dev has a valid ACPI and _CLS handle. If there is a
>>> + * struct acpi_device_cls object for that handle, use that object to
>>> match
>>> + * against the given struct acpi_device_cls object.
>>> + *
>>> + * Return 0 on success or error code on failure.
>>> + */
>>> +int acpi_match_device_cls(const struct acpi_device_cls *dev_cls,
>>> +              const struct device *dev)
>>> +{
>>> +    int ret = -EINVAL;
>>> +    acpi_status status;
>>> +    struct acpi_device *adev;
>>> +    union acpi_object *pkg;
>>> +    struct acpi_device_cls cls;
>>> +    struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
>>> +    struct acpi_buffer format = { sizeof("NNN"), "NNN" };
>>> +    struct acpi_buffer state = { 0, NULL };
>>> +    acpi_handle handle = ACPI_HANDLE(dev);
>>
>> ...
>>
>>> +    acpi_handle cls_handle;
>>> +
>>> +    if (!handle || acpi_bus_get_device(handle, &adev))
>>
>> if handle is not NULL, adev will not NULL too :)
>> because you get the handle from adev, ACPI_HANDLE() is defined as:
>> acpi_device_handle(ACPI_COMPANION(dev)), and adev = ACPI_COMPANION(dev);
>>
>> you may use adev = ACPI_COMPANION(dev) to simplify the code.
>>

Thanks for the pointer.

>>> +        return ret;
>>> +
>>> +    if (!adev->status.present || !dev_cls)
>>> +        return ret;
>>> +
>>> +    status = acpi_get_handle(adev->handle, METHOD_NAME__CLS,
>>> &cls_handle);
>>
>> do we need this function called here? _CLS is the method under ACPI
>> device object in DSDT/SSDT, and you will get adev->handle == cls_handle
>> if I'm not wrong :)

You are right. It is not needed, and we can just evaluate right from the 
handle.

>>> +    if (ACPI_FAILURE(status))
>>> +        return ret;
>>> +
>>> +    status = acpi_evaluate_object(cls_handle, "_CLS", NULL, &buffer);
>>> +    if (ACPI_FAILURE(status)) {
>>> +        ACPI_EXCEPTION((AE_INFO, status, "Failed to Evaluat _CLS"));
>>> +        return ret;
>>> +    }
>>
>> I think you can evaluate _CLS directly with handle here.
>>
>> Thanks
>> Hanjun
>

Yep. I will send out the new patch in a bit.

Thanks,

Suravee




