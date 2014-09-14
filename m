Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaINOO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 10:14:26 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:54609 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaINOOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 10:14:24 -0400
Message-ID: <5415A2BE.7060405@kernel.org>
Date: Sun, 14 Sep 2014 15:14:22 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Octavian Purdila <tavi.purdila@gmail.com>,
        Karol Wrona <k.wrona@samsung.com>
CC: linux-iio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 0/6] iio: Add sensorhub driver
References: <1409756150-30889-1-git-send-email-k.wrona@samsung.com>	<476dc5c4-557d-467c-9583-201b10b7e1df@email.android.com>	<540DC356.5040907@samsung.com> <CAMoF9u1+6b_3So7hLQ9iLCeFye5nggJvganGdqpeNmvu+5HqPQ@mail.gmail.com>
In-Reply-To: <CAMoF9u1+6b_3So7hLQ9iLCeFye5nggJvganGdqpeNmvu+5HqPQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/14 12:05, Octavian Purdila wrote:
> On Mon, Sep 8, 2014 at 5:55 PM, Karol Wrona <k.wrona@samsung.com> wrote:
>> On 09/03/2014 09:52 PM, Jonathan Cameron wrote:
>>>
>>>
>>> On September 3, 2014 3:55:44 PM GMT+01:00, Karol Wrona
>>> <k.wrona@samsung.com> wrote:
>>>>
>>>> Hello,
>>>>
>>>> This patchset adds support for sensorhub. It is an external mcu which
>>>> manages
>>>> and collects data from several sensors i.e. on Galaxy Gear 2 watch.
>>>>
>>>> It contains:
>>>> - spi driver for sensorhub device
>>>> - DT binding for the device
>>>> - IIO common utils for ssp sensors, a trigger module
>>>> - IIO accelerometer driver
>>>> - IIO gyroscope driver
>>>>
>>>> Generally this is an attempt to generalize sensors handling on some
>>>> Samsung
>>>> boards which have multiple sensors IC and also sensorhub does some data
>>>> processing itself.
>>>>
>>>> I would like to get your opinion about such solution. The idea is that
>>>> data communication layer gives control and data to proper IIO sensor
>>>> devices.
>>>> In this case I chose that sensor drivers are platform ones represented
>>>> by
>>>> child nodes of sensorhub in DT. These compatibles are used mainly to
>>>> match
>>>> sensor to driver. For example at this stage there is one accelerometer
>>>> but on
>>>> other board can have different one with changed data format etc. In
>>>> this case
>>>> ssp_accel_sensor driver could handle several physical devices of accel
>>>> class.
>>>> Unfortunately the firmware gives only an information about used sensor
>>>> type,
>>>> the driver can find out that there is an accelerometer on board but
>>>> nothing
>>>> specific about the sensor.
>>>
>>> Will look at this later... In the meantime..
>>
>> Before code review I want to know your opinion if passing information
>> about sensors in that way is ok - It's a hack but currently the firmware
>> do not provide such information and I do not know if I will be able to
>> change it.
>>>>
>>>> Other question:
>>>> The sensorhub can implement some devices which are non common for IIO
>>>> and hard
>>>> to standardise. These ones need two way communication (raw write will
>>>> not be
>>>> proper for that) and can produce data packets with flexible size to
>>>> 2KB).
>>>> I'm wondering if it is worth to look for solution in IIO and implement
>>>> something like IIO_BULK sensor with no standard channel description
>>>> or solve this problem using cdev. This is the reason why the part of
>>>> the
>>>> patchset is intended to be placed in misc.
>>>
>>> Out of curiosity, what are these other sensors, roughly?  If they are
>>> popular I am
>>>   sure there will be more out there soon!  Ideally we would work out how
>>> to standardize these. So convince is it can't be
>>>   done!
>>
>> These are very specific for Galaxy Gear watch like movement detector,
>> pedometer,
>> put down motion etc. The functionalities are mainly implemented by sensorhub
>> firmware, these ones are not physical chips. My first idea was to use IIO
>> for typical
>> sensors only (I can have there a bunch of thermometers, accelerometers,
>> lightsensors ...)
>> and one cdev for others. In this case data interpretation would be done by
>> userspace.
>> So:
>> - these specific "sensors" will be only implemented on some Samsung's boards
>> and depend on firmware.
>> - there will be a lot of it  - most of them are represented by an integer
>> value but there
>> are some which can send much more data.
>>
>>
> 
> Hi Karol,
> 
> With the addition of new sensor types in Android (pedometer,
> significant motion) and probably more to come in L-dessert, and with
> the proliferation of sensor hub solutions, I am sure that we are going
> to see more of these types of sensors coming.
> 
> With that in mind, I think it is worth trying to standardize the new
> sensors at the kernel level. Having the data interpretation done in
> userspace is going to make it hard to write portable application
> across different sensors.
I absolutely agree on this.  We may well need to extend IIO in new directions
to do it, but we need a consistent interface for these signal types.
(might take us a little while to pin down what it is however! Best get
started :)

Jonathan
> 
