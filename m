Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbbANROX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:14:23 -0500
Received: from mga03.intel.com ([134.134.136.65]:30965 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbbANROV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:14:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,757,1413270000"; 
   d="scan'208";a="651096084"
From: "Baluta, Teodora" <teodora.baluta@intel.com>
To: "jic23@kernel.org" <jic23@kernel.org>
CC: "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 0/3] Introduce IIO interface for fingerprint sensors
Thread-Topic: [RFC PATCH 0/3] Introduce IIO interface for fingerprint sensors
Thread-Index: AQHQD8JdQ+QdbPbvv0iTNHDhYqBWSZyAQyGAgAV+ygCAD+Q9AIAMNCWAgB5BKgA=
Date: Wed, 14 Jan 2015 17:14:03 +0000
Message-ID: <1421255642.31900.4.camel@bebop>
References: <1417698017-13835-1-git-send-email-teodora.baluta@intel.com>
		 <5481153B.4070609@kernel.org> <1418047828.18463.10.camel@bebop>
	 <54930604.1020607@metafoo.de> <549D42BD.1050901@kernel.org>
In-Reply-To: <549D42BD.1050901@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.104.145]
Content-Type: text/plain; charset="utf-8"
Content-ID: <72D3A169C557E14C9F5AE70074BADA08@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0EHKBVJ008277

