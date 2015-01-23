Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbbAWNFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:05:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:54825 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbbAWNFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:05:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,453,1418112000"; 
   d="scan'208";a="674769305"
From: "Baluta, Teodora" <teodora.baluta@intel.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonathan Cameron <jic23@kernel.org>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-iio <linux-iio@vger.kernel.org>,
        LMML <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: RE: [RFC PATCH 0/3] Introduce IIO interface for fingerprint sensors
Thread-Topic: [RFC PATCH 0/3] Introduce IIO interface for fingerprint sensors
Thread-Index: AQHQD8JdQ+QdbPbvv0iTNHDhYqBWSZyAQyGAgAV+ygCAD+Q9AIAMNCWAgB5BKgCAAZkAAIAMMOIg
Date: Fri, 23 Jan 2015 13:05:28 +0000
Message-ID: <A2E3DE9C026DE6469D89C3A4C6C219390A89FE37@IRSMSX107.ger.corp.intel.com>
References: <1417698017-13835-1-git-send-email-teodora.baluta@intel.com>
 <5481153B.4070609@kernel.org> <1418047828.18463.10.camel@bebop>
 <54930604.1020607@metafoo.de> <549D42BD.1050901@kernel.org>
 <1421255642.31900.4.camel@bebop> <54B7FAF2.8080207@samsung.com>
In-Reply-To: <54B7FAF2.8080207@samsung.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0ND5jeA001570

Hi,

Thanks for the reply, Sylwester! I am considering v4l2 now and I have some questions/comments below.

