Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaA1JJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:09:20 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36722 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750855AbaA1JJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:09:16 -0500
Date: Tue, 28 Jan 2014 11:08:41 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Daniel Jeong <gshark.jeong@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFCv2,1/2] v4l2-controls.h: add addtional Flash fault bits
Message-ID: <20140128090841.GG13820@valkosipuli.retiisi.org.uk>
References: <1390892158-5646-1-git-send-email-gshark.jeong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390892158-5646-1-git-send-email-gshark.jeong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Tue, Jan 28, 2014 at 03:55:57PM +0900, Daniel Jeong wrote:
> Add additional FLASH Fault bits to dectect faults from chip.
> Some Flash drivers support UVLO, IVFM, NTC Trip faults.
> UVLO : 	Under Voltage Lock Out Threshold crossed
> IVFM : 	IVFM block reported and/or adjusted LED current Input Voltage Flash Monitor trip threshold
> NTC  : 	NTC Threshold crossed. Many Flash drivers have a pin and the fault bit to 
> serves as a threshold detector for negative temperature coefficient (NTC) thermistors.
> 
> Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
> ---
>  include/uapi/linux/v4l2-controls.h |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 1666aab..01d730c 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -803,6 +803,9 @@ enum v4l2_flash_strobe_source {
>  #define V4L2_FLASH_FAULT_SHORT_CIRCUIT		(1 << 3)
>  #define V4L2_FLASH_FAULT_OVER_CURRENT		(1 << 4)
>  #define V4L2_FLASH_FAULT_INDICATOR		(1 << 5)
> +#define V4L2_FLASH_FAULT_UVLO			(1 << 6)
> +#define V4L2_FLASH_FAULT_IVFM			(1 << 7)
> +#define V4L2_FLASH_FAULT_NTC_TRIP		(1 << 8)

I object adding a new fault which is essentially the same as an existing
fault, V4L2_FLASH_FAULT_OVER_TEMPERATURE.

As the practice has been to use human-readable names for the faults, I'd
also suggest using V4L2_FLASH_FAULT_UNDER_VOLTAGE instead of
V4L2_FLASH_FAULT_UVLO.

What's the IVFM block and what does it do?

>  #define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
>  #define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
