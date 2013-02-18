Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3BRLk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 06:40:26 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:59471 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3BRLiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 06:38:06 -0500
Message-ID: <51221290.1040005@ahsoftware.de>
Date: Mon, 18 Feb 2013 12:37:52 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, srinivas.pandruvada@intel.com
Subject: Re: [PATCH 3/3] HID: sensor-hub: don't limit the driver only to USB
 bus
References: <1360578679-7029-1-git-send-email-mika.westerberg@linux.intel.com> <1360578679-7029-3-git-send-email-mika.westerberg@linux.intel.com> <51220A68.9030608@ahsoftware.de> <20130218111217.GL20771@intel.com> <51220F12.2060908@ahsoftware.de> <20130218113320.GA2338@intel.com>
In-Reply-To: <20130218113320.GA2338@intel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.02.2013 12:33, schrieb Mika Westerberg:
> On Mon, Feb 18, 2013 at 12:22:58PM +0100, Alexander Holler wrote:
>> Am 18.02.2013 12:12, schrieb Mika Westerberg:
>>> On Mon, Feb 18, 2013 at 12:03:04PM +0100, Alexander Holler wrote:
>>>> Am 11.02.2013 11:31, schrieb Mika Westerberg:
>>>>> We now have two transport mediums: USB and I2C, where sensor hubs can
>>>>> exists. So instead of constraining the driver to only these two we let it
>>>>> to match any HID bus as long as the group is HID_GROUP_SENSOR_HUB.
>>>>>
>>>>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>>>>> ---
>>>>>   drivers/hid/hid-sensor-hub.c |    3 ++-
>>>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
>>>>> index 2643bce9..c01f10d 100644
>>>>> --- a/drivers/hid/hid-sensor-hub.c
>>>>> +++ b/drivers/hid/hid-sensor-hub.c
>>>>> @@ -603,7 +603,8 @@ static void sensor_hub_remove(struct hid_device *hdev)
>>>>>   }
>>>>>
>>>>>   static const struct hid_device_id sensor_hub_devices[] = {
>>>>> -	{ HID_DEVICE(BUS_USB, HID_GROUP_SENSOR_HUB, HID_ANY_ID, HID_ANY_ID) },
>>>>> +	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, HID_ANY_ID,
>>>>> +		     HID_ANY_ID) },
>>>>>   	{ }
>>>>>   };
>>>>>   MODULE_DEVICE_TABLE(hid, sensor_hub_devices);
>>>>>
>>>>
>>>> Hmm, what happens with Bluetooth sensor-hubs? Is the driver now able
>>>> to handle them too?
>>>
>>> It should, yes.
>>
>> If so, I think patch 1/3 should be modified accordingly.
>
> Do you know if such devices exists currently? If not, I'm not sure if it
> makes sense to do that now.

The CC2541DK-SENSOR from TI looks like one. But I'm not sure as I don't 
have one. Besides that, I think Bluetooth (especially with BT4LE) will 
be by far the most used bus for sensors hubs.

Regards,

Alexander