> -----Original Message-----
> From: linux-iio-owner@vger.kernel.org [mailto:linux-iio-
> owner@vger.kernel.org] On Behalf Of Sylwester Nawrocki
> Sent: Thursday, January 15, 2015 7:38 PM
> To: Baluta, Teodora; Jonathan Cameron
> Cc: Mauro Carvalho Chehab; Lars-Peter Clausen; Linux Kernel Mailing List;
> linux-iio; LMML; Hans Verkuil
> Subject: Re: [RFC PATCH 0/3] Introduce IIO interface for fingerprint sensors
> 
> On 14/01/15 18:14, Baluta, Teodora wrote:
> > On Vi, 2014-12-26 at 11:13 +0000, Jonathan Cameron wrote:
> >> On 18/12/14 16:51, Lars-Peter Clausen wrote:
> >>> Adding V4L folks to Cc for more input.
> >>
> >> Thanks Lars - we definitely would need the v4l guys to agree to a
> >> driver like this going in IIO. (not that I'm convinced it should!)
> >>
> >>> On 12/08/2014 03:10 PM, Baluta, Teodora wrote:
> >>>> Hello,
> >>>>
> >>>> On Vi, 2014-12-05 at 02:15 +0000, Jonathan Cameron wrote:
> >>>>> On 04/12/14 13:00, Teodora Baluta wrote:
> >>>>>> This patchset adds support for fingerprint sensors through the IIO
> interface.
> >>>>>> This way userspace applications collect information in a uniform
> >>>>>> way. All processing would be done in the upper layers as suggested
> in [0].
> >>>>>>
> >>>>>> In order to test out this proposal, a minimal implementation for
> >>>>>> UPEK's TouchChip Fingerprint Sensor via USB is also available.
> >>>>>> Although there is an existing implementation in userspace for USB
> >>>>>> fingerprint devices, including this particular device, the driver
> >>>>>> represents a proof of concept of how fingerprint sensors could be
> >>>>>> integrated in the IIO framework regardless of the used bus. For
> >>>>>> lower power requirements, the SPI bus is preferred and a kernel
> driver implementation makes more sense.
> >>>>>
> >>>>> So why not v4l?  These are effectively image sensors..
> >>>>
> >>>> Well, here's why I don't think v4l would be the best option:
> >>>>
> >>>> - an image scanner could be implemented in the v4l subsystem, but
> >>>> it seems far more complicated for a simple fingerprint scanner - it
> >>>> usually has drivers for webcams, TVs or video streaming devices.
> >>>> The v4l subsystem (with all its support for colorspace, decoders,
> >>>> image compression, frame control) seems a bit of an overkill for a
> >>>> very straightforward fingerprint imaging sensor.
> >
> >> Whilst those are there, I would doubt the irrelevant bits would put
> >> much burden on a fingerprint scanning driver.  Been a while since I
> >> did anything in that area though so I could be wrong!
> 
> IMO V4L is much better fit for this kind of devices than IIO. You can use just a
> subset of the API, it shouldn't take much effort to write a simple
> v4l2 capture driver, supporting fixed (probably vendor/chip specific) image
> format.  I'm not sure if it's better to use the v4l2 controls [1], define a new
> v4l2 controls class for the fingerprint scanner processing features, rather than
> trying to pass raw data to user space and interpret it then in some library.  I
> know there has been resistance to allowing passing unknown binary blobs to
> user space, due to possible abuses.
> 
> [1] Documentation/video4linux/v4l2-controls.txt
>
                                                                                                               
The fingerprint sensor acts more like a scanner device, so the closest type is the V4L2_CAP_VIDEO_CAPTURE. However, this is not a perfect match because the driver only sends an image, once, when triggered. Would it be a better alternative to define a new capability type? Or it would be acceptable to simply have a video device with no frame buffer or frame rate and the user space application to read from the character device /dev/videoX?

> >>>> - a fingerprint device could also send out a processed information,
> >>>> not just the image of a fingerprint. This means that the processing
> >>>> is done in hardware - the UPEK TouchStrip chipset in libfprint has
> >>>> this behavior (see [0]). So, the IIO framework would support a
> >>>> uniform way of handling fingerprint devices that either do
> >>>> processing in software or in hardware.
> 
> You can use the v4l2 controls API for that, which also supports events.
> The controls could be made read only.
> It would be interesting to list what kind of features these could be.

Looking through the controls API, they seem to be a good fit.

> 
> >> This is more interesting, but does that map well to IIO style
> >> channels anyway?  If not we are going to end up with a whole new
> >> interface which ever subsystem is used for the image side of things.
> >>>>
> >>>> The way I see it now, for processed fingerprint information, an IIO
> >>>> device could have an IIO_FINGERPRINT channel with a modifier and
> >>>> only the sensitivity threshold attribute set. We would also need
> >>>> two
> >>>> triggers: one for enrollment and one for the verification mode to
> >>>> control the device from a userspace application.
> 
> This could be all well handled with the v4l2 controls, for instance see what
> features are available in the Camera Flash controls subset
> 
> http://linuxtv.org/downloads/v4l-dvb-apis/extended-controls.html#flash-
> controls
> 
> >> Sure - what you proposed would work.  The question is whether it is
> >> the best way to do it.
> >
> > Any thoughts on this from the v4l community?
> 
> I would try it with V4L2, it seems to me most suitable subsystem for such
> devices to me.  The question is what ends up in the kernel and what in user
> space.  Anyway IMO V4L2 API is quite flexible with regards to that, due to
> wide range of devices it needs to cover.
> 
> >>>> [0]
> >>>> http://www.freedesktop.org/wiki/Software/fprint/libfprint/upekts/
> >>>>
> >>>>>> A sysfs trigger is enabled and the device starts scanning. As
> >>>>>> soon as an image is available it is written in the character device
> /dev/iio:deviceX.
> >>>>>>
> >>>>>> Userspace applications will be able to calculate the expected
> >>>>>> image size using the fingerprint attributes height, width and bit
> >>>>>> depth. Other attributes introduced for the fingerprint channel in
> >>>>>> IIO represent information that aids in the fingerprint image
> >>>>>> processing. Besides these, the proposed interface offers
> >>>>>> userspace a way to read a feedback after a scan (like the swipe was
> too slow or too fast) through a modified fingerprint_status channel.
> >>>>>>
> >>>>>> [0] http://www.spinics.net/lists/linux-iio/msg11463.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
