Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbbAZKYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:24:53 -0500
Received: from mga03.intel.com ([134.134.136.65]:59311 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbbAZKYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:24:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,468,1418112000"; 
   d="scan'208";a="667545371"
From: "Baluta, Teodora" <teodora.baluta@intel.com>
To: "floe@butterbrot.org" <floe@butterbrot.org>
CC: "s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 0/3] Introduce IIO interface for fingerprint sensors
Thread-Topic: [RFC PATCH 0/3] Introduce IIO interface for fingerprint sensors
Thread-Index: AQHQD8JdQ+QdbPbvv0iTNHDhYqBWSZyAQyGAgAV+ygCAD+Q9AIAMNCWAgB5BKgCAAZkAAIAMMOIggABTZgCABExTgA==
Date: Mon, 26 Jan 2015 10:24:44 +0000
Message-ID: <1422267881.2662.39.camel@bebop>
References: <1417698017-13835-1-git-send-email-teodora.baluta@intel.com>
	 <5481153B.4070609@kernel.org> <1418047828.18463.10.camel@bebop>
	 <54930604.1020607@metafoo.de> <549D42BD.1050901@kernel.org>
	 <1421255642.31900.4.camel@bebop> <54B7FAF2.8080207@samsung.com>
	 <A2E3DE9C026DE6469D89C3A4C6C219390A89FE37@IRSMSX107.ger.corp.intel.com>
	 <54C27AE4.4020702@butterbrot.org>
In-Reply-To: <54C27AE4.4020702@butterbrot.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.104.145]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA469D584A0FC04AA09A044CD159FCE3@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0QAOwCx016207

Hi Florian,

Thanks for the reply!

On Vi, 2015-01-23 at 17:46 +0100, Florian Echtler wrote:
> Hello Teodora,
> 
> On 23.01.2015 14:05, Baluta, Teodora wrote:
> > The fingerprint sensor acts more like a scanner device, so the
> > closest type is the V4L2_CAP_VIDEO_CAPTURE. However, this is not a
> > perfect match because the driver only sends an image, once, when
> > triggered. Would it be a better alternative to define a new
> > capability type? Or it would be acceptable to simply have a video
> > device with no frame buffer or frame rate and the user space
> > application to read from the character device /dev/videoX?
> Sorry if I jump in here right in the middle of this discussion, but some
> time ago, I wrote a fingerprint sensor driver for the Siemens ID Mouse
> (still part of the kernel AFAICT) which acts as a misc device and just
> creates a character device node that can be used to directly read a PGM
> file.

I agree that it would be the simplest approach if you want a USB
fingerprint driver in kernel space, but I was looking for a way to
support fingerprint devices regardless of bus (there's also fingerprint
devices that use SPI) and provide a common interface for user space
applications.

The actual driver for UPEK's TouchChip sensor is just a proof of concept
on how the interface would work, rather than the final goal. There's
already a library that enables USB-only fingerprint devices (libfprint).
> 
> Maybe this would be a slightly simpler approach than pulling in all the
> streaming-optimized features of V4L2?

I agree that for a fingerprint device, the V4L2 subsystem offers too
much (the initial RFC is for IIO).

Thanks,
Teodora

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