On Vi, 2014-12-26 at 11:13 +0000, Jonathan Cameron wrote:
> On 18/12/14 16:51, Lars-Peter Clausen wrote:
> > Adding V4L folks to Cc for more input.
> Thanks Lars - we definitely would need the v4l guys to agree to a driver like
> this going in IIO. (not that I'm convinced it should!)
> > 
> > On 12/08/2014 03:10 PM, Baluta, Teodora wrote:
> >> Hello,
> >>
> >> On Vi, 2014-12-05 at 02:15 +0000, Jonathan Cameron wrote:
> >>> On 04/12/14 13:00, Teodora Baluta wrote:
> >>>> This patchset adds support for fingerprint sensors through the IIO interface.
> >>>> This way userspace applications collect information in a uniform way. All
> >>>> processing would be done in the upper layers as suggested in [0].
> >>>>
> >>>> In order to test out this proposal, a minimal implementation for UPEK's
> >>>> TouchChip Fingerprint Sensor via USB is also available. Although there is an
> >>>> existing implementation in userspace for USB fingerprint devices, including this
> >>>> particular device, the driver represents a proof of concept of how fingerprint
> >>>> sensors could be integrated in the IIO framework regardless of the used bus. For
> >>>> lower power requirements, the SPI bus is preferred and a kernel driver
> >>>> implementation makes more sense.
> >>>
> >>> So why not v4l?  These are effectively image sensors..
> >>
> >> Well, here's why I don't think v4l would be the best option:
> >>
> >> - an image scanner could be implemented in the v4l subsystem, but it
> >> seems far more complicated for a simple fingerprint scanner - it usually
> >> has drivers for webcams, TVs or video streaming devices. The v4l
> >> subsystem (with all its support for colorspace, decoders, image
> >> compression, frame control) seems a bit of an overkill for a very
> >> straightforward fingerprint imaging sensor.
> Whilst those are there, I would doubt the irrelevant bits would put much
> burden on a fingerprint scanning driver.  Been a while since I did
> anything in that area though so I could be wrong!
> >>
> >> - a fingerprint device could also send out a processed information, not
> >> just the image of a fingerprint. This means that the processing is done
> >> in hardware - the UPEK TouchStrip chipset in libfprint has this behavior
> >> (see [0]). So, the IIO framework would support a uniform way of handling
> >> fingerprint devices that either do processing in software or in
> >> hardware.
> This is more interesting, but does that map well to IIO style
> channels anyway?  If not we are going to end up with a whole new
> interface which ever subsystem is used for the image side of things.
> >>
> >> The way I see it now, for processed fingerprint information, an IIO
> >> device could have an IIO_FINGERPRINT channel with a modifier and only
> >> the sensitivity threshold attribute set. We would also need two
> >> triggers: one for enrollment and one for the verification mode to
> >> control the device from a userspace application.
> Sure - what you proposed would work.  The question is whether it is
> the best way to do it.

Any thoughts on this from the v4l community?

Thanks,
Teodora

> 
> 
> >>
> >> Thanks,
> >> Teodora
> >>
> >> [0] http://www.freedesktop.org/wiki/Software/fprint/libfprint/upekts/
> >>
> >>
> >>>>
> >>>> A sysfs trigger is enabled and the device starts scanning. As soon as an image
> >>>> is available it is written in the character device /dev/iio:deviceX.
> >>>>
> >>>> Userspace applications will be able to calculate the expected image size using
> >>>> the fingerprint attributes height, width and bit depth. Other attributes
> >>>> introduced for the fingerprint channel in IIO represent information that aids in
> >>>> the fingerprint image processing. Besides these, the proposed interface offers
> >>>> userspace a way to read a feedback after a scan (like the swipe was too slow or
> >>>> too fast) through a modified fingerprint_status channel.
> >>>>
> >>>> [0] http://www.spinics.net/lists/linux-iio/msg11463.html
> >>>>
> >>>> Teodora Baluta (3):
> >>>>    iio: core: add support for fingerprint devices
> >>>>    iio: core: change channel's storagebits/realbits to u32
> >>>>    iio: fingerprint: add fingerprint sensor via USB
> >>>>
> >>>>   Documentation/ABI/testing/sysfs-bus-iio |  51 +++
> >>>>   drivers/iio/Kconfig                     |   1 +
> >>>>   drivers/iio/Makefile                    |   1 +
> >>>>   drivers/iio/fingerprint/Kconfig         |  15 +
> >>>>   drivers/iio/fingerprint/Makefile        |   5 +
> >>>>   drivers/iio/fingerprint/fp_tc.c         | 162 +++++++++
> >>>>   drivers/iio/fingerprint/fp_tc.h         |  22 ++
> >>>>   drivers/iio/fingerprint/fp_tc_usb.c     | 618 ++++++++++++++++++++++++++++++++
> >>>>   drivers/iio/fingerprint/fp_tc_usb.h     | 144 ++++++++
> >>>>   drivers/iio/industrialio-core.c         |   9 +
> >>>>   include/linux/iio/iio.h                 |  11 +-
> >>>>   include/linux/iio/types.h               |  10 +
> >>>>   12 files changed, 1047 insertions(+), 2 deletions(-)
> >>>>   create mode 100644 drivers/iio/fingerprint/Kconfig
> >>>>   create mode 100644 drivers/iio/fingerprint/Makefile
> >>>>   create mode 100644 drivers/iio/fingerprint/fp_tc.c
> >>>>   create mode 100644 drivers/iio/fingerprint/fp_tc.h
> >>>>   create mode 100644 drivers/iio/fingerprint/fp_tc_usb.c
> >>>>   create mode 100644 drivers/iio/fingerprint/fp_tc_usb.h
> >>>>
> >>>
> >>
> >> Nï¿½ï¿½ï¿½ï¿½ï¿½rï¿½ï¿½yï¿½ï¿½ï¿½bï¿½Xï¿½ï¿½Ç§vï¿½^ï¿½)Şº{.nï¿½+ï¿½ï¿½ï¿½ï¿½{ï¿½ï¿½*"ï¿½ï¿½^nï¿½rï¿½ï¿½ï¿½zï¿½ï¿½ï¿½hï¿½ï¿½ï¿½ï¿½&ï¿½ï¿½ï¿½Gï¿½ï¿½ï¿½hï¿½(ï¿½éšï¿½İ¢j"ï¿½ï¿½ï¿½mï¿½ï¿½ï¿½ï¿½ï¿½zï¿½Ş–ï¿½ï¿½ï¿½fï¿½ï¿½ï¿½hï¿½ï¿½ï¿½~ï¿½mml==
> >>
> > 
> > -- 
> > To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
