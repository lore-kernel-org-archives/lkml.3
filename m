Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965436Ab3DPVce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 17:32:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965337Ab3DPVcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 17:32:33 -0400
Message-ID: <516DC363.7050600@redhat.com>
Date: Tue, 16 Apr 2013 18:32:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, viro@zeniv.linux.org.uk,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 16/28] zoran: Don't print proc_dir_entry data in debug
 [RFC]
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk> <20130416182654.27773.74830.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182654.27773.74830.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 16-04-2013 15:26, David Howells escreveu:
> Don't print proc_dir_entry data in debug as we're soon to have no direct
> access to the contents of the PDE.  Print what was put in there instead.

Let me just apply this simple one, as it doesn't depend on the rest of the
patches in this series.

>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: mjpeg-users@lists.sourceforge.net
> cc: linux-media@vger.kernel.org
> ---
>
>   drivers/media/pci/zoran/zoran_procfs.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/pci/zoran/zoran_procfs.c b/drivers/media/pci/zoran/zoran_procfs.c
> index 07a104d..f7ceee0 100644
> --- a/drivers/media/pci/zoran/zoran_procfs.c
> +++ b/drivers/media/pci/zoran/zoran_procfs.c
> @@ -201,7 +201,7 @@ zoran_proc_init (struct zoran *zr)
>   		dprintk(2,
>   			KERN_INFO
>   			"%s: procfs entry /proc/%s allocated. data=%p\n",
> -			ZR_DEVNAME(zr), name, zr->zoran_proc->data);
> +			ZR_DEVNAME(zr), name, zr);

It is just a debug message, so changing it looks fine.

>   	} else {
>   		dprintk(1, KERN_ERR "%s: Unable to initialise /proc/%s\n",
>   			ZR_DEVNAME(zr), name);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

