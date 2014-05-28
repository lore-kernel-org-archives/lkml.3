Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaE1VVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:21:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:5184 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbaE1VU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:20:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,930,1392192000"; 
   d="scan'208";a="519271753"
Message-ID: <53865438.2030901@linux.intel.com>
Date: Wed, 28 May 2014 14:25:12 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Reyad Attiyat <reyad.attiyat@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, jic23@kernel.org,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3/3] IO: hid-sensor-magn-3d: Add in support for True/Magnetic
 North HID usages
References: <1401311175-12784-1-git-send-email-reyad.attiyat@gmail.com> <1401311175-12784-4-git-send-email-reyad.attiyat@gmail.com> <CA+BWVUQEsprV1jEzD9D0hidR0jvYeSRVGT=ESzstR4apa+nV1A@mail.gmail.com>
In-Reply-To: <CA+BWVUQEsprV1jEzD9D0hidR0jvYeSRVGT=ESzstR4apa+nV1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 02:15 PM, Reyad Attiyat wrote:
>> +static void sensor_hub_fill_attr_info(
>> +               struct hid_sensor_hub_attribute_info *info,
>> +               s32 index, s32 report_id, struct hid_field *field)
>> +{
>> +       info->index = index;
>> +       info->report_id = report_id;
>> +       info->units = field->unit;
>> +       info->unit_expo = field->unit_exponent;
>> +       info->size = (field->report_size * field->report_count)/8;
>> +       info->logical_minimum = field->logical_minimum;
>> +       info->logical_maximum = field->logical_maximum;
>>   }
> I copied this function from hid/hid-sensor-hub.c as it is marked
> static in that file. I use it to fill attributes as I find them.
> Should I create an another patch to make it non-static?

I didn't check your implementation. But 
sensor_hub_input_get_attribute_info()
function is not enough? We are already using to get other attributes for 
x, y and Z.

Thanks,
Srinivas


>> +       list_for_each_entry(report, &report_enum->report_list, list) {
>> +               for (i = 0; i < report->maxfield; ++i) {
>> +                       field = report->field[i];
>> +
>> +                       for (j = 0; j < field->maxusage; j++) {
>> +                               usage = &(field->usage[j]);
>> +
> This is how I mange to find all possible hid reports in the parse
> reports function. I noticed that in the other function that was used,
> sensor_hub_input_get_attribute_info(),  it only uses field->usage[0].
> Is there a reason for this and should I change my current
> implementation?
>

