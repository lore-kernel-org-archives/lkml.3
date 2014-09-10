Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaIJRLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:11:07 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43680 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192AbaIJRLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:11:03 -0400
X-Sasl-enc: QXERQWD1Ht4o/FnyPnYYo0mh8gl4vnt869WTNTNkzBR+ 1410369060
Date: Wed, 10 Sep 2014 10:10:13 -0700
From: Greg KH <greg@kroah.com>
To: Maciej Matraszek <m.matraszek@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2] [media] v4l2-common: fix overflow in
 v4l_bound_align_image()
Message-ID: <20140910171013.GA14048@kroah.com>
References: <1410367869-27688-1-git-send-email-m.matraszek@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410367869-27688-1-git-send-email-m.matraszek@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 06:51:09PM +0200, Maciej Matraszek wrote:
> Fix clamp_align() used in v4l_bound_align_image() to prevent overflow when
> passed large value like UINT32_MAX. In the current implementation:
>     clamp_align(UINT32_MAX, 8, 8192, 3)
> returns 8, because in line:
>     x = (x + (1 << (align - 1))) & mask;
> x overflows to (-1 + 4) & 0x7 = 3, while expected value is 8192.
> 
> v4l_bound_align_image() is heavily used in VIDIOC_S_FMT
> and VIDIOC_SUBDEV_S_FMT ioctls handlers, and documentation of the latter
> explicitly states that:
> 
> "The modified format should be as close as possible to the original request."
>   -- http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-subdev-g-fmt.html
> 
> Thus one would expect, that passing UINT32_MAX as format width and height
> will result in setting maximum possible resolution for the device.
> Particularly, when the driver doesn't support VIDIOC_ENUM_FRAMESIZES ioctl,
> which is common in the codebase.
> 
> Fixes: b0d3159be9a3 ("V4L/DVB (11901): v4l2: Create helper function for bounding and aligning images")
> Signed-off-by: Maciej Matraszek <m.matraszek@samsung.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> ---

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
