Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423464Ab3FVA1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 20:27:04 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52945 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161521Ab3FVA1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 20:27:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, pawel@osciak.com,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com
Subject: Re: randconfig build errors with next-20130620, in several drivers/media
Date: Sat, 22 Jun 2013 02:27:20 +0200
Message-ID: <5790855.fto4zA3B21@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <20130620185244.GA14176@krebstar.arl.arizona.edu>
References: <20130620185244.GA14176@krebstar.arl.arizona.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 20 June 2013 11:52:44 Jim Davis wrote:
> Building with the attached random configuration file generates errors in
> both
> 
> drivers/media/v4l2-core
> drivers/media/usb/uvc
> 
>   LD      init/built-in.o
> /home/jim/linux-next/linux/drivers/media/v4l2-core/videobuf2-core.c:2577:
> undefi ned reference to `video_devdata'

[snip]

> /home/jim/linux-next/linux/drivers/media/v4l2-core/videobuf2-core.c:2591:
> undefi ned reference to `v4l2_fh_release'

[snip]

> /home/jim/linux-next/linux/drivers/media/v4l2-core/videobuf2-core.c:1980:
> undefi ned reference to `v4l2_event_pending'

[snip]

> drivers/built-in.o: In function `uvc_delete':
> /home/jim/linux-next/linux/drivers/media/usb/uvc/uvc_driver.c:1606:
> undefined re ference to `usb_put_intf'

[snip]

The issue seem to be caused by USB_VIDEO_CLASS=y and VIDEO_V4L2=m && USB=m. 
I'm not sure what made that combination possible, but I haven't been able to 
reproduce it locally on next-20130620. Running make with the attached config 
turns USB_VIDEO_CLASS=y into USB_VIDEO_CLASS=m.

-- 
Regards,

Laurent Pinchart

