Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbaE1Vfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:35:51 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:46790 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaE1Vft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:35:49 -0400
MIME-Version: 1.0
In-Reply-To: <53865438.2030901@linux.intel.com>
References: <1401311175-12784-1-git-send-email-reyad.attiyat@gmail.com>
 <1401311175-12784-4-git-send-email-reyad.attiyat@gmail.com>
 <CA+BWVUQEsprV1jEzD9D0hidR0jvYeSRVGT=ESzstR4apa+nV1A@mail.gmail.com> <53865438.2030901@linux.intel.com>
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Wed, 28 May 2014 16:35:28 -0500
Message-ID: <CA+BWVUT6tC5nn--zUJ83+FvtQ-AAtZ+CmyUN0bnTEuffpTRD2Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] IO: hid-sensor-magn-3d: Add in support for
 True/Magnetic North HID usages
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, jic23@kernel.org,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Srinivas,

Well I could use sensor_hub_input_get_attribute_info() for each usage
attribute. I was just thinking that since each usage attribute is
found in a row, one for each field I think, it'd be easier to create
iio channels that way. This would eliminate running the for loop
search for usage id each time.

I realize that my parse_report function is quite ugly espically ending
in four closing parenthesis and copying code from
sensor_hub_input_get_attribute_info(). I will change it if you don't
think it will slow down the driver or have any negative effects.

Thanks,
Reyad



On Wed, May 28, 2014 at 4:25 PM, Srinivas Pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
> On 05/28/2014 02:15 PM, Reyad Attiyat wrote:
>>>
>>> +static void sensor_hub_fill_attr_info(
>>> +               struct hid_sensor_hub_attribute_info *info,
>>> +               s32 index, s32 report_id, struct hid_field *field)
>>> +{
>>> +       info->index = index;
>>> +       info->report_id = report_id;
>>> +       info->units = field->unit;
>>> +       info->unit_expo = field->unit_exponent;
>>> +       info->size = (field->report_size * field->report_count)/8;
>>> +       info->logical_minimum = field->logical_minimum;
>>> +       info->logical_maximum = field->logical_maximum;
>>>   }
>>
>> I copied this function from hid/hid-sensor-hub.c as it is marked
>> static in that file. I use it to fill attributes as I find them.
>> Should I create an another patch to make it non-static?
>
>
> I didn't check your implementation. But
> sensor_hub_input_get_attribute_info()
> function is not enough? We are already using to get other attributes for x,
> y and Z.
>
> Thanks,
> Srinivas
>
>
>
>>> +       list_for_each_entry(report, &report_enum->report_list, list) {
>>> +               for (i = 0; i < report->maxfield; ++i) {
>>> +                       field = report->field[i];
>>> +
>>> +                       for (j = 0; j < field->maxusage; j++) {
>>> +                               usage = &(field->usage[j]);
>>> +
>>
>> This is how I mange to find all possible hid reports in the parse
>> reports function. I noticed that in the other function that was used,
>> sensor_hub_input_get_attribute_info(),  it only uses field->usage[0].
>> Is there a reason for this and should I change my current
>> implementation?
>>
>
