Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbaFYJxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:53:43 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:56931 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaFYJxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:53:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: Vincent Palatin <vpalatin@chromium.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olofj@chromium.org>,
        Zach Kuznia <zork@chromium.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v2] V4L: uvcvideo: Add support for relative pan/tilt controls
Date: Wed, 25 Jun 2014 11:54:30 +0200
Message-ID: <8119752.rPOQIYa4Af@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.21-gentoo-r1; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACHYQ-rSk6etrX8RXF4w7aA_LJ9nzGtfJMOjhBOg49BZ4gaWgw@mail.gmail.com>
References: <539FDC4F.4030000@redhat.com> <1403016348-10129-1-git-send-email-vpalatin@chromium.org> <CACHYQ-rSk6etrX8RXF4w7aA_LJ9nzGtfJMOjhBOg49BZ4gaWgw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pawel,

On Wednesday 25 June 2014 11:46:24 Pawel Osciak wrote:
> On Tue, Jun 17, 2014 at 11:45 PM, Vincent Palatin wrote:
> > Map V4L2_CID_TILT_RELATIVE and V4L2_CID_PAN_RELATIVE to the standard UVC
> > CT_PANTILT_RELATIVE_CONTROL terminal control request.
> > 
> > Tested by plugging a Logitech ConferenceCam C3000e USB camera
> > and controlling pan/tilt from the userspace using the VIDIOC_S_CTRL ioctl.
> > Verified that it can pan and tilt at the same time in both directions.
> > 
> > Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> > 
> > Change-Id: I7b70b228e5c0126683f5f0be34ffd2807f5783dc
> > ---
> > 
> > Changes
> > v2: fix control request name in description.
> 
> The patch looks good, but I have a more general comment for everyone to
> consider. This doesn't match the expected functionality of
> controls V4L2_CID_PAN/TILT_RELATIVE. This is basically an on/off switch for
> pan/tilt, which once enabled will keep going until turned off (or I'm
> guessing until the maximum pan/tilt is reached), while the controls are
> supposed to expose an ability to turn the camera by a specified amount.
> Here the amount will also be ignored...

I agree with you here, and this mismatch between the V4L and UVC controls is 
the reason why I haven't implemented relative pan/tilt support.

> Given that this is a standard UVC control, perhaps we need new V4L2
> controls for it, as I'm assuming we can't change the meaning of existing
> controls?

We could extend the meaning of the controls to cover the UVC behaviour in a 
device-specific fashion, but that would be confusing for applications, so new 
controls might be a better idea.

-- 
Regards,

Laurent Pinchart

