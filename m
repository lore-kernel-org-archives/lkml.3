Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934504AbaDJACa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 20:02:30 -0400
Received: from smtp03.udag.de ([62.146.106.29]:42813 "EHLO smtp03.udag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933480AbaDJAC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 20:02:28 -0400
Message-ID: <5345DF91.5050701@cevel.net>
Date: Thu, 10 Apr 2014 02:02:25 +0200
From: Tolga Cakir <tolga@cevel.net>
Reply-To: tolga@cevel.net
Organization: Cevel Network
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
CC: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Derya <derya.kiran@yahoo.de>, Jiri Kosina <jkosina@suse.cz>,
        Reyad Attiyat <reyad.attiyat@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] HID: microsoft: undefining ms_map_key_clear after
 usage
References: <1396631237-11813-1-git-send-email-tolga@cevel.net> <CAN+gG=HFEcsVdmuf6o2GyfSmjWRansS02MVbXdjws7xVNp1QGw@mail.gmail.com>
In-Reply-To: <CAN+gG=HFEcsVdmuf6o2GyfSmjWRansS02MVbXdjws7xVNp1QGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.04.2014 22:42, schrieb Benjamin Tissoires:
> On Fri, Apr 4, 2014 at 1:07 PM, Tolga Cakir <tolga@cevel.net> wrote:
>> This is inspired by various other hid drivers.
>>
>> Signed-off-by: Tolga Cakir <tolga@cevel.net>
>> ---
>>   drivers/hid/hid-microsoft.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
>> index 5674c0c..5281d2d 100644
>> --- a/drivers/hid/hid-microsoft.c
>> +++ b/drivers/hid/hid-microsoft.c
>> @@ -211,6 +211,8 @@ static int ms_sidewinder_kb_quirk(struct hid_input *hi, struct hid_usage *usage,
>>          return 1;
>>   }
>>
>> +#undef ms_map_key_clear
>> +
> Not sure this is really needed. The macro is prefixed by ms_, so I
> will simply let it there.
>
> Cheers,
> Benjamin
Ouch, I've just rechecked hid-lenovo-tpkbd.c and it wasn't prefixed 
there and therefore
needed. My fault, I'm sorry.

Greetings,
Tolga Cakir
>>   static int ms_sidewinder_control(struct hid_device *hdev, __u8 setup)
>>   {
>>          struct ms_data *sc = hid_get_drvdata(hdev);
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-input" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

