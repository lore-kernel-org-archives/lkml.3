Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbaLECP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 21:15:28 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:50098 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933123AbaLECP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 21:15:26 -0500
Message-ID: <5481153B.4070609@kernel.org>
Date: Fri, 05 Dec 2014 02:15:23 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Teodora Baluta <teodora.baluta@intel.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Introduce IIO interface for fingerprint sensors
References: <1417698017-13835-1-git-send-email-teodora.baluta@intel.com>
In-Reply-To: <1417698017-13835-1-git-send-email-teodora.baluta@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/12/14 13:00, Teodora Baluta wrote:
> This patchset adds support for fingerprint sensors through the IIO interface.
> This way userspace applications collect information in a uniform way. All
> processing would be done in the upper layers as suggested in [0].
> 
> In order to test out this proposal, a minimal implementation for UPEK's
> TouchChip Fingerprint Sensor via USB is also available. Although there is an
> existing implementation in userspace for USB fingerprint devices, including this
> particular device, the driver represents a proof of concept of how fingerprint
> sensors could be integrated in the IIO framework regardless of the used bus. For
> lower power requirements, the SPI bus is preferred and a kernel driver
> implementation makes more sense.

So why not v4l?  These are effectively image sensors.. 
> 
> A sysfs trigger is enabled and the device starts scanning. As soon as an image
> is available it is written in the character device /dev/iio:deviceX.
> 
> Userspace applications will be able to calculate the expected image size using
> the fingerprint attributes height, width and bit depth. Other attributes
> introduced for the fingerprint channel in IIO represent information that aids in
> the fingerprint image processing. Besides these, the proposed interface offers
> userspace a way to read a feedback after a scan (like the swipe was too slow or
> too fast) through a modified fingerprint_status channel.
> 
> [0] http://www.spinics.net/lists/linux-iio/msg11463.html
> 
> Teodora Baluta (3):
>   iio: core: add support for fingerprint devices
>   iio: core: change channel's storagebits/realbits to u32
>   iio: fingerprint: add fingerprint sensor via USB
> 
>  Documentation/ABI/testing/sysfs-bus-iio |  51 +++
>  drivers/iio/Kconfig                     |   1 +
>  drivers/iio/Makefile                    |   1 +
>  drivers/iio/fingerprint/Kconfig         |  15 +
>  drivers/iio/fingerprint/Makefile        |   5 +
>  drivers/iio/fingerprint/fp_tc.c         | 162 +++++++++
>  drivers/iio/fingerprint/fp_tc.h         |  22 ++
>  drivers/iio/fingerprint/fp_tc_usb.c     | 618 ++++++++++++++++++++++++++++++++
>  drivers/iio/fingerprint/fp_tc_usb.h     | 144 ++++++++
>  drivers/iio/industrialio-core.c         |   9 +
>  include/linux/iio/iio.h                 |  11 +-
>  include/linux/iio/types.h               |  10 +
>  12 files changed, 1047 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/iio/fingerprint/Kconfig
>  create mode 100644 drivers/iio/fingerprint/Makefile
>  create mode 100644 drivers/iio/fingerprint/fp_tc.c
>  create mode 100644 drivers/iio/fingerprint/fp_tc.h
>  create mode 100644 drivers/iio/fingerprint/fp_tc_usb.c
>  create mode 100644 drivers/iio/fingerprint/fp_tc_usb.h
> 

