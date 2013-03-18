Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab3CRI3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:29:19 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2183 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab3CRI3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:29:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jon Arne =?utf-8?q?J=C3=B8rgensen?= <jonarne@jonarne.no>
Subject: Re: [RFC V1 4/8] smi2021: Add smi2021_v4l2.c
Date: Mon, 18 Mar 2013 09:29:07 +0100
User-Agent: KMail/1.13.7 (Linux/3.9.0-rc1-tschai; KDE/4.8.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        elezegarcia@gmail.com
References: <1363270024-12127-1-git-send-email-jonarne@jonarne.no> <1363270024-12127-5-git-send-email-jonarne@jonarne.no>
In-Reply-To: <1363270024-12127-5-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303180929.07864.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu March 14 2013 15:07:00 Jon Arne Jørgensen wrote:
> This file is responsible for registering the device with the v4l2 subsystem,
> and the communication with v4l2.
> Most of the v4l2 ioctls are just passed on to vidbuf2.
> 
> Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
> ---
>  drivers/media/usb/smi2021/smi2021_v4l2.c | 566 +++++++++++++++++++++++++++++++
>  1 file changed, 566 insertions(+)
>  create mode 100644 drivers/media/usb/smi2021/smi2021_v4l2.c
> 
> diff --git a/drivers/media/usb/smi2021/smi2021_v4l2.c b/drivers/media/usb/smi2021/smi2021_v4l2.c
> new file mode 100644
> index 0000000..d402093
> --- /dev/null
> +++ b/drivers/media/usb/smi2021/smi2021_v4l2.c
> @@ -0,0 +1,566 @@

...

> +int smi2021_vb2_setup(struct smi2021_dev *dev)
> +{
> +	int rc;
> +	struct vb2_queue *q;
> +
> +	q = &dev->vb_vidq;
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
> +	q->drv_priv = dev;
> +	q->buf_struct_size = sizeof(struct smi2021_buffer);
> +	q->ops = &smi2021_video_qops;
> +	q->mem_ops = &vb2_vmalloc_memops;

q->timestamp_type isn't filled in.

For that matter, neither the sequence number nor the timestamp are filled in
in v4l2_buffer during capturing.

You need to add a buf_finish op to fill those in (use v4l2_timestamp() for the
timestamp).

Regards,

	Hans
