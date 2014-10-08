Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbaJHLxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:53:38 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:52457 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbaJHLeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:34:21 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: David Cohen <david.a.cohen@linux.intel.com>, balbi@ti.com,
        gregkh@linuxfoundation.org
Cc: r.baldyga@samsung.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [PATCH] usb: ffs: fix regression when quirk_ep_out_aligned_size flag is set
In-Reply-To: <1412727486-479-1-git-send-email-david.a.cohen@linux.intel.com>
Organization: http://mina86.com/
References: <1412727486-479-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141008:qiuxu.zhuo@intel.com::bp6pz6bzxMzZcGds:000000000000000000000000000000000000000000lrg
X-Hashcash: 1:20:141008:r.baldyga@samsung.com::m+wjlmXz7PvaQAPv:00000000000000000000000000000000000000000glW
X-Hashcash: 1:20:141008:david.a.cohen@linux.intel.com::A3E2dsJLciwV5Nko:000000000000000000000000000000000YJp
X-Hashcash: 1:20:141008:david.a.cohen@linux.intel.com::2Wnnc7dvvCQFEL3z:000000000000000000000000000000000oO8
X-Hashcash: 1:20:141008:gregkh@linuxfoundation.org::DWRQs90Y+TR1b3tU:000000000000000000000000000000000001uH+
X-Hashcash: 1:20:141008:linux-kernel@vger.kernel.org::jtKenVwO4NxMBC9V:00000000000000000000000000000000028N4
X-Hashcash: 1:20:141008:linux-usb@vger.kernel.org::PqiYIthrlepwyB6g:0000000000000000000000000000000000002Yqi
X-Hashcash: 1:20:141008:balbi@ti.com::9mLfnyeNblRhSMJG:000003yst
Date: Wed, 08 Oct 2014 13:34:16 +0200
Message-ID: <xa1tsiiysslj.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07 2014, David Cohen <david.a.cohen@linux.intel.com> wrote:
> The commit '2e4c7553cd usb: gadget: f_fs: add aio support' broke the
> quirk implemented to align buffer size to maxpacketsize on out endpoint.
> As result, functionfs does not work on Intel platforms using dwc3 driver
> (i.e. Bay Trail and Merrifield). This patch fixes the issue.
>
> This code is based on a previous Qiuxu's patch.
>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>
> Hi,
>
> Since this is a feature that worked in past, this patch is meant for 3.17
> kernel. If/when we pass review and accept it on 3.17, I'll send a version for
> stable 3.16 kernel too. It is not required for 3.14, since the regression came
> later.
>
> Br, David Cohen
>
> ---
>  drivers/usb/gadget/function/f_fs.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index 0dc3552d1360..6e2b8063b170 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -648,15 +648,26 @@ static void ffs_user_copy_worker(struct work_struct *work)
>  	if (io_data->read && ret > 0) {
>  		int i;
>  		size_t pos = 0;
> +
> +		/*
> +		 * Since req->length may be bigger than io_data->len (after
> +		 * being rounded up to maxpacketsize), we may end up with more
> +		 * data then user space has space for.
> +		 */
> +		ret = min_t(int, ret, io_data->len);
> +
>  		use_mm(io_data->mm);
>  		for (i = 0; i < io_data->nr_segs; i++) {
> +			size_t len = min_t(size_t, ret - pos,
> +					io_data->iovec[i].iov_len);
> +			if (!len)
> +				break;
>  			if (unlikely(copy_to_user(io_data->iovec[i].iov_base,
> -						 &io_data->buf[pos],
> -						 io_data->iovec[i].iov_len))) {
> +						 &io_data->buf[pos], len))) {
>  				ret = -EFAULT;
>  				break;
>  			}
> -			pos += io_data->iovec[i].iov_len;
> +			pos += len;
>  		}
>  		unuse_mm(io_data->mm);
>  	}
> @@ -794,7 +805,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
>  				goto error_lock;
>  
>  			req->buf      = data;
> -			req->length   = io_data->len;
> +			req->length   = data_len;
>  
>  			io_data->buf = data;
>  			io_data->ep = ep->ep;
> @@ -816,7 +827,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
>  
>  			req = ep->req;
>  			req->buf      = data;
> -			req->length   = io_data->len;
> +			req->length   = data_len;
>  
>  			req->context  = &done;
>  			req->complete = ffs_epfile_io_complete;
> -- 
> 2.1.0
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
