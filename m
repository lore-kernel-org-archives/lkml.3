Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaLRQv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:51:27 -0500
Received: from smtp-out-208.synserver.de ([212.40.185.208]:1065 "EHLO
	smtp-out-208.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaLRQvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:51:25 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 20595
Message-ID: <54930604.1020607@metafoo.de>
Date: Thu, 18 Dec 2014 17:51:16 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: "Baluta, Teodora" <teodora.baluta@intel.com>,
        "jic23@kernel.org" <jic23@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Introduce IIO interface for fingerprint sensors
References: <1417698017-13835-1-git-send-email-teodora.baluta@intel.com>	 <5481153B.4070609@kernel.org> <1418047828.18463.10.camel@bebop>
In-Reply-To: <1418047828.18463.10.camel@bebop>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding V4L folks to Cc for more input.

On 12/08/2014 03:10 PM, Baluta, Teodora wrote:
> Hello,
>
> On Vi, 2014-12-05 at 02:15 +0000, Jonathan Cameron wrote:
>> On 04/12/14 13:00, Teodora Baluta wrote:
>>> This patchset adds support for fingerprint sensors through the IIO interface.
>>> This way userspace applications collect information in a uniform way. All
>>> processing would be done in the upper layers as suggested in [0].
>>>
>>> In order to test out this proposal, a minimal implementation for UPEK's
>>> TouchChip Fingerprint Sensor via USB is also available. Although there is an
>>> existing implementation in userspace for USB fingerprint devices, including this
>>> particular device, the driver represents a proof of concept of how fingerprint
>>> sensors could be integrated in the IIO framework regardless of the used bus. For
>>> lower power requirements, the SPI bus is preferred and a kernel driver
>>> implementation makes more sense.
>>
>> So why not v4l?  These are effectively image sensors..
>
> Well, here's why I don't think v4l would be the best option:
>
> - an image scanner could be implemented in the v4l subsystem, but it
> seems far more complicated for a simple fingerprint scanner - it usually
> has drivers for webcams, TVs or video streaming devices. The v4l
> subsystem (with all its support for colorspace, decoders, image
> compression, frame control) seems a bit of an overkill for a very
> straightforward fingerprint imaging sensor.
>
> - a fingerprint device could also send out a processed information, not
> just the image of a fingerprint. This means that the processing is done
> in hardware - the UPEK TouchStrip chipset in libfprint has this behavior
> (see [0]). So, the IIO framework would support a uniform way of handling
> fingerprint devices that either do processing in software or in
> hardware.
>
> The way I see it now, for processed fingerprint information, an IIO
> device could have an IIO_FINGERPRINT channel with a modifier and only
> the sensitivity threshold attribute set. We would also need two
> triggers: one for enrollment and one for the verification mode to
> control the device from a userspace application.
>
> Thanks,
> Teodora
>
> [0] http://www.freedesktop.org/wiki/Software/fprint/libfprint/upekts/
>
>
>>>
>>> A sysfs trigger is enabled and the device starts scanning. As soon as an image
>>> is available it is written in the character device /dev/iio:deviceX.
>>>
>>> Userspace applications will be able to calculate the expected image size using
>>> the fingerprint attributes height, width and bit depth. Other attributes
>>> introduced for the fingerprint channel in IIO represent information that aids in
>>> the fingerprint image processing. Besides these, the proposed interface offers
>>> userspace a way to read a feedback after a scan (like the swipe was too slow or
>>> too fast) through a modified fingerprint_status channel.
>>>
>>> [0] http://www.spinics.net/lists/linux-iio/msg11463.html
>>>
>>> Teodora Baluta (3):
>>>    iio: core: add support for fingerprint devices
>>>    iio: core: change channel's storagebits/realbits to u32
>>>    iio: fingerprint: add fingerprint sensor via USB
>>>
>>>   Documentation/ABI/testing/sysfs-bus-iio |  51 +++
>>>   drivers/iio/Kconfig                     |   1 +
>>>   drivers/iio/Makefile                    |   1 +
>>>   drivers/iio/fingerprint/Kconfig         |  15 +
>>>   drivers/iio/fingerprint/Makefile        |   5 +
>>>   drivers/iio/fingerprint/fp_tc.c         | 162 +++++++++
>>>   drivers/iio/fingerprint/fp_tc.h         |  22 ++
>>>   drivers/iio/fingerprint/fp_tc_usb.c     | 618 ++++++++++++++++++++++++++++++++
>>>   drivers/iio/fingerprint/fp_tc_usb.h     | 144 ++++++++
>>>   drivers/iio/industrialio-core.c         |   9 +
>>>   include/linux/iio/iio.h                 |  11 +-
>>>   include/linux/iio/types.h               |  10 +
>>>   12 files changed, 1047 insertions(+), 2 deletions(-)
>>>   create mode 100644 drivers/iio/fingerprint/Kconfig
>>>   create mode 100644 drivers/iio/fingerprint/Makefile
>>>   create mode 100644 drivers/iio/fingerprint/fp_tc.c
>>>   create mode 100644 drivers/iio/fingerprint/fp_tc.h
>>>   create mode 100644 drivers/iio/fingerprint/fp_tc_usb.c
>>>   create mode 100644 drivers/iio/fingerprint/fp_tc_usb.h
>>>
>>
>
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{��*"��^n�r���z���h����&���G���h�(�階�ݢj"���m�����z�ޖ���f���h���~�mml==
>

