Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048Ab3BZIIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 03:08:30 -0500
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3999 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194Ab3BZII3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 03:08:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Subject: Re: [PATCH v5 7/8] v4l2: Add private controls base for SI476X
Date: Tue, 26 Feb 2013 09:07:24 +0100
User-Agent: KMail/1.13.7 (Linux/3.8.0-rc3-tschai; KDE/4.8.4; x86_64; ; )
Cc: mchehab@redhat.com, sameo@linux.intel.com, perex@perex.cz, tiwai@suse.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1361860734-21666-1-git-send-email-andrew.smirnov@gmail.com> <1361860734-21666-8-git-send-email-andrew.smirnov@gmail.com>
In-Reply-To: <1361860734-21666-8-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302260907.24281.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue February 26 2013 07:38:53 Andrey Smirnov wrote:
> Add a base to be used for allocation of all the SI476X specific
> controls in the corresponding driver.
> 
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> ---
>  include/uapi/linux/v4l2-controls.h |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 296d20e..133703d 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -147,6 +147,10 @@ enum v4l2_colorfx {
>   * of controls. We reserve 16 controls for this driver. */
>  #define V4L2_CID_USER_MEYE_BASE			(V4L2_CID_USER_BASE + 0x1000)
>  
> +/* The base for the si476x driver controls. See include/media/si476x.h for the list
> + * of controls. */
> +#define V4L2_CID_USER_SI476X_BASE		(V4L2_CID_USER_BASE + 0x2000)

Please make this consecutive to MEYE_BASE, so '+ 0x1010'. That makes it easy
to keep track of these control ranges.

Regards,

	Hans

> +
>  /* MPEG-class control IDs */
>  
>  #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
> 
