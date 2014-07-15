Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbaGOSOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:14:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:45330 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbaGOSOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:14:42 -0400
Message-ID: <53C5701A.6000507@kernel.org>
Date: Tue, 15 Jul 2014 19:16:58 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Reyad Attiyat <reyad.attiyat@gmail.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/4] iio: Add support for rotation from north
References: <1404934213-2733-1-git-send-email-reyad.attiyat@gmail.com> <53BD9BD5.5030204@linux.intel.com> <CA+BWVUSLtG9pH245ofyGsrST5H_5W_EbvOXZ_YkCxmg4DX09_A@mail.gmail.com>
In-Reply-To: <CA+BWVUSLtG9pH245ofyGsrST5H_5W_EbvOXZ_YkCxmg4DX09_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/14 23:12, Reyad Attiyat wrote:
> Hey Srinivas,
>
> I did look into the panic you sent. I wasn't sure exactly what caused
> the NULL pointer.
> I tested it with out applying the last rotation from north patch, so
> no hid usages are found, my device only has rotation_from_north, and
> hid_parse_report() would return -EINVAL.
> I added another check to make sure a iio channel were set up, and
> return -EINVAL if not, but couldn't think of anything else.
>
> Could you test this version with dynamic debugging and see if it is
> finding any hid usage attributes.
> Any ideas what could cause this? I think I'm handling errors properly
> by returning what parse_report returns (-EINVAL or -ENOMEM) in probe
>
> Thanks,
> Reyad Attiyat
Just to confirm what you may suspect...  I'm holding this series until
Srinivas and Reyad have confirmed the cause of Srinivas' panic.

Jonathan
>
> On Wed, Jul 9, 2014 at 2:45 PM, Srinivas Pandruvada
> <srinivas.pandruvada@linux.intel.com> wrote:
>> On 07/09/2014 12:30 PM, Reyad Attiyat wrote:
>>>
>>> This series of patches modifies magn-3d driver to handle the rotation
>>> from north usage. This is done by scanning the report and then building
>>> the iio arrays (vals and channels) dynamically.
>>>
>>> Changes from V4
>>> I use the address field of struct iio_chan_spec to hold the array index
>>> of the usage attribute. The scan_index field is generated when creating
>>> an iio channel.
>>>
>>> Reyad Attiyat (4):
>>>     iio: Documentation: Add documentation for rotation from north sensor
>>>       usage attributes
>>>     iio: types: Added support for rotation from north usage attributes
>>>     iio: hid-sensor-magn-3d: Scan for usage attributes before setting up
>>>       iio channels
>>>     iio: hid-sensor-magn-3d: Add support for rotation from north
>>>
>>>    Documentation/ABI/testing/sysfs-bus-iio       |  82 +++++++++++
>>>    drivers/iio/industrialio-core.c               |   4 +
>>>    drivers/iio/magnetometer/hid-sensor-magn-3d.c | 199
>>> ++++++++++++++++++++------
>>>    include/linux/iio/types.h                     |   4 +
>>>    4 files changed, 245 insertions(+), 44 deletions(-)
>>>
>> Did you get chance to look at the cause of panic?
>>
>> Thanks,
>> Srinivas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

