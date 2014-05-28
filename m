Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbaE1Vwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:52:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:59609 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbaE1Vwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:52:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,930,1392192000"; 
   d="scan'208";a="519284832"
Message-ID: <53865B83.8030505@linux.intel.com>
Date: Wed, 28 May 2014 14:56:19 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Reyad Attiyat <reyad.attiyat@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, jic23@kernel.org,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3/3] IO: hid-sensor-magn-3d: Add in support for True/Magnetic
 North HID usages
References: <1401311175-12784-1-git-send-email-reyad.attiyat@gmail.com> <1401311175-12784-4-git-send-email-reyad.attiyat@gmail.com> <CA+BWVUQEsprV1jEzD9D0hidR0jvYeSRVGT=ESzstR4apa+nV1A@mail.gmail.com> <53865438.2030901@linux.intel.com> <CA+BWVUT6tC5nn--zUJ83+FvtQ-AAtZ+CmyUN0bnTEuffpTRD2Q@mail.gmail.com>
In-Reply-To: <CA+BWVUT6tC5nn--zUJ83+FvtQ-AAtZ+CmyUN0bnTEuffpTRD2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Reyad,

  On 05/28/2014 02:35 PM, Reyad Attiyat wrote:
> Hey Srinivas,
>
> Well I could use sensor_hub_input_get_attribute_info() for each usage
> attribute. I was just thinking that since each usage attribute is
> found in a row, one for each field I think, it'd be easier to create
> iio channels that way. This would eliminate running the for loop
> search for usage id each time.
It shouldn't be an issue for few more attributes. The idea is that
we don't expose the report level parsing information to the client drivers.
The client shouldn't worry about which collection or report it belongs to.

In this way if we have to enhance the parse function for newer
FW changes or quirks, it is only done at one place. Clients are not
affected at all.

Alternatively
we can enhance API, which takes multiple usage ids and fills information
in a single call. What do you think about this?

Thanks,
Srinivas

>
> I realize that my parse_report function is quite ugly espically ending
> in four closing parenthesis and copying code from
> sensor_hub_input_get_attribute_info(). I will change it if you don't
> think it will slow down the driver or have any negative effects.
>
> Thanks,
> Reyad
>
>
>
> On Wed, May 28, 2014 at 4:25 PM, Srinivas Pandruvada
> <srinivas.pandruvada@linux.intel.com> wrote:
>> On 05/28/2014 02:15 PM, Reyad Attiyat wrote:
>>>> +static void sensor_hub_fill_attr_info(
>>>> +               struct hid_sensor_hub_attribute_info *info,
>>>> +               s32 index, s32 report_id, struct hid_field *field)
>>>> +{
>>>> +       info->index = index;
>>>> +       info->report_id = report_id;
>>>> +       info->units = field->unit;
>>>> +       info->unit_expo = field->unit_exponent;
>>>> +       info->size = (field->report_size * field->report_count)/8;
>>>> +       info->logical_minimum = field->logical_minimum;
>>>> +       info->logical_maximum = field->logical_maximum;
>>>>    }
>>> I copied this function from hid/hid-sensor-hub.c as it is marked
>>> static in that file. I use it to fill attributes as I find them.
>>> Should I create an another patch to make it non-static?
>>
>> I didn't check your implementation. But
>> sensor_hub_input_get_attribute_info()
>> function is not enough? We are already using to get other attributes for x,
>> y and Z.
>>
>> Thanks,
>> Srinivas
>>
>>
>>
>>>> +       list_for_each_entry(report, &report_enum->report_list, list) {
>>>> +               for (i = 0; i < report->maxfield; ++i) {
>>>> +                       field = report->field[i];
>>>> +
>>>> +                       for (j = 0; j < field->maxusage; j++) {
>>>> +                               usage = &(field->usage[j]);
>>>> +
>>> This is how I mange to find all possible hid reports in the parse
>>> reports function. I noticed that in the other function that was used,
>>> sensor_hub_input_get_attribute_info(),  it only uses field->usage[0].
>>> Is there a reason for this and should I change my current
>>> implementation?
>>>

