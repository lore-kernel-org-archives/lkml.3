Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaJFMg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:36:27 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:35811 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbaJFMgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:36:24 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrzej.p@samsung.com,
        k.opasiak@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
In-Reply-To: <1412594714-535-1-git-send-email-r.baldyga@samsung.com>
Organization: http://mina86.com/
References: <1412594714-535-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141006:k.opasiak@samsung.com::zQ4qvBFBR/2R/B/D:000000000000000000000000000000000000000001aJ
X-Hashcash: 1:20:141006:andrzej.p@samsung.com::wjjy13r3/jjpRvvb:000000000000000000000000000000000000000007pw
X-Hashcash: 1:20:141006:balbi@ti.com::PyBR4K8hwSOyk3CH:0000014e+
X-Hashcash: 1:20:141006:r.baldyga@samsung.com::Yhom7lDxzreA1BBB:00000000000000000000000000000000000000001ihE
X-Hashcash: 1:20:141006:gregkh@linuxfoundation.org::Pl35Pz3FWMl3xVX1:000000000000000000000000000000000001q8V
X-Hashcash: 1:20:141006:linux-usb@vger.kernel.org::fs4p39r5JdX+lNNv:0000000000000000000000000000000000005/8X
X-Hashcash: 1:20:141006:linux-kernel@vger.kernel.org::aoVXfb8rKhBZ16sP:0000000000000000000000000000000008dAX
X-Hashcash: 1:20:141006:r.baldyga@samsung.com::bfu6BwcWmXqb/IK4:0000000000000000000000000000000000000000NJME
Date: Mon, 06 Oct 2014 14:36:15 +0200
Message-ID: <xa1tvbnx2x4w.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06 2014, Robert Baldyga <r.baldyga@samsung.com> wrote:
> Since we can compose gadgets from many functions, there is the problem
> related to gadget breakage while FunctionFS daemon being closed. In some
> cases it's strongly desired to keep gadget alive for a while, despite
> FunctionFS files are closed, to allow another functions to complete
> some presumably critical operations.
>
> For this purpose this patch introduces "zombie" mode. It can be enabled
> by setting mount option "zombie=1", and results with defering function
> closure to the moment of reopening ep0 file or filesystem umount.
>
> When ffs->state == FFS_ZOMBIE:
> - function is still binded and visible to host,
> - setup requests are automatically stalled,
> - all another transfers are refused,
> - opening ep0 causes function close, and then FunctionFS is ready for
>   descriptors and string write,
> - umount of functionfs cause function close.

However, all the ep# files will still exist on the filesystem.  This may
be a bit confusing and error-prone, no?

>
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/usb/gadget/function/f_fs.c | 25 ++++++++++++++++++++++---
>  drivers/usb/gadget/function/u_fs.h |  4 ++++
>  2 files changed, 26 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> @@ -1222,6 +1225,12 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
>  
>  		/* Interpret option */
>  		switch (eq - opts) {
> +		case 6:
> +			if (!memcmp(opts, "zombie", 6))
> +				data->zombie_mode  = !!value;

Unnecessary double space before =.

> +			else
> +				goto invalid;
> +			break;
>  		case 5:
>  			if (!memcmp(opts, "rmode", 5))
>  				data->root_mode  = (value & 0555) | S_IFDIR;
> diff --git a/drivers/usb/gadget/function/u_fs.h b/drivers/usb/gadget/function/u_fs.h
> @@ -92,6 +92,8 @@ enum ffs_state {
>  	 */
>  	FFS_ACTIVE,
>  
> +	FFS_ZOMBIE,
> +

Add comment describing the state.

>  	/*
>  	 * All endpoints have been closed.  This state is also set if
>  	 * we encounter an unrecoverable error.  The only

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
