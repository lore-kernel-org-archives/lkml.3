Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbbAORiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:38:05 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15860 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbbAORiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:38:01 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-7c-54b7faf6f529
Message-id: <54B7FAF2.8080207@samsung.com>
Date: Thu, 15 Jan 2015 18:37:54 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: "Baluta, Teodora" <teodora.baluta@intel.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-iio <linux-iio@vger.kernel.org>,
        LMML <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 0/3] Introduce IIO interface for fingerprint sensors
References: <1417698017-13835-1-git-send-email-teodora.baluta@intel.com>
 <5481153B.4070609@kernel.org> <1418047828.18463.10.camel@bebop>
 <54930604.1020607@metafoo.de> <549D42BD.1050901@kernel.org>
 <1421255642.31900.4.camel@bebop>
In-reply-to: <1421255642.31900.4.camel@bebop>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xK7rffm0PMZiwQdHi1ORnTBYPmlYx
	WSyZPJ/VYt6RdywWl3fNYbPo2bCV1eLiOnmLs2duMDlweCze85LJY9OqTjaPJW8OsXr0bVnF
	6PF5k5zHqa+f2QPYorhsUlJzMstSi/TtErgyJj58x1jwSbPizsryBsbZSl2MHBwSAiYSb+bX
	dzFyApliEhfurWfrYuTiEBJYyijxuPsIE4TziVFiz/RjzCBVvAJaEssbzzOC2CwCqhIdr6+z
	g9hsAoYSvUf7wOKiAhESJ+/uYYeoF5T4MfkeC4gtIhAusWfTQ7ANzAJtTBIX9pwCKxIW8JHY
	f+k1C8S214wS7a3NYJM4BXQlru9fww5yKrOAusSUKbkgYWYBeYnNa94yT2AUmIVkxyyEqllI
	qhYwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAn6LzsYFx+zOsQowMGoxMPL4Lc9RIg1
	say4MvcQowQHs5IIb9QjoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbG6ROvld30d5GQL8htDb33
	ZN1FZY7VaocXVe/aWxXc11bSI9h/se/2VqH2R6k7eL26OjTnZ3IfjSo6bHpZLOXBqTPbOm/e
	fuBwbKlf1nat10c2Z26ZKB0gtKWjKGzZas08gwm7Ls9wO3a7ZP06GZ/Wp1U5sV/vtpv2JwoU
	XTd8b31zY579on8zlFiKMxINtZiLihMBa/W7llgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/15 18:14, Baluta, Teodora wrote:
> On Vi, 2014-12-26 at 11:13 +0000, Jonathan Cameron wrote:
>> On 18/12/14 16:51, Lars-Peter Clausen wrote:
>>> Adding V4L folks to Cc for more input.
>>
>> Thanks Lars - we definitely would need the v4l guys to agree to a driver like
>> this going in IIO. (not that I'm convinced it should!)
>>
>>> On 12/08/2014 03:10 PM, Baluta, Teodora wrote:
>>>> Hello,
>>>>
>>>> On Vi, 2014-12-05 at 02:15 +0000, Jonathan Cameron wrote:
>>>>> On 04/12/14 13:00, Teodora Baluta wrote:
>>>>>> This patchset adds support for fingerprint sensors through the IIO interface.
>>>>>> This way userspace applications collect information in a uniform way. All
>>>>>> processing would be done in the upper layers as suggested in [0].
>>>>>>
>>>>>> In order to test out this proposal, a minimal implementation for UPEK's
>>>>>> TouchChip Fingerprint Sensor via USB is also available. Although there is an
>>>>>> existing implementation in userspace for USB fingerprint devices, including this
>>>>>> particular device, the driver represents a proof of concept of how fingerprint
>>>>>> sensors could be integrated in the IIO framework regardless of the used bus. For
>>>>>> lower power requirements, the SPI bus is preferred and a kernel driver
>>>>>> implementation makes more sense.
>>>>>
>>>>> So why not v4l?  These are effectively image sensors..
>>>>
>>>> Well, here's why I don't think v4l would be the best option:
>>>>
>>>> - an image scanner could be implemented in the v4l subsystem, but it
>>>> seems far more complicated for a simple fingerprint scanner - it usually
>>>> has drivers for webcams, TVs or video streaming devices. The v4l
>>>> subsystem (with all its support for colorspace, decoders, image
>>>> compression, frame control) seems a bit of an overkill for a very
>>>> straightforward fingerprint imaging sensor.
>
>> Whilst those are there, I would doubt the irrelevant bits would put much
>> burden on a fingerprint scanning driver.  Been a while since I did
>> anything in that area though so I could be wrong!

IMO V4L is much better fit for this kind of devices than IIO. You can use
just a subset of the API, it shouldn't take much effort to write a simple
v4l2 capture driver, supporting fixed (probably vendor/chip specific) image
format.  I'm not sure if it's better to use the v4l2 controls [1], define
a new v4l2 controls class for the fingerprint scanner processing features,
rather than trying to pass raw data to user space and interpret it then
in some library.  I know there has been resistance to allowing passing
unknown binary blobs to user space, due to possible abuses.

[1] Documentation/video4linux/v4l2-controls.txt

>>>> - a fingerprint device could also send out a processed information, not
>>>> just the image of a fingerprint. This means that the processing is done
>>>> in hardware - the UPEK TouchStrip chipset in libfprint has this behavior
>>>> (see [0]). So, the IIO framework would support a uniform way of handling
>>>> fingerprint devices that either do processing in software or in
>>>> hardware.

You can use the v4l2 controls API for that, which also supports events.
The controls could be made read only.
It would be interesting to list what kind of features these could be.

>> This is more interesting, but does that map well to IIO style
>> channels anyway?  If not we are going to end up with a whole new
>> interface which ever subsystem is used for the image side of things.
>>>>
>>>> The way I see it now, for processed fingerprint information, an IIO
>>>> device could have an IIO_FINGERPRINT channel with a modifier and only
>>>> the sensitivity threshold attribute set. We would also need two
>>>> triggers: one for enrollment and one for the verification mode to
>>>> control the device from a userspace application.

This could be all well handled with the v4l2 controls, for instance see
what features are available in the Camera Flash controls subset

http://linuxtv.org/downloads/v4l-dvb-apis/extended-controls.html#flash-controls

>> Sure - what you proposed would work.  The question is whether it is
>> the best way to do it.
> 
> Any thoughts on this from the v4l community?

I would try it with V4L2, it seems to me most suitable subsystem for such
devices to me.  The question is what ends up in the kernel and what in user
space.  Anyway IMO V4L2 API is quite flexible with regards to that, due to
wide range of devices it needs to cover.

>>>> [0] http://www.freedesktop.org/wiki/Software/fprint/libfprint/upekts/
>>>>
>>>>>> A sysfs trigger is enabled and the device starts scanning. As soon as an image
>>>>>> is available it is written in the character device /dev/iio:deviceX.
>>>>>>
>>>>>> Userspace applications will be able to calculate the expected image size using
>>>>>> the fingerprint attributes height, width and bit depth. Other attributes
>>>>>> introduced for the fingerprint channel in IIO represent information that aids in
>>>>>> the fingerprint image processing. Besides these, the proposed interface offers
>>>>>> userspace a way to read a feedback after a scan (like the swipe was too slow or
>>>>>> too fast) through a modified fingerprint_status channel.
>>>>>>
>>>>>> [0] http://www.spinics.net/lists/linux-iio/msg11463.html

