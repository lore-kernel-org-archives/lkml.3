Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaCaPFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:05:11 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4007 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaCaPFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:05:09 -0400
Message-ID: <5339840D.9000702@xs4all.nl>
Date: Mon, 31 Mar 2014 17:04:45 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
CC: LKML <linux-kernel@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH 1/2] media: davinci: vpif capture: upgrade the driver
 with v4l offerings
References: <1396277573-9513-1-git-send-email-prabhakar.csengg@gmail.com> <1396277573-9513-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1396277573-9513-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

This looks really nice!

I'll do a full review on Friday, but in the meantime can you post the output
of 'v4l2-compliance -s' using the latest v4l2-compliance version? I've made
some commits today, so you need to do a git pull of v4l-utils.git.

I also have a small comment below:

On 03/31/2014 04:52 PM, Lad, Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> This patch upgrades the vpif display driver with
> v4l helpers, this patch does the following,
> 
> 1: initialize the vb2 queue and context at the time of probe
> and removes context at remove() callback.
> 2: uses vb2_ioctl_*() helpers.
> 3: uses vb2_fop_*() helpers.
> 4: uses SIMPLE_DEV_PM_OPS.
> 5: uses vb2_ioctl_*() helpers.
> 6: vidioc_g/s_priority is now handled by v4l core.
> 7: removed driver specific fh and now using one provided by v4l.
> 8: fixes checkpatch warnings.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c |  916 ++++++-------------------
>  drivers/media/platform/davinci/vpif_capture.h |   32 +-
>  2 files changed, 229 insertions(+), 719 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index 8dea0b8..76c15b3 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c

...

>  static int vpif_buffer_init(struct vb2_buffer *vb)
>  {
> -	struct vpif_cap_buffer *buf = container_of(vb,
> -					struct vpif_cap_buffer, vb);
> +	struct vpif_cap_buffer *buf = to_vpif_buffer(vb);
>  
>  	INIT_LIST_HEAD(&buf->list);
>  
>  	return 0;
>  }

Is this really necessary? I think vpif_buffer_init can just be removed.
Ditto for vpif_display.c.

Regards,

	Hans
