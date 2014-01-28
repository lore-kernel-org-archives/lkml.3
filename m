Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaA1HEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 02:04:46 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2757 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaA1HEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 02:04:44 -0500
Message-ID: <52E75663.1080604@xs4all.nl>
Date: Tue, 28 Jan 2014 08:04:03 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Daniel Jeong <gshark.jeong@gmail.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFCv2,1/2] v4l2-controls.h: add addtional Flash fault bits
References: <1390892158-5646-1-git-send-email-gshark.jeong@gmail.com>
In-Reply-To: <1390892158-5646-1-git-send-email-gshark.jeong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 07:55 AM, Daniel Jeong wrote:
> Add additional FLASH Fault bits to dectect faults from chip.
> Some Flash drivers support UVLO, IVFM, NTC Trip faults.
> UVLO : 	Under Voltage Lock Out Threshold crossed
> IVFM : 	IVFM block reported and/or adjusted LED current Input Voltage Flash Monitor trip threshold
> NTC  : 	NTC Threshold crossed. Many Flash drivers have a pin and the fault bit to 
> serves as a threshold detector for negative temperature coefficient (NTC) thermistors.

Please document these new flags as well in Documentation/DocBook/media/v4l/controls.xml.

Regards,

	Hans

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
>  
>  #define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
>  #define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)
> 

