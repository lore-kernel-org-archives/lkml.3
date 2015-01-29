Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbbA2NCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:02:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675AbbA2NCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:02:32 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-fbdev@vger.kernel.org,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, devel@linuxdriverproject.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 2/3 v3] hyperv: hyperv_fb.c: match wait_for_completion_timeout return type
References: <1422527056-24929-1-git-send-email-der.herr@hofr.at>
Date: Thu, 29 Jan 2015 14:02:09 +0100
In-Reply-To: <1422527056-24929-1-git-send-email-der.herr@hofr.at> (Nicholas Mc
	Guire's message of "Thu, 29 Jan 2015 11:24:16 +0100")
Message-ID: <87oaph7nam.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas Mc Guire <der.herr@hofr.at> writes:

> The return type of wait_for_completion_timeout is unsigned long not
> int. This patch fixes up the declarations only.
>
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>

I would be slightly better to remove ".c" from your subject like,
anyway:

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

> ---
>
> v2: fixed subject line
> v3: fixed patch description as recommended by Dan Carpenter
>     <dan.carpenter@oracle.com>
>
> Patch was compile tested only for x86_64_defconfig + CONFIG_X86_VSMP=y
> CONFIG_HYPERV=m, CONFIG_FB_HYPERV=m
>
> Patch is against 3.19.0-rc5 -next-20150123
>
>  drivers/video/fbdev/hyperv_fb.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
> index 4254336..807ee22 100644
> --- a/drivers/video/fbdev/hyperv_fb.c
> +++ b/drivers/video/fbdev/hyperv_fb.c
> @@ -415,7 +415,8 @@ static int synthvid_negotiate_ver(struct hv_device *hdev, u32 ver)
>  	struct fb_info *info = hv_get_drvdata(hdev);
>  	struct hvfb_par *par = info->par;
>  	struct synthvid_msg *msg = (struct synthvid_msg *)par->init_buf;
> -	int t, ret = 0;
> +	int ret = 0;
> +	unsigned long t;
>
>  	memset(msg, 0, sizeof(struct synthvid_msg));
>  	msg->vid_hdr.type = SYNTHVID_VERSION_REQUEST;
> @@ -488,7 +489,8 @@ static int synthvid_send_config(struct hv_device *hdev)
>  	struct fb_info *info = hv_get_drvdata(hdev);
>  	struct hvfb_par *par = info->par;
>  	struct synthvid_msg *msg = (struct synthvid_msg *)par->init_buf;
> -	int t, ret = 0;
> +	int ret = 0;
> +	unsigned long t;
>
>  	/* Send VRAM location */
>  	memset(msg, 0, sizeof(struct synthvid_msg));

-- 
  Vitaly
