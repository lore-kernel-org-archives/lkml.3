Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3H1NT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:19:56 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:65166 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab3H1NTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:19:55 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfec7f4-b7f0a6d000007b1b-16-521df8f94677
Content-transfer-encoding: 8BIT
Message-id: <521DF8F6.8020003@samsung.com>
Date: Wed, 28 Aug 2013 15:19:50 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801
 Thunderbird/17.0.8
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] videobuf2: Fix vb2_write prototype
References: <1377679169-9374-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1377679169-9374-1-git-send-email-ricardo.ribalda@gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t/xy7o/f8gGGazcxm1xtukNu8XlXXPY
	LHo2bGW1uLhO3mLK25/sFl3d85gc2Dx2zrrL7vH410s2j74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mp43r2AseCxRMWBKR/ZGhhXi3QxcnJICJhINDydyAphi0lcuLeerYuRi0NIYCmjxPMr
	rxhBErwCghI/Jt9j6WLk4GAWkJc4cikbJMwsYCbxqGUdM0R9M5PE6Tt3oeq1JD58n8QEYrMI
	qEpsvdnPAmKzCRhKdL3tYgOxRQVCJXoubQezRQTMJS5/6ARbzCywm1Gi/fshZpCEMFBixdIj
	YIOEBDwkVr35BGZzCnhKTNz5gm0Co8AsJPfNQrhvFpL7FjAyr2IUTS1NLihOSs811CtOzC0u
	zUvXS87P3cQICecvOxgXH7M6xCjAwajEw2uxWSZIiDWxrLgy9xCjBAezkggv/3bZICHelMTK
	qtSi/Pii0pzU4kOMTBycUg2MdfpOpXyiJVbOArq1GeJOYc7aMw6L9XRsSv67xNCxUm76Uekf
	+TmvVXbILE1bfkN3m7G6C2+GtZ7cLb33F4vn/bjZt2f2Qefv8hs6F/s9+iH3aU74PsH0C0uz
	HC/br44StbLLrE1e4NDo3uWwYt3B0xwT+Dr1VHa76deEfS6dc/RmxnH7vE1KLMUZiYZazEXF
	iQD0vsASRQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 8/28/2013 10:39 AM, Ricardo Ribalda Delgado wrote:
> struct v4_file_operations defines the data param as
> const char __user *data but on vb2 is defined as
> char __user *data.
>
> This patch fixes the warnings produced by this. ie:
>
> drivers/qtec/qtec_xform.c:817:2: warning: initialization from
> incompatible pointer type [enabled by default]
> drivers/qtec/qtec_xform.c:817:2: warning: (near initialization for
> 		‘qtec_xform_v4l_fops.write’) [enabled by default]
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-core.c |    7 ++++---
>   include/media/videobuf2-core.h           |    4 ++--
>   2 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 9fc4bab..b3f86c1 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2438,10 +2438,11 @@ size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
>   }
>   EXPORT_SYMBOL_GPL(vb2_read);
>   
> -size_t vb2_write(struct vb2_queue *q, char __user *data, size_t count,
> +size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
>   		loff_t *ppos, int nonblocking)
>   {
> -	return __vb2_perform_fileio(q, data, count, ppos, nonblocking, 0);
> +	return __vb2_perform_fileio(q, (char __user *) data, count,
> +							ppos, nonblocking, 0);
>   }
>   EXPORT_SYMBOL_GPL(vb2_write);
>   
> @@ -2595,7 +2596,7 @@ int vb2_fop_release(struct file *file)
>   }
>   EXPORT_SYMBOL_GPL(vb2_fop_release);
>   
> -ssize_t vb2_fop_write(struct file *file, char __user *buf,
> +ssize_t vb2_fop_write(struct file *file, const char __user *buf,
>   		size_t count, loff_t *ppos)
>   {
>   	struct video_device *vdev = video_devdata(file);
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index d88a098..06ec850 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -388,7 +388,7 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
>   unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
>   size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
>   		loff_t *ppos, int nonblock);
> -size_t vb2_write(struct vb2_queue *q, char __user *data, size_t count,
> +size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
>   		loff_t *ppos, int nonblock);
>   
>   /**
> @@ -488,7 +488,7 @@ int vb2_ioctl_expbuf(struct file *file, void *priv,
>   
>   int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma);
>   int vb2_fop_release(struct file *file);
> -ssize_t vb2_fop_write(struct file *file, char __user *buf,
> +ssize_t vb2_fop_write(struct file *file, const char __user *buf,
>   		size_t count, loff_t *ppos);
>   ssize_t vb2_fop_read(struct file *file, char __user *buf,
>   		size_t count, loff_t *ppos);

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland


