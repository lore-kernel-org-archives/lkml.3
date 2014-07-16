Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbaGPDiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:38:51 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:54845 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655AbaGPDit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:38:49 -0400
MIME-Version: 1.0
In-Reply-To: <53C59F78.8060009@linux.intel.com>
References: <1404934213-2733-1-git-send-email-reyad.attiyat@gmail.com>
 <53BD9BD5.5030204@linux.intel.com> <CA+BWVUSLtG9pH245ofyGsrST5H_5W_EbvOXZ_YkCxmg4DX09_A@mail.gmail.com>
 <53C59F78.8060009@linux.intel.com>
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Tue, 15 Jul 2014 22:38:27 -0500
Message-ID: <CA+BWVUQWKSKxDqMvGwAzUcnqBotPFkWD=PsjFC3qHpvo_=xYtw@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] iio: Add support for rotation from north
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Srinivas

Thanks for looking into this for me!
I'll fix it up and resubmit soon.

On Tue, Jul 15, 2014 at 4:39 PM, Srinivas Pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
> Hi,
>
> Since you have only one attribute, it is working for you.
> There is a dereference error in *channels.
>
> Check the attached diff, which will fix this.
>
> Thanks,
> Srinivas
>
>
> On 07/09/2014 03:12 PM, Reyad Attiyat wrote:
>>
>> Hey Srinivas,
>>
>> I did look into the panic you sent. I wasn't sure exactly what caused
>> the NULL pointer.
>> I tested it with out applying the last rotation from north patch, so
>> no hid usages are found, my device only has rotation_from_north, and
>> hid_parse_report() would return -EINVAL.
>> I added another check to make sure a iio channel were set up, and
>> return -EINVAL if not, but couldn't think of anything else.
>>
>> Could you test this version with dynamic debugging and see if it is
>> finding any hid usage attributes.
>> Any ideas what could cause this? I think I'm handling errors properly
>> by returning what parse_report returns (-EINVAL or -ENOMEM) in probe
>>
>> Thanks,
>> Reyad Attiyat
>>
>> On Wed, Jul 9, 2014 at 2:45 PM, Srinivas Pandruvada
>> <srinivas.pandruvada@linux.intel.com> wrote:
>>>
>>> On 07/09/2014 12:30 PM, Reyad Attiyat wrote:
>>>>
>>>> This series of patches modifies magn-3d driver to handle the rotation
>>>> from north usage. This is done by scanning the report and then building
>>>> the iio arrays (vals and channels) dynamically.
>>>>
>>>> Changes from V4
>>>> I use the address field of struct iio_chan_spec to hold the array index
>>>> of the usage attribute. The scan_index field is generated when creating
>>>> an iio channel.
>>>>
>>>> Reyad Attiyat (4):
>>>>     iio: Documentation: Add documentation for rotation from north sensor
>>>>       usage attributes
>>>>     iio: types: Added support for rotation from north usage attributes
>>>>     iio: hid-sensor-magn-3d: Scan for usage attributes before setting up
>>>>       iio channels
>>>>     iio: hid-sensor-magn-3d: Add support for rotation from north
>>>>
>>>>    Documentation/ABI/testing/sysfs-bus-iio       |  82 +++++++++++
>>>>    drivers/iio/industrialio-core.c               |   4 +
>>>>    drivers/iio/magnetometer/hid-sensor-magn-3d.c | 199
>>>> ++++++++++++++++++++------
>>>>    include/linux/iio/types.h                     |   4 +
>>>>    4 files changed, 245 insertions(+), 44 deletions(-)
>>>>
>>> Did you get chance to look at the cause of panic?
>>>
>>> Thanks,
>>> Srinivas
>
>
